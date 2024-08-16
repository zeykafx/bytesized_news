import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import {getFirestore} from "firebase-admin/firestore";
import {initializeApp} from "firebase-admin/app";
import {OpenAI} from "openai";
import {defineString} from "firebase-functions/params";


initializeApp();
const db = getFirestore();
const openaiKey = defineString("OPENAI_API_KEY");


export const helloWorld = onCall({region: "europe-west1"}, async (request) => {
  const articleUrl = request.data.text;
  const uid = request.auth?.uid;
  logger.info("Request to summarize " + articleUrl + " from user ID: " + uid);

  // get the user's tier
  const user = await db.doc(`users/${uid}`).get();
  const tier = user.data()?.tier;
  if (tier !== "premium") {
    return {error: "Error: You need to upgrade to premium to use this feature"};
  }

  const openai: OpenAI = new OpenAI({apiKey: openaiKey.value()});

  // check that the summary doesn't already exist in firestore
  const existingSummary = await db.collection("summaries")
    .where("url", "==", articleUrl).get();

  if (!existingSummary.empty) {
    logger.info("Summary already exists: " + existingSummary.docs[0].id);
    return {summary: existingSummary.docs[0].data().summary, id: existingSummary.docs[0].id};
  }

  // download the article's html
  const article = await fetch(articleUrl);
  const articleText = await article.text();

  // create the summary with openai
  const completion = await openai.chat.completions.create({
    model: "gpt-4o-mini",
    messages: [
      {
        role: "system",
        content: "Summarize the article in 3 sentences. Stick to the information in the article. " +
          "Do not add any new information, if an article refers to Twitter as 'X' do not do the same," +
          " instead refer to it as 'Twitter'.",
      },
      {
        role: "user",
        content: articleText,
      },
    ],
    temperature: 0.0,
  });

  const summary = completion.choices[0].message.content;

  // save the summary in firestore
  const res = await db.collection("summaries").add({
    url: articleUrl,
    summary: summary,
    generatedAt: new Date().getTime(),
  });

  logger.info("Summary created: " + res.id);
  return {summary: summary, id: res.id};
});


export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  logger.info("User created: " + user.uid);
  // create a firestore document for the user
  const res = await db.doc(`users/${user.uid}`).set({
    email: user.email,
    created: new Date().getTime(),
    tier: "free",
  });
  logger.info("Document created: " + res.writeTime);
  return res;
});
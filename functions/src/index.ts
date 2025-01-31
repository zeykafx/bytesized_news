import {onCall} from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import {getFirestore} from "firebase-admin/firestore";
import {initializeApp} from "firebase-admin/app";
import {OpenAI} from "openai";
import {defineString} from "firebase-functions/params";


initializeApp();
const db = getFirestore();
// const openaiKey = defineString("OPENAI_API_KEY");
const groqKey = defineString("GROQ_API_KEY");


export const summarize = onCall({region: "europe-west1"}, async (request) => {
  const articleUrl: string = request.data.text;
  const title: string = request.data.title;
  const content = request.data.content;
  const uid = request.auth?.uid;
  logger.info("Request to summarize " + articleUrl + " from user ID: " + uid);

  // get the user's tier
  const user = await db.doc(`users/${uid}`).get();
  const tier = user.data()?.tier;
  if (tier !== "premium") {
    return {error: "Error: You need to upgrade to premium to use this feature"};
  }

  const openai: OpenAI = new OpenAI({apiKey: groqKey.value(), baseURL: "https://api.groq.com/openai/v1"});

  // check that the summary doesn't already exist in firestore
  const existingSummary = await db.collection("summaries")
    .where("url", "==", articleUrl).get();

  if (!existingSummary.empty) {
    logger.info("Summary already exists: " + existingSummary.docs[0].id);
    return {summary: existingSummary.docs[0].data().summary, id: existingSummary.docs[0].id};
  }

  // download the article's html
  // const article = await fetch(articleUrl);
  // const articleText = await article.text();

  // check the length of the article
  if (content.length > 15000) {
    logger.info("Article too long: " + content.length);
    return {error: "Error: The article is too long. Please provide a shorter article."};
  }

  // create the summary with openai
  const completion = await openai.chat.completions.create({
    // model: "gpt-4o-mini",
    model: "llama-3.2-1b-preview",
    messages: [
      {
        role: "system",
        content: "Summarize the article in 3 sentences, NOT MORE. Stick to the information in the article. " +
          "Do not add any new information, if an article refers to Twitter as 'X' do not do the same," +
          " instead refer to it as 'Twitter. Always provide a translation of the units of measurements " +
          "used in the article (do so in parentheses). ONLY OUTPUT THE SUMMARY" +
          "NO INTRODUCTION LIKE \"Here is a summary...\"!",
      },
      {
        role: "user",
        content: content,
      },
    ],
    temperature: 0.0,
  });

  const summary = completion.choices[0].message.content;

  // save the summary in firestore
  const res = await db.collection("summaries").add({
    url: articleUrl,
    title: title,
    summary: summary,
    generatedAt: new Date().getTime(),
    // expires in a week
    expirationTimestamp: new Date().getTime() + 7 * 24 * 60 * 60 * 1000,
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
    interests: [
      "Technology",
      "Politics",
    ],
    feeds: [],
    builtUserProfileDate: null,
    suggestionsLeftToday: 10,
    lastSuggestionDate: null,
    summariesLeftToday: 50,
    lastSummaryDate: null,
  });
  logger.info("Document created: " + res.writeTime);
  return res;
});

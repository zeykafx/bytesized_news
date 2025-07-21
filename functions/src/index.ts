import { onCall } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import * as functions from "firebase-functions";
import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { initializeApp } from "firebase-admin/app";
import { OpenAI } from "openai";
import { defineString } from "firebase-functions/params";

initializeApp();
const db = getFirestore();
// const openaiKey = defineString("OPENAI_API_KEY");
const groqKey = defineString("GROQ_API_KEY");
const openai: OpenAI = new OpenAI({
  apiKey: groqKey.value(),
  baseURL: "https://api.groq.com/openai/v1",
});
const ENFORCE_APPCHECK = false; // TODO: change back
const maxCharsForOneSummary = 15000;

export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  logger.info("User created: " + user.uid);

  const limits = await db.collection("flags").doc("limits").get();
  const suggestionsLimit = limits.data()?.suggestions || 20;
  const summariesLimit = limits.data()?.summaries || 100;

  // create a firestore document for the user
  const res = await db.doc(`users/${user.uid}`).set({
    email: user.email,
    created: new Date().getTime(),
    tier: "free",
    interests: ["Technology", "Politics"],
    feeds: [],
    builtUserProfileDate: null,
    suggestionsLeftToday: suggestionsLimit,
    lastSuggestionDate: null,
    summariesLeftToday: summariesLimit,
    lastSummaryDate: null,
    deviceIds: null,
  });
  logger.info("Document created: " + res.writeTime);
  return res;
});

export const onUserDelete = functions.auth.user().onDelete(async (user) => {
  logger.info("User deleted: " + user.uid);

  // delete the user's document
  const res = await db.doc(`users/${user.uid}`).delete();
  logger.info("Document deleted: " + res.writeTime);
  return res;
});

// Reset quotas daily via Cloud Scheduler
exports.resetQuotas = functions.pubsub
  .schedule("0 0 * * *")
  .timeZone("Europe/Brussels")
  .onRun(async (_) => {
    // Get all user documents
    const usersSnapshot = await db.collection("users").get();
    const limits = await db.collection("flags").doc("limits").get();
    const suggestionsLimit = limits.data()?.suggestions || 20;
    const summariesLimit = limits.data()?.summaries || 100;

    const batchSize = 500; // Firestore batch limit
    const userDocs = usersSnapshot.docs;

    // Process in batches to avoid Firestore limits
    for (let i = 0; i < userDocs.length; i += batchSize) {
      const batch = db.batch();
      const chunk = userDocs.slice(i, i + batchSize);

      chunk.forEach((userDoc) => {
        batch.update(userDoc.ref, {
          suggestionsLeftToday: suggestionsLimit,
          summariesLeftToday: summariesLimit,
        });
      });

      await batch.commit();
      logger.info(`Processed batch ${i / batchSize + 1}`);
    }
  });

export const onDeviceIdAdded = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const newDeviceId: string = request.data.deviceId;
    const uid = request.auth?.uid;
    logger.info(`User ${uid} added deviceId ${newDeviceId}`);

    // Check if that id is used by another user
    // If so, return an error
    const deviceRef = db
      .collection("users")
      .where("deviceIds", "array-contains", newDeviceId);
    const deviceSnapshot = await deviceRef.get();
    if (!deviceSnapshot.empty) {
      const otherUser = deviceSnapshot.docs[0].id;
      logger.info(
        `Device ID ${newDeviceId} is already in use by user ${otherUser}`,
      );
      return { error: "Device ID already in use" };
    }

    // Add the device ID to the user's document
    const userRef = db.doc(`users/${uid}`);
    await userRef.update({
      deviceIds: FieldValue.arrayUnion(newDeviceId),
    });
    return { success: true };
  },
);

export const summarize = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const articleUrl: string = request.data.text;
    const title: string = request.data.title;
    const content = request.data.content;
    const uid = request.auth?.uid;
    logger.info("Request to summarize " + articleUrl + " from user ID: " + uid);

    const userRef = db.doc(`users/${uid}`);
    const user = await userRef.get();
    const userData = user.data();

    let summariesToConsume = 1;

    // check if the user has any summaries left today
    const summariesLeftToday = userData?.summariesLeftToday;
    if (summariesLeftToday <= 0) {
      return { error: "Error: You have reached the daily limit of summaries" };
    }

    // check the length of the article
    if (content.length > maxCharsForOneSummary) {
      // will consume more than 1 summary since the content is so long
      summariesToConsume += Math.ceil(
        content.length / maxCharsForOneSummary - 1,
      );
      // logger.info("Article too long: " + content.length);
      // return {
      //   error:
      //     "Error: The article is too long. Please provide a shorter article.",
      // };
    }

    // update the user's summary count
    await userRef.update({
      lastSummaryDate: new Date().getTime(),
      summariesLeftToday: FieldValue.increment(-summariesToConsume),
    });

    // create the summary with openai
    const completion = await openai.chat.completions.create({
      // model: "gpt-4o-mini",
      model: "llama-3.1-8b-instant",
      messages: [
        {
          role: "system",
          content: `
        Summarize the article in 6 sentences, DO NOT OUTPUT A SUMMARY LONGER
        THAN 6 SENTENCES!! Stick to the information in the article.
        Do not add any new information, if an article refers to Twitter as 'X' do not do the same,
        instead refer to it as 'Twitter. Always provide a translation of the units of measurements
        used in the article (only translate between metric and imperial) (do so in parentheses).
        ONLY OUTPUT THE SUMMARY, NO INTRODUCTION LIKE "Here is a summary..."!
        If you can, use bullet points with proper formatting such that each bullet point starts on its own line.
        `,
        },
        {
          role: "user",
          content: content,
        },
      ],
      temperature: 0.3,
    });

    const summary = completion.choices[0].message.content;

    // save the summary in firestore
    const res = await db.collection("summaries").add({
      url: articleUrl,
      title: title,
      summary: summary,
      generatedAt: new Date().getUTCMilliseconds(),
      // expires in a month
      expirationTimestamp:
        new Date().getUTCMilliseconds() + 30 * 24 * 60 * 60 * 1000,
    });

    logger.info("Summary created: " + res.id);
    return {
      summary: summary,
      id: res.id,
      summariesLeftToday: summariesLeftToday - 1,
    };
  },
);

/**
 * Provides news suggestions based on a user's preferred categories, reading habits, and today's unread articles.
 *
 * This function is a Firebase Callable Function. It checks the user's subscription tier and uses OpenAI
 * to generate a curated list of up to five relevant articles. The resulting suggestions are returned
 * as a JSON string.
 *
 * @function getNewsSuggestions
 * @param {CallableRequest} request - The Firebase request object containing user data,
 * including today's articles and user preferences
 * @returns {Promise<object>} An object containing a JSON-formatted list of news suggestions or an error message
 */
export const getNewsSuggestions = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const todaysArticles: string = request.data.todaysArticles;
    const mostReadFeedsString: string = request.data.mostReadFeedsString;
    const userInterests: string = request.data.userInterests;
    const uid = request.auth?.uid;
    logger.info("Request to get news suggestions for user ID: " + uid);

    const userRef = db.doc(`users/${uid}`);
    const user = await userRef.get();
    const userData = user.data();

    // check if the user has any summaries left today
    const suggestionsLeftToday = userData?.suggestionsLeftToday;
    if (suggestionsLeftToday <= 0) {
      return {
        error: "Error: You have reached the daily limit of suggestions",
      };
    }

    // update the user's summary count
    await userRef.update({
      lastSuggestionDate: new Date().getTime(),
      suggestionsLeftToday: FieldValue.increment(-1),
    });

    // create the summary with openai
    const completion = await openai.chat.completions.create({
      model: "llama-3.1-8b-instant",
      response_format: {
        type: "json_object",
      },
      messages: [
        {
          role: "system",
          content: `
        You are a helpful news suggestion AI, you will receive a list of categories that the user is interested in,
        the feeds that the user reads the most, and today's unread articles
        You must return a list of the top 5 most interesting articles (in json format) for this user based on their
        interests while considering which articles would get the most clicks online and their interest in that feed.
        the article's IDs must not be changed (Ignore any article advertising deals/coupons or podcasts!)
        The format must be the following: A json object with the key 'articles' which is an array of json object, each
        object has an ID (number), a title (string) and the feed name (string)
        `,
        },
        {
          role: "user",
          content: `News Interests: ${userInterests}`,
        },
        {
          role: "user",
          content: `Most Read Feeds: ${mostReadFeedsString}`,
        },
        {
          role: "user",
          content: `Today's articles: ${todaysArticles}`,
        },
      ],
      temperature: 0.6,
    });

    const output = completion.choices[0].message.content || "";

    logger.info("Created suggestion for user " + uid);
    return {
      suggestions: output,
      suggestionsLeftToday: suggestionsLeftToday - 1,
    };
  },
);

/**
 * A Cloud Function (Callable) that, given a feed name and link,
 * returns a JSON string containing inferred content categories
 * under the "categories" key.
 */
export const analyzeFeedCategories = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const feedName: string = request.data.feedName;
    const feedLink: string = request.data.feedLink;
    logger.info(
      `Analyzing categories for feed name: ${feedName}, link: ${feedLink}`,
    );

    const completion = await openai.chat.completions.create({
      model: "llama-3.1-8b-instant",
      response_format: {
        type: "json_object",
      },
      messages: [
        {
          role: "system",
          content: `
          Analyze the following RSS Feed name and URL to infer relevant content categories.
          Consider keywords in both the name and URL path/domain. Return a JSON array of 3-5
          most relevant categories under a "categories" key. Only output JSON.
          Example response for "TechCrunch": {"categories": ["Technology", "Startups", "Business", "Innovation"]}
        `,
        },
        {
          role: "user",
          content: `Name: ${feedName}, Link: ${feedLink}`,
        },
      ],
      temperature: 0.6,
    });

    const result = completion.choices[0]?.message?.content || "";

    // Return the raw JSON string (e.g., {"categories": [...]})
    // The client can parse it as needed
    return { categoriesJson: result };
  },
);

/**
 * A Cloud Function (Callable) that, given a list of most read feeds,
 * returns a JSON string containing inferred user interests
 * under the "interests" key.
 */
export const buildUserInterests = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const mostReadFeedsString: string = request.data.mostReadFeedsString;
    logger.info(
      `Building user interests based on most read feeds: ${mostReadFeedsString}`,
    );

    const completion = await openai.chat.completions.create({
      model: "llama-3.1-8b-instant",
      response_format: {
        type: "json_object",
      },
      messages: [
        {
          role: "system",
          content: `
        Analyze the following RSS Feeds names, categories, and the number of articles read from that feed to infer
        the user's categories of interest. Return a JSON array of 3-5 most relevant categories under a "categories" key. Only output JSON.
        Example response: {"categories": ["Technology", "Politics", "Android", "Mobile Phones"]}
        `,
        },
        {
          role: "user",
          content: `Most Read Feeds: ${mostReadFeedsString}`,
        },
      ],
      temperature: 0.6,
    });

    const result = completion.choices[0]?.message?.content || "";

    // parse the json categories
    let parsedCategories = [];
    try {
      const parsedResult = JSON.parse(result);
      parsedCategories = parsedResult.categories || [];
      logger.info(
        `Parsed ${parsedCategories.length} categories: ${parsedCategories.join(", ")}`,
      );
    } catch (error) {
      logger.error(`Error parsing categories JSON: ${error}`);
      return { error: "Failed to parse categories" };
    }

    // Add the inferred interests to the user's document
    const userRef = db.doc(`users/${request.auth?.uid}`);
    await userRef.update({
      builtUserProfileDate: new Date().getTime(),
      interests: FieldValue.arrayUnion(...parsedCategories),
    });

    // Return the raw JSON string (e.g., {"categories": [...]})
    // The client can parse it as needed
    return { categoriesJson: result };
  },
);

export const addUserInterests = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const interests: string[] = request.data.interests;
    const uid = request.auth?.uid;
    logger.info(`Adding interests ${interests} for user ID: ${uid}`);

    const userRef = db.doc(`users/${uid}`);
    await userRef.update({
      interests: interests,
    });

    return { success: true };
  },
);

import { onCall, CallableRequest } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { auth, pubsub } from "firebase-functions/v1";
import { FieldValue, getFirestore, Timestamp } from "firebase-admin/firestore";
import { OpenAI } from "openai";
import { defineString } from "firebase-functions/params";
import * as admin from "firebase-admin";
import { google } from "googleapis";
import * as key from "../service-account-google-play.json";

admin.initializeApp();

const db = getFirestore();
const groqKey = defineString("GROQ_API_KEY");
const openai: OpenAI = new OpenAI({
  apiKey: groqKey.value(),
  baseURL: "https://api.groq.com/openai/v1",
});
const ENFORCE_APPCHECK = false; // TODO: change back
const maxCharsForOneSummary = 15000;
const model = "openai/gpt-oss-20b";
// const betterModel = "openai/gpt-oss-120b";
const betterModel = "llama-3.1-8b-instant";

const androidPackageId = "com.zeykafx.bytesized_news";

const authClient = new google.auth.JWT({
  email: key.client_email,
  key: key.private_key,
  scopes: ["https://www.googleapis.com/auth/androidpublisher"],
});

const playDeveloperApiClient = google.androidpublisher({
  version: "v3",
  auth: authClient,
});

interface Data {
  source: string;
  productId: string;
  verificationData: string;
  // userId: string;
}

export const verifyPurchases = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request: CallableRequest<Data>) => {
    const source: string = request.data?.source;
    const productId: string = request.data?.productId;
    const verificationData: string = request.data?.verificationData;
    // const userId: string = request.data?.userId;
    const uid = request.auth?.uid;

    if (!uid || !productId || !source || !verificationData) {
      logger.warn("Missing required parameters for purchase verification", {
        uid: !!uid,
        productId: !!productId,
        source: !!source,
        verificationData: !!verificationData,
      });
      return {
        status: 400,
        message: "Please pass all required data to the function",
      };
    }

    try {
      await authClient.authorize();
      const res = await playDeveloperApiClient.purchases.products.get({
        packageName: androidPackageId,
        productId,
        token: verificationData,
      });

      const purchaseData = res.data;

      if (!purchaseData?.orderId) {
        logger.warn("Purchase verification failed: no order ID", {
          uid,
          productId,
        });
        return {
          status: 400,
          message: "Invalid purchase: no order ID found",
        };
      }

      // check if purchase state is valid (0 = purchased, 1 = cancelled)
      if (purchaseData.purchaseState !== 0) {
        logger.warn("Purchase verification failed: invalid state", {
          uid,
          productId,
          purchaseState: purchaseData.purchaseState,
        });
        return {
          status: 400,
          message: "Purchase is not in a valid state",
        };
      }

      // validate purchase time (should not be in the future and not too old)
      const currentTime = Date.now();
      const purchaseTime = purchaseData.purchaseTimeMillis
        ? parseInt(purchaseData.purchaseTimeMillis)
        : 0;
      const oneWeekInMs = 7 * 24 * 60 * 60 * 1000; // 7 days

      if (purchaseTime > currentTime) {
        logger.warn("Purchase verification failed: future timestamp", {
          uid,
          productId,
          purchaseTime,
          currentTime,
        });
        return {
          status: 400,
          message: "Invalid purchase timestamp",
        };
      }

      if (currentTime - purchaseTime > oneWeekInMs) {
        logger.warn("Purchase verification failed: too old", {
          uid,
          productId,
          purchaseTime,
          currentTime,
        });
        return {
          status: 400,
          message: "Purchase is too old to verify",
        };
      }

      // check if the order has been processed already or not
      const orderId = purchaseData.orderId;
      const orderRef = db.doc(`processed_orders/${orderId}`);
      const orderDoc = await orderRef.get();

      if (orderDoc.exists) {
        logger.warn("Purchase verification failed: already processed", {
          uid,
          productId,
          orderId,
        });
        return {
          status: 400,
          message: "This purchase has already been processed",
        };
      }

      await db.runTransaction(async (transaction) => {
        // check that the order hasn't been processed by another request
        const orderDocInTransaction = await transaction.get(orderRef);
        if (orderDocInTransaction.exists) {
          throw new Error("Order already processed in concurrent request");
        }

        // mark as processed
        transaction.set(orderRef, {
          userId: uid,
          productId,
          processedAt: FieldValue.serverTimestamp(),
          purchaseTime: new Date(purchaseTime),
          token: verificationData,
        });

        // update the user's tier
        const userRef = db.doc(`users/${uid}`);
        transaction.update(userRef, {
          tier: "premium",
          lastPurchaseDate: FieldValue.serverTimestamp(),
          lastOrderId: orderId,
        });
      });

      // Acknowledge the purchase to prevent it from being refunded
      try {
        await playDeveloperApiClient.purchases.products.acknowledge({
          packageName: androidPackageId,
          productId,
          token: verificationData,
        });
      } catch (ackError) {
        // Purchase was already acknowledged, which is fine
        logger.info("Purchase already acknowledged", {
          uid,
          productId,
          orderId,
        });
      }

      logger.info("Purchase verification successful", {
        uid,
        productId,
        orderId,
      });

      return {
        status: 200,
        message: "Verification successful!",
        orderId,
      };
    } catch (error) {
      logger.error("Purchase verification error", {
        uid,
        productId,
        error: error instanceof Error ? error.message : String(error),
      });

      if (
        error instanceof Error &&
        error.message.includes("already processed")
      ) {
        return {
          status: 400,
          message: "This purchase has already been processed",
        };
      }

      return {
        status: 500,
        message: "Failed to verify purchase. Please try again.",
      };
    }
  },
);

export const onUserCreate = auth
  .user()
  .onCreate(async (user: auth.UserRecord) => {
    logger.info("User created: " + user.uid);

    const limits = await db.collection("flags").doc("limits").get();
    const suggestionsLimit = limits.data()?.suggestions || 20;
    const summariesLimit = limits.data()?.summaries || 100;

    // create a firestore document for the user
    const res = await db.doc(`users/${user.uid}`).set({
      email: user.email,
      created: FieldValue.serverTimestamp(),
      tier: "free",
      interests: ["News"],
      feeds: [],
      feedGroups: [],
      builtUserProfileDate: FieldValue.serverTimestamp(),
      suggestionsLeftToday: suggestionsLimit,
      lastSuggestionDate: null,
      summariesLeftToday: summariesLimit,
      lastSummaryDate: null,
      deviceIds: [],
    });
    logger.info("Document created: " + res.writeTime);
    return res;
  });

export const onUserDelete = auth.user().onDelete(async (user) => {
  logger.info("User deleted: " + user.uid);

  // delete the user's document
  const res = await db.doc(`users/${user.uid}`).delete();
  logger.info("Document deleted: " + res.writeTime);
  return res;
});

// check the purchases made in the last 48 hours to check for refunds
exports.checkRefunds = pubsub
  .schedule("0 0 * * *")
  .timeZone("Europe/Brussels")
  .onRun(async () => {
    // get all user documents
    const fourtyEightHrsAgo = Timestamp.fromMillis(
      Date.now() - 48 * 60 * 60 * 1000,
    );
    const recentProcessedOrders = await db
      .collection("processed_orders")
      .where("processedAt", ">", fourtyEightHrsAgo)
      .get();

    recentProcessedOrders.forEach((order) => {
      // check if the order is still valid
      const orderData = order.data();
      const userId = orderData.userId;
      const productId = orderData.productId;
      const token = orderData.token;
      // const processedAt = orderData.processedAt as Timestamp;
      // const purchaseTime = orderData.purchaseTime as Date;

      // check using the Google Play API
      playDeveloperApiClient.purchases.products
        .get({
          packageName: androidPackageId,
          productId: productId,
          token: token,
        })
        .then((res) => {
          const purchaseData = res.data;

          // check if the purchase state is valid (0 = purchased, 1 = cancelled)
          if (purchaseData.purchaseState !== 0) {
            logger.info(
              `Purchase ${order.id} for user ${userId} has been refunded or cancelled.`,
            );

            // update the user's tier to free
            db.doc(`users/${userId}`).update({
              tier: "free",
              lastPurchaseDate: null,
              lastOrderId: null,
              hasRefunded: true, // mark the user as having refunded
              // this way we can prevent them from purchasing again
            });

            // delete the order from processed_orders
            db.doc(`processed_orders/${order.id}`).delete();
          }
          // else {
          //   logger.info(
          //     `Purchase ${order.id} for user ${userId} is still valid.`,
          //   );
          // }
        })
        .catch((error) => {
          logger.error(
            `Error checking purchase ${order.id} for user ${userId}: ${error}`,
          );
        });
    });
  });

// reset quotas daily via Cloud Scheduler
exports.resetQuotas = pubsub
  .schedule("0 0 * * *")
  .timeZone("Europe/Brussels")
  .onRun(async () => {
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

    if (userData?.tier !== "premium") {
      logger.info("Non-Premium user attempted to summarize article: " + uid);
      return {
        error: "Error: Not a premium account",
      };
    }

    let summariesToConsume = 1;

    // check the length of the article
    if (content.length > maxCharsForOneSummary) {
      // will consume more than 1 summary since the content is so long
      summariesToConsume += Math.ceil(
        content.length / maxCharsForOneSummary - 1,
      );
    }

    // check if the user has any summaries left today
    const summariesLeftToday = userData?.summariesLeftToday;
    if (summariesLeftToday <= 0) {
      return { error: "Error: You have reached the daily limit of summaries" };
    }
    if (summariesLeftToday - summariesToConsume < 0) {
      return {
        error:
          "Error: You have reached the daily limit of summaries or the article is too long to summarize with your remaining credits.",
      };
    }

    // update the user's summary count
    await userRef.update({
      lastSummaryDate: FieldValue.serverTimestamp(),
      summariesLeftToday: FieldValue.increment(-summariesToConsume),
    });

    // create the summary with openai
    const completion = await openai.chat.completions.create({
      // model: "llama-3.1-8b-instant",
      model: model,
      messages: [
        {
          role: "system",
          content: `
          ### Role
          You are a precise article summarizer. Extract only the essential information without adding interpretations or new content.

          ### Instructions
          - Summarize the article in exactly 3 bullet points (max 5 if article is exceptionally long)
          - Each bullet point must start on a new line with a proper bullet character (•)
          - Convert units of measurement between metric and imperial systems (provide in parentheses)
          - Maintain factual accuracy - include ONLY information present in the original text
          - Keep each bullet concise and focused on one key point
          - Use Twitter's official name (Twitter) even if the article refers to it as "X"

          ### Context
          The article requires concise summarization while preserving all critical information.

          ### Expected Output Format
          • [First key point from the article]
          • [Second key point from the article]
          • [Third key point from the article]

          ### Constraints
          - NO introductory phrases like "Here is a summary..."
          - NO concluding remarks
          - NO additional context or opinions
          - STRICTLY adhere to bullet point format
          - Add a short warning at the end of the summary if the article is from non trustworthy "news" sources from the far right
          `,
        },
        {
          role: "user",
          content: content,
        },
      ],
      temperature: 0.2,
    });

    const summary = completion.choices[0].message.content;

    // save the summary in firestore
    const res = await db.collection("summaries").add({
      url: articleUrl,
      title: title,
      summary: summary,
      generatedAt: FieldValue.serverTimestamp(),
      // expires in a month
      expirationTimestamp: Timestamp.fromMillis(
        Timestamp.now().toMillis() + 30 * 24 * 60 * 60 * 1000,
      ),
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

    if (userData?.tier !== "premium") {
      logger.info("Non-Premium user attempted to get news suggestions: " + uid);
      return {
        error: "Error: Not a premium account",
      };
    }

    // check if the user has any summaries left today
    const suggestionsLeftToday = userData?.suggestionsLeftToday;
    if (suggestionsLeftToday <= 0) {
      return {
        error: "Error: You have reached the daily limit of suggestions",
      };
    }

    // update the user's summary count
    await userRef.update({
      lastSuggestionDate: FieldValue.serverTimestamp(),
      suggestionsLeftToday: FieldValue.increment(-1),
    });

    // get the news suggestions with ai
    const completion = await openai.chat.completions.create({
      // model: "llama-3.1-8b-instant",
      model: betterModel,
      // model: "meta-llama/llama-4-scout-17b-16e-instruct",
      response_format: {
        // type: "json_schema",
        type: "json_object",
        // json_schema: {
        //   name: "product_review",
        //   schema: {
        //     type: "object",
        //     properties: {
        //       articles: {
        //         type: "array",
        //         items: {
        //           type: "object",
        //           properties: {
        //             id: { type: "number" },
        //             title: { type: "string" },
        //             feedName: { type: "string" },
        //           },
        //         },
        //       },
        //     },
        //     required: ["articles"],
        //     additionalProperties: false,
        //   },
        // },
      },
      // reasoning_effort: "medium",
      messages: [
        {
          role: "system",
          content: `
        You are an expert news curation AI that personalizes article recommendations for RSS reader users.

        TASK: Select at least 5 articles (no more than 10) from today's unread articles that best match the user's interests 
        and reading patterns.

        SELECTION CRITERIA (in order of priority):
        1. Relevance to user's stated interests and categories
        2. Source preference based on user's most-read feeds
        3. Article quality and newsworthiness (avoid clickbait)
        4. Timeliness and current relevance
        5. Diversity across different topics/sources

        STRICT REQUIREMENTS:
        - Return AT LEAST 5 articles, MAX 10; feel free to suggest more
        - Preserve original article IDs unchanged
        - EXCLUDE: promotional content, deals, coupons, advertisements, podcasts
        - INCLUDE: substantive news, analysis, educational content
        - Prioritize articles from feeds the user reads most frequently
        - Balance between user preferences and editorial quality

        OUTPUT FORMAT: Return a JSON object that follows this schema:
        json_schema: {
          name: "product_review",
          schema: {
            type: "object",
            properties: {
              articles: {
                type: "array",
                items: {
                  type: "object",
                  properties: {
                    id: { type: "number" },
                    title: { type: "string" },
                    feedName: { type: "string" },
                  },
                },
              },
            },
            required: ["articles"],
            additionalProperties: false,
          },
        },
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
      temperature: 0.3,
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

    const uid = request.auth?.uid;
    const userRef = db.doc(`users/${uid}`);
    const user = await userRef.get();
    const userData = user.data();

    if (userData?.tier !== "premium") {
      logger.info("Non-Premium user attempted to get news suggestions: " + uid);
      return {
        error: "Error: Not a premium account",
      };
    }

    const completion = await openai.chat.completions.create({
      // model: "llama-3.1-8b-instant",
      model: model,
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

    const uid = request.auth?.uid;
    const userRef = db.doc(`users/${uid}`);
    const user = await userRef.get();
    const userData = user.data();

    if (userData?.tier !== "premium") {
      logger.info("Non-Premium user attempted to get news suggestions: " + uid);
      return {
        error: "Error: Not a premium account",
      };
    }

    const completion = await openai.chat.completions.create({
      // model: "llama-3.1-8b-instant",
      model: model,
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
      temperature: 0.3,
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
    // const userRef = db.doc(`users/${request.auth?.uid}`);
    await userRef.update({
      builtUserProfileDate: FieldValue.serverTimestamp(),
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

// Evaluates an AI-generated summary against the original article using a Groq model.
export const evaluateSummary = onCall(
  { region: "europe-west1", enforceAppCheck: ENFORCE_APPCHECK },
  async (request) => {
    const articleText: string = request.data.articleText;
    const summaryText: string = request.data.summaryText;
    const uid = request.auth?.uid;
    logger.info(`Evaluating summary for user ID: ${uid}`);

    if (!articleText || !summaryText) {
      return { error: "Missing articleText or summaryText" };
    }

    // Call the Groq model for evaluation
    const completion = await openai.chat.completions.create({
      model: "llama-3.1-8b-instant",
      response_format: {
        type: "json_object",
      },
      messages: [
        {
          role: "system",
          content: `
            You are an AI evaluator. Given an original article and a generated summary, determine:
            - useSummary (boolean): whether the summary is sufficiently accurate and usable.
            - accuracy (float): percentage accuracy of the summary (0.0 to 100.0).
            Return only a JSON object with keys "useSummary" and "accuracy".
          `,
        },
        {
          role: "user",
          content: `Article: ${articleText}`,
        },
        {
          role: "user",
          content: `Summary: ${summaryText}`,
        },
      ],
      temperature: 0.3,
    });

    const resultContent = completion.choices[0]?.message?.content || "";
    let parsed: { useSummary: boolean; accuracy: number } = {
      useSummary: false,
      accuracy: 0.0,
    };
    try {
      parsed = JSON.parse(resultContent);
    } catch (error) {
      logger.error("Failed to parse evaluation response: " + error);
      return { error: "Invalid evaluation response" };
    }

    return {
      useSummary: parsed.useSummary,
      accuracy: parsed.accuracy,
    };
  },
);

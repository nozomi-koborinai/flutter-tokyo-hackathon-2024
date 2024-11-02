import * as admin from "firebase-admin";
import * as firebaseFunctions from "firebase-functions";
import { db } from "../config/firebase";

export const onCreateAuthUser = firebaseFunctions.auth
  .user()
  .onCreate(async (user) => {
    try {
      await db.collection(`users`).doc(user.uid).set({
        imageUrl: ``,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      console.log(`User document created for ${user.uid}`);
    } catch (error) {
      console.error(`Error creating user document:`, error);
    }
  });

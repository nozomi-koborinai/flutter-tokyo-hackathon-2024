import { prompt } from "@genkit-ai/dotprompt";
import { firebaseAuth } from "@genkit-ai/firebase/auth";
import * as genkitFunctions from "@genkit-ai/firebase/functions";
import * as z from "zod";
import { db, googleAIapiKey, storage } from "../config/firebase";
import { generateImageInputSchema } from "../schemas/generateImageInputSchema";
import { translateInputSchema } from "../schemas/translateInputSchema";

export const generateImage = genkitFunctions.onFlow(
  {
    name: `generateImage`,
    httpsOptions: {
      cors: true,
      secrets: [googleAIapiKey],
    },
    inputSchema: z.object({
      prompt: z.string(),
      uid: z.string(),
    }),
    authPolicy: firebaseAuth((user) => {
      if (user.firebase?.sign_in_provider !== `anonymous`) {
        throw new Error(
          `Only anonymously authenticated users can access this function`
        );
      }
    }),
  },
  async (input) => {
    // Imagen3 は日本語に対応していないので、元の言語問わず、ここで一旦英語への翻訳を実行
    const translatePrompt = await prompt<z.infer<typeof translateInputSchema>>(
      `translateToEnglish`
    );
    const translatedResult = await translatePrompt.generate({
      input: {
        prompt: input.prompt,
      },
    });

    const generateImagePrompt = await prompt<
      z.infer<typeof generateImageInputSchema>
    >(`generateImage`);
    const result = await generateImagePrompt.generate({
      input: {
        prompt: translatedResult.data().translatedPrompt,
      },
    });

    const mediaData = result.media();
    const response = await fetch(mediaData!.url);
    const arrayBuffer = await response.arrayBuffer();
    const imageBuffer = Buffer.from(arrayBuffer);

    // Cloud Storageに保存
    const bucket = storage.bucket();
    const fileName = `character-images/${input.uid}/${Date.now()}.png`;
    const file = bucket.file(fileName);
    await file.save(imageBuffer, {
      contentType: mediaData!.contentType || "image/png",
    });

    // 保存した画像の参照URLを取得
    const imageUrl = `https://firebasestorage.googleapis.com/v0/b/${
      bucket.name
    }/o/${encodeURIComponent(fileName)}?alt=media`;

    // Firestoreのユーザードキュメントを更新
    await db.collection("users").doc(input.uid).update({
      characterImageUrl: imageUrl,
    });

    return result.media();
  }
);

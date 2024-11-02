import { prompt } from "@genkit-ai/dotprompt";
import { firebaseAuth } from "@genkit-ai/firebase/auth";
import * as genkitFunctions from "@genkit-ai/firebase/functions";
import * as z from "zod";
import { db, googleAIapiKey } from "../config/firebase";
import { battleInputSchema } from "../schemas/battleInputSchema";

export const battleFlow = genkitFunctions.onFlow(
  {
    name: `battleFlow`,
    httpsOptions: {
      cors: true,
      secrets: [googleAIapiKey],
    },
    inputSchema: battleInputSchema,
    authPolicy: firebaseAuth((user) => {
      if (user.firebase?.sign_in_provider !== `anonymous`) {
        throw new Error(
          `Only anonymously authenticated users can access this function`
        );
      }
    }),
  },
  async (input) => {
    // バトル評価を実行
    const evaluatePrompt = await prompt<z.infer<typeof battleInputSchema>>(
      `evaluateBattle`
    );

    const evaluation = await evaluatePrompt.generate({ input });

    const result = evaluation.data();
    const targetUser = await db.collection("users").doc(result.targetUid).get();
    const currentHp = targetUser.data()!.hitPoint;
    const newHp = Math.max(0, currentHp - result.damage);

    // HPを更新
    await db.collection("users").doc(result.targetUid).update({
      hitPoint: newHp,
    });

    // HPが0になった場合は勝者を決定
    if (newHp === 0) {
      const winner = result.targetUid === input.uid ? input.pairUid : input.uid;

      // roomのステータスを更新
      await db.collection("rooms").doc(input.roomId).update({
        isOpen: false,
      });

      return {
        winner,
        damage: result.damage,
        targetUid: result.targetUid,
      };
    }

    // まだ決着がついていない場合
    return {
      damage: result.damage,
      targetUid: result.targetUid,
    };
  }
);

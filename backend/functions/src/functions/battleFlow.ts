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
      `evaluteBattle`
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

    // 両プレイヤーの最新のHPを取得
    const user = await db.collection("users").doc(input.uid).get();
    const pairUser = await db.collection("users").doc(input.pairUid).get();
    const userHp = user.data()!.hitPoint;
    const pairUserHp = pairUser.data()!.hitPoint;

    // どちらかのHPが0以下になった場合は勝者を決定
    if (userHp <= 0 || pairUserHp <= 0) {
      // roomのステータスを更新
      await db.collection("rooms").doc(input.roomId).update({
        isOpen: false,
      });

      return {
        result: {
          winner: userHp <= 0 ? input.pairUid : input.uid,
          damage: result.damage,
          targetUid: result.targetUid,
        },
      };
    }

    // まだ決着がついていない場合
    return {
      result: {
        damage: result.damage,
        targetUid: result.targetUid,
      },
    };
  }
);

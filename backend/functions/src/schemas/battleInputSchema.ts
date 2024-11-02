import * as z from "zod";

export const battleInputSchema = z.object({
  roomId: z.string(),
  uid: z.string(),
  pairUid: z.string(),
  userImageUrl: z.string(),
  pairUserImageUrl: z.string(),
});

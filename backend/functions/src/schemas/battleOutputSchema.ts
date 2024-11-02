import * as z from "zod";

export const battleOutputSchema = z.object({
  winner: z.string().optional(),
  damage: z.number(),
  targetUid: z.string(),
});

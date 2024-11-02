import * as z from "zod";

export const translateInputSchema = z.object({
  prompt: z.string(),
});

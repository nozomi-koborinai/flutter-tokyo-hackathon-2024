import * as z from "zod";

export const translateOutputSchema = z.object({
  translatedPrompt: z.string(),
});

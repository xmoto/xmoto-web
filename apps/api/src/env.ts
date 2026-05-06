import { createEnv } from "@t3-oss/env-core";
import * as z from "zod";

export const env = createEnv({
  server: {
    PORT: z.number().min(0).max(65535),
  },

  runtimeEnv: process.env,
  emptyStringAsUndefined: true,
});

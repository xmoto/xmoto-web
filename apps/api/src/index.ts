import console from "node:console";
import process from "node:process";
import { serve } from "@hono/node-server";
import { log } from "@repo/logger";
import { createApp } from "./app";

const port = process.env.PORT! || "5001";
const app = createApp();

const server = serve({
  fetch: app.fetch,
  port: parseInt(port, 10),
});

log(`api running on ${port}`);

process.on("SIGINT", () => {
  server.close();
  process.exit(0);
});

process.on("SIGTERM", () => {
  server.close((err) => {
    if (err) {
      console.error(err);
      process.exit(1);
    }
    process.exit(0);
  });
});

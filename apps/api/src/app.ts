import { Hono } from "hono";

export const createApp = () => {
  return new Hono().get("/status", (c) => c.json({ ok: true }));
};

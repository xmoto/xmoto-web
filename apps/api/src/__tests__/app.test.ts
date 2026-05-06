import { describe, expect, it } from "@jest/globals";
import { testClient } from "hono/testing";
import { createApp } from "../app";

describe("health check", () => {
	const client = testClient(createApp());

	it("should return 200", async () => {
		const res = await client.status.$get();

		expect(res.status).toBe(200);
		expect(await res.json()).toEqual({
			ok: true,
		});
	});
});

import assert from "node:assert/strict";
import test from "node:test";

test("main prints the greeting exactly once", async (t) => {
  const log = t.mock.method(console, "log", () => {});
  await import("../src/main.js");
  assert.deepEqual(
    log.mock.calls.map((call) => call.arguments),
    [["Hello, World!"]],
  );
});

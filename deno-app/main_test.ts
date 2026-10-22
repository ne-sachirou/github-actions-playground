import { assertEquals } from "@std/assert";

Deno.test("main prints the greeting exactly once", async () => {
  const calls: unknown[][] = [];
  const original = console.log;
  console.log = (...args: unknown[]) => {
    calls.push(args);
  };
  try {
    await import("./main.ts");
  } finally {
    console.log = original;
  }
  assertEquals(calls, [["Hello, World!"]]);
});

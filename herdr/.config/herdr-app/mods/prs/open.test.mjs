import { test } from "node:test";
import assert from "node:assert/strict";
import { openPr, fetchGroups } from "./open.js";

const pr = { repo: "softwarevidal/vira", name: "vira", number: 7, title: "T", url: "https://github.com/softwarevidal/vira/pull/7", branch: "feat/x" };

// A fake machine: `answers` maps "cmd arg1 arg2" prefixes to results; every call is recorded.
function deps({ answers = {}, spaces = [], panes = [] } = {}) {
  const d = {
    calls: [], runs: [], notes: [], home: "/h",
    spaces: () => spaces, panes: () => panes,
    run: (name, args) => { d.runs.push([name, args]); },
    notify: (n) => { d.notes.push(n); },
    exec: async (cmd, args) => {
      const line = [cmd, ...args].join(" ");
      d.calls.push(line);
      await Promise.resolve();
      const key = Object.keys(answers).find((k) => line.startsWith(k));
      return key ? answers[key] : { code: 1, stdout: "", stderr: "" };
    },
  };
  return d;
}
const ok = (stdout = "") => ({ code: 0, stdout, stderr: "" });
const clone = { "test -d /h/work/vira": ok(), "git -C /h/work/vira worktree list": ok("worktree /h/work/vira\nHEAD a\nbranch refs/heads/master\n") };

test("an existing space is focused without running git", async () => {
  const d = deps({ spaces: [{ id: "s1", folder: "/h/work/vira", branch: "feat/x", machine: null, tabs: [] }] });
  assert.equal(await openPr(pr, d), "focused");
  assert.deepEqual(d.runs, [["space.select", { id: "s1" }]]);
  assert.equal(d.calls.filter((c) => c.startsWith("git")).length, 0);
});

test("without a local clone, a toast and the PR on GitHub", async () => {
  const d = deps();
  assert.equal(await openPr(pr, d), "github");
  assert.equal(d.notes.length, 1);
  assert.ok(d.calls.includes(`xdg-open ${pr.url}`));
  assert.deepEqual(d.runs, []);
});

test("a branch already checked out opens a space on that folder, no fetch", async () => {
  const d = deps({ answers: { ...clone, "git -C /h/work/vira worktree list": ok("worktree /h/work/vira\nHEAD a\nbranch refs/heads/feat/x\n") } });
  assert.equal(await openPr(pr, d), "opened");
  assert.deepEqual(d.runs, [["space.new", { folder: "/h/work/vira" }]]);
  assert.ok(!d.calls.some((c) => c.includes(" fetch ")));
});

test("a failed fetch (fork) gives a toast and GitHub, no worktree, no space", async () => {
  const d = deps({ answers: { ...clone, "git -C /h/work/vira fetch": { code: 128, stdout: "", stderr: "fatal: couldn't find remote ref feat/x\nmore" } } });
  assert.equal(await openPr(pr, d), "github");
  assert.match(d.notes[0].body, /couldn't find remote ref feat\/x$/);
  assert.ok(d.calls.includes(`xdg-open ${pr.url}`));
  assert.ok(!d.calls.some((c) => c.includes("worktree add")));
  assert.deepEqual(d.runs, []);
});

test("nominal: fetch, worktree add under ~/.herdr/worktrees, new space", async () => {
  const d = deps({ answers: { ...clone, "git -C /h/work/vira fetch origin feat/x": ok(), "git -C /h/work/vira worktree add": ok() } });
  assert.equal(await openPr(pr, d), "opened");
  assert.ok(d.calls.includes("git -C /h/work/vira worktree add /h/.herdr/worktrees/vira/feat-x feat/x"));
  assert.deepEqual(d.runs, [["space.new", { folder: "/h/.herdr/worktrees/vira/feat-x" }]]);
});

test("the clone is looked for in ~/perso after ~/work", async () => {
  const d = deps({ answers: { "test -d /h/perso/vira": ok(), "git -C /h/perso/vira worktree list": ok("worktree /h/perso/vira\nbranch refs/heads/feat/x\n") } });
  assert.equal(await openPr(pr, d), "opened");
  assert.deepEqual(d.runs, [["space.new", { folder: "/h/perso/vira" }]]);
});

test("two simultaneous opens of the same PR run git once", async () => {
  const d = deps({ answers: { ...clone, "git -C /h/work/vira fetch origin feat/x": ok(), "git -C /h/work/vira worktree add": ok() } });
  await Promise.all([openPr(pr, d), openPr(pr, d)]);
  assert.equal(d.calls.filter((c) => c.includes(" fetch ")).length, 1);
  assert.equal(d.runs.length, 1);
});

test("fetchGroups rejects with the first line of gh's error", async () => {
  const d = deps({ answers: { "gh api graphql": { code: 1, stdout: "", stderr: "gh: not logged in\nrun gh auth login" } } });
  await assert.rejects(fetchGroups(d), { message: "gh: not logged in" });
});

test("fetchGroups groups gh's answer", async () => {
  const node = { number: 1, title: "T", url: "u", isDraft: false, reviewDecision: "APPROVED", headRefName: "b", repository: { name: "r", nameWithOwner: "o/r" } };
  const d = deps({ answers: { "gh api graphql": ok(JSON.stringify({ data: { drafts: { nodes: [] }, ready: { nodes: [node] }, review: { nodes: [] }, assigned: { nodes: [] } } })) } });
  const groups = await fetchGroups(d);
  assert.deepEqual(groups.map((g) => g.id), ["approved"]);
});

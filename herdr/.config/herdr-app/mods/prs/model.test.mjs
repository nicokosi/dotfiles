import { test } from "node:test";
import assert from "node:assert/strict";
import { searchVariables, groupsFrom, worktreePath, checkoutOf, spaceShowing } from "./model.js";

const node = (number, extra = {}) => ({
  number, title: `PR ${number}`, url: `https://github.com/o/r/pull/${number}`, isDraft: false,
  reviewDecision: null, headRefName: `b${number}`, updatedAt: "2026-11-18T00:00:00Z",
  repository: { name: "r", nameWithOwner: "o/r" }, ...extra,
});
const search = (...nodes) => ({ issueCount: nodes.length, nodes });

test("drafts are limited to softwarevidal and the last 30 days", () => {
  const v = searchVariables(new Date("2026-11-19T10:00:00Z"));
  assert.match(v.drafts, /updated:>=2026-10-20/);
  assert.match(v.drafts, /org:softwarevidal/);
  assert.match(v.drafts, /draft:true/);
  assert.match(v.ready, /author:@me draft:false/);
  assert.match(v.review, /review-requested:@me/);
  assert.match(v.assigned, /assignee:@me/);
});

test("ready PRs split on approval, empty groups are dropped, order is fixed", () => {
  const groups = groupsFrom({
    drafts: search(node(1, { isDraft: true })),
    ready: search(node(2, { reviewDecision: "APPROVED" }), node(3, { reviewDecision: "CHANGES_REQUESTED" }), node(4)),
    review: search(node(5)),
    assigned: search(),
  });
  assert.deepEqual(groups.map((g) => g.id), ["drafts", "review-mine", "approved", "review-requested"]);
  assert.deepEqual(groups.find((g) => g.id === "approved").prs.map((p) => p.number), [2]);
  assert.deepEqual(groups.find((g) => g.id === "review-mine").prs.map((p) => p.number), [3, 4]);
  assert.deepEqual(groups.map((g) => g.section), ["mine", "mine", "mine", "contrib"]);
  assert.deepEqual(groups[0].prs[0], { repo: "o/r", name: "r", number: 1, title: "PR 1", url: "https://github.com/o/r/pull/1", branch: "b1" });
});

test("worktree path replaces slashes in the branch", () => {
  assert.equal(worktreePath("/h", "vira", "feat/x-y"), "/h/.herdr/worktrees/vira/feat-x-y");
});

test("checkoutOf finds the folder holding a branch", () => {
  const porcelain = "worktree /w/vira\nHEAD abc\nbranch refs/heads/master\n\nworktree /h/.herdr/worktrees/vira/feat-x\nHEAD def\nbranch refs/heads/feat/x\n";
  assert.equal(checkoutOf(porcelain, "feat/x"), "/h/.herdr/worktrees/vira/feat-x");
  assert.equal(checkoutOf(porcelain, "feat/y"), null);
});

test("spaceShowing matches branch and repo, skips remote spaces, looks at pane cwds", () => {
  const space = (id, folder, branch, machine = null) => ({ id, folder, branch, machine, tabs: [{ id: `${id}-t` }] });
  const spaces = [space("s0", "/w/vira", "feat/x", "vps"), space("s1", "/w/arthur", "feat/x"), space("s2", "/w/vira", "feat/x"), space("s3", "/w", null)];
  assert.equal(spaceShowing(spaces, [], "vira", "feat/x"), "s2");
  const panes = [{ tab: "s3-t", cwd: "/h/.herdr/worktrees/olympe/feat-z", branch: "feat/z" }];
  assert.equal(spaceShowing(spaces, panes, "olympe", "feat/z"), "s3");
  assert.equal(spaceShowing(spaces, panes, "olympe", "feat/none"), null);
});

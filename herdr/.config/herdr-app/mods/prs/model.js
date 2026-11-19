// Pure logic of the pull requests panel: no import from "herdr", so Node can test it.

const FIELDS = "nodes { ... on PullRequest { number title url isDraft reviewDecision headRefName isCrossRepository updatedAt repository { name nameWithOwner } latestOpinionatedReviews(first: 20) { nodes { state } } } }";
const ALIASES = ["drafts", "ready", "review", "assigned"];

export const GRAPHQL = `query(${ALIASES.map((a) => `$${a}: String!`).join(", ")}) {
${ALIASES.map((a) => `  ${a}: search(type: ISSUE, first: 50, query: $${a}) { ${FIELDS} }`).join("\n")}
}`;

const DAY_MS = 86400000;

export function searchVariables(today) {
  const since = new Date(today.getTime() - 30 * DAY_MS).toISOString().slice(0, 10);
  return {
    drafts: `is:pr is:open author:@me draft:true org:softwarevidal updated:>=${since}`,
    ready: "is:pr is:open author:@me draft:false",
    review: "is:pr is:open review-requested:@me",
    assigned: "is:pr is:open assignee:@me",
  };
}

const toPr = (n) => ({
  repo: n.repository.nameWithOwner, name: n.repository.name, number: n.number,
  title: n.title, url: n.url, branch: n.headRefName, fork: n.isCrossRepository === true,
  // Latest review per reviewer: someone who approved twice counts once.
  approvals: (n.latestOpinionatedReviews?.nodes ?? []).filter((r) => r?.state === "APPROVED").length,
});

export function groupsFrom(data) {
  const nodes = (alias) => (data[alias]?.nodes ?? []).filter((n) => n?.number);
  const ready = nodes("ready");
  return [
    { id: "drafts", section: "mine", title: "En cours", prs: nodes("drafts") },
    { id: "review-mine", section: "mine", title: "En relecture", prs: ready.filter((n) => n.reviewDecision !== "APPROVED") },
    { id: "approved", section: "mine", title: "Approuvées", prs: ready.filter((n) => n.reviewDecision === "APPROVED") },
    { id: "review-requested", section: "contrib", title: "Relecture demandée", prs: nodes("review") },
    { id: "assigned", section: "contrib", title: "Assignées", prs: nodes("assigned") },
  ].map((g) => ({ ...g, prs: g.prs.map(toPr) })).filter((g) => g.prs.length > 0);
}

export const worktreePath = (home, name, branch) => `${home}/.herdr/worktrees/${name}/${branch.replaceAll("/", "-")}`;

export function checkoutOf(porcelain, branch) {
  for (const block of porcelain.split("\n\n")) {
    const lines = block.split("\n");
    if (lines.includes(`branch refs/heads/${branch}`)) {
      return lines.find((l) => l.startsWith("worktree "))?.slice("worktree ".length) ?? null;
    }
  }
  return null;
}

const inRepo = (folder, name) => (folder ?? "").split("/").includes(name);

export function spaceShowing(spaces, panes, name, branch) {
  for (const s of spaces) {
    if (s.machine) continue;
    if (s.branch === branch && inRepo(s.folder, name)) return s.id;
    const tabs = new Set(s.tabs.map((t) => t.id));
    if (panes.some((p) => tabs.has(p.tab) && p.branch === branch && inRepo(p.cwd, name))) return s.id;
  }
  return null;
}

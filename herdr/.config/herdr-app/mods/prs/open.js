// Fetching the pull requests and opening one's Herdr space. Herdr's functions come in `deps`,
// so Node can test this file: { exec, home, spaces, panes, run, notify }.
import { GRAPHQL, searchVariables, groupsFrom, worktreePath, checkoutOf, spaceShowing } from "./model.js";

const firstLine = (r) => (r.stderr || r.stdout).trim().split("\n")[0];

export async function fetchGroups(deps) {
  const vars = Object.entries(searchVariables(new Date())).flatMap(([k, v]) => ["-f", `${k}=${v}`]);
  const r = await deps.exec("gh", ["api", "graphql", "-f", `query=${GRAPHQL}`, ...vars]);
  if (r.code !== 0) throw new Error(firstLine(r) || `gh a échoué (code ${r.code})`);
  return groupsFrom(JSON.parse(r.stdout).data);
}

const inFlight = new Map();

// Navigation only: never starts an agent.
export function openPr(pr, deps) {
  if (!inFlight.has(pr.url)) {
    inFlight.set(pr.url, open(pr, deps).finally(() => inFlight.delete(pr.url)));
  }
  return inFlight.get(pr.url);
}

async function onGitHub(pr, deps, body) {
  deps.notify({ title: `${pr.repo}#${pr.number}`, body, level: "warning" });
  await deps.exec("xdg-open", [pr.url]);
  return "github";
}

async function open(pr, deps) {
  const space = spaceShowing(deps.spaces(), deps.panes(), pr.name, pr.branch);
  if (space) {
    deps.run("space.select", { id: space });
    return "focused";
  }
  let clone = null;
  for (const dir of [`${deps.home}/work/${pr.name}`, `${deps.home}/perso/${pr.name}`]) {
    if ((await deps.exec("test", ["-d", dir])).code === 0) { clone = dir; break; }
  }
  if (!clone) return onGitHub(pr, deps, `Pas de clone local de ${pr.repo}`);

  const git = (...args) => deps.exec("git", ["-C", clone, ...args], { timeout: 120000 });
  const list = await git("worktree", "list", "--porcelain");
  if (list.code !== 0) return onGitHub(pr, deps, firstLine(list));
  let folder = checkoutOf(list.stdout, pr.branch);
  if (!folder) {
    const fetched = await git("fetch", "origin", pr.branch);
    if (fetched.code !== 0) return onGitHub(pr, deps, firstLine(fetched));
    folder = worktreePath(deps.home, pr.name, pr.branch);
    // An existing local branch is checked out as is; otherwise git creates it tracking origin/<branch>.
    const added = await git("worktree", "add", folder, pr.branch);
    if (added.code !== 0) return onGitHub(pr, deps, firstLine(added));
  }
  deps.run("space.new", { folder });
  return "opened";
}

# Panneau « Pull requests » Herdr : plan d'implémentation

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** un mod `herdr-app` nommé `prs`, posé à droite des terminaux dans un layout `nico`, qui liste mes PR GitHub ouvertes par groupe et ouvre leur espace Herdr au clic.

**Architecture:** la logique pure (requêtes, classement, chemins, recherche d'espace) vit dans `model.js`, testée par `node --test`. `open.js` enchaîne les appels `git` via `exec` pour le clic gauche. `main.js` est la vue (`View` gpui-kit). Les fichiers sont dans un paquet stow `herdr` du dépôt dotfiles, liés sous `~/.config/herdr-app`.

**Tech Stack:** JavaScript des mods herdr-app (gpui-kit, module `herdr`), `gh api graphql`, `git worktree`, Node 26 pour les tests, GNU Stow.

**Spec:** `docs/specs/2026-11-19-herdr-pr-panel-design.md`

## Global Constraints

- Référence de l'API : `~/.config/herdr-app/AGENTS.md` (section Mods), `herdr.d.ts`, `gpui-kit.d.ts`. Ne jamais garder un `cx` : chaque callback reçoit le sien.
- Brouillons affichés : `org:softwarevidal`, mis à jour depuis 30 jours au plus. Pas de dépliage des autres.
- Groupes, dans cet ordre : « En cours », « En relecture », « Approuvées » (section « Mes PR ») ; « Relecture demandée », « Assignées » (section « Je contribue »). Groupe vide masqué.
- Ligne : titre, `repo#numéro`.
- Clic gauche : naviguer, jamais lancer d'agent. Clic droit : PR sur GitHub (`xdg-open <url>`).
- Clones cherchés dans `~/work/<repo>` puis `~/perso/<repo>`. Worktrees dans `~/.herdr/worktrees/<repo>/<branche>`, `/` remplacés par `-`.
- Rafraîchi à l'init, toutes les 300 000 ms, et par un bouton « Rafraîchir ». Une erreur `gh` s'affiche en tête ; la dernière liste reste.
- `checking()` vrai : aucun `exec` (ni `gh`, ni `git`).
- Commits : message en anglais, trailer `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, sur la branche courante `vidal`.

## Review Focus

1. **PR venant d'un fork** (`headRefName` absent de `origin`) : `git fetch origin <branche>` échoue ; attendu : toast d'erreur puis PR ouverte sur GitHub, pas d'espace à moitié créé. Test : Task 2, `openPr` avec fetch en échec.
2. **Branche déjà sortie dans un autre dossier** (le clone lui-même ou un worktree hors `~/.herdr`) : `git worktree add` refuserait ; attendu : ouvrir un espace sur ce dossier. Test : Task 1 `checkoutOf`, Task 2 cas « checkout existant ».
3. **Double clic pendant la création du worktree** : attendu : un seul worktree, la ligne indique « ouverture… ». Test : Task 2 vérifie qu'un second `openPr` sur la même PR pendant le premier ne relance pas `git`.
4. **Même nom de branche dans deux dépôts** : attendu : l'espace focalisé est celui du bon dépôt. Test : Task 1 `spaceShowing` avec deux espaces de même branche.
5. **`gh` absent du PATH, non authentifié ou hors réseau** : attendu : message d'erreur lisible en tête, pas de crash, liste précédente conservée. Test : Task 2 `fetchGroups` sur `code !== 0`.

---

### Task 1: logique pure (`model.js`)

**Files:**
- Create: `herdr/.config/herdr-app/mods/prs/model.js`
- Test: `herdr/.config/herdr-app/mods/prs/model.test.mjs`

**Interfaces:**
- Produces (exports de `model.js`, sans aucun import de `herdr`) :
  - `GRAPHQL: string` : requête avec variables `$drafts $ready $review $assigned: String!`, quatre alias `search(type: ISSUE, first: 50)` renvoyant `nodes { ... on PullRequest { number title url isDraft reviewDecision headRefName updatedAt repository { name nameWithOwner } } }`.
  - `searchVariables(today: Date): { drafts, ready, review, assigned }` :
    - `drafts` = `is:pr is:open author:@me draft:true org:softwarevidal updated:>=YYYY-MM-DD` (today − 30 jours, UTC) ;
    - `ready` = `is:pr is:open author:@me draft:false` ;
    - `review` = `is:pr is:open review-requested:@me` ;
    - `assigned` = `is:pr is:open assignee:@me`.
  - `type Pr = { repo: string /* nameWithOwner */, name: string, number: number, title: string, url: string, branch: string }`.
  - `groupsFrom(data): { id: string, section: "mine" | "contrib", title: string, prs: Pr[] }[]` : `data` est le `.data` de la réponse GraphQL. `ready` est coupé sur `reviewDecision === "APPROVED"` (« Approuvées ») ou non (« En relecture »). Ordre et titres : voir Global Constraints. Groupes vides retirés.
  - `worktreePath(home: string, name: string, branch: string): string`.
  - `checkoutOf(porcelain: string, branch: string): string | null` : dossier du bloc de `git worktree list --porcelain` dont la ligne est `branch refs/heads/<branch>`.
  - `spaceShowing(spaces: SpaceInfo[], panes: PaneInfo[], name: string, branch: string): string | null` : id du premier espace local (`machine === null`) où `space.branch === branch` ou une pane de ses tabs a `branch === branch`, **et** dont le dossier (`space.folder` ou `pane.cwd`) a `name` comme segment de chemin.

- [ ] **Step 1: Write the failing tests** (`node:test`, `node:assert/strict`)
  - `searchVariables(new Date("2026-11-19T10:00:00Z")).drafts` contient `updated:>=2026-10-20` et `org:softwarevidal`.
  - `groupsFrom` : une PR `ready` `APPROVED` va dans `approved`, une `CHANGES_REQUESTED` et une `null` dans `review-mine` ; un `assigned` vide n'apparaît pas ; ids dans l'ordre `drafts, review-mine, approved, review-requested, assigned`.
  - `worktreePath("/h", "vira", "feat/x-y")` === `"/h/.herdr/worktrees/vira/feat-x-y"`.
  - `checkoutOf` sur un porcelain de deux blocs renvoie le dossier du second pour sa branche, `null` pour une branche absente.
  - `spaceShowing` : deux espaces sur `feat/x`, l'un dans `/w/arthur`, l'autre dans `/w/vira` ; avec `name = "vira"` renvoie le second. Un espace distant (`machine: "vps"`) est ignoré. Une branche trouvée seulement via la `cwd` d'une pane est trouvée.

- [ ] **Step 2: Run, expect FAIL**: `node --test herdr/.config/herdr-app/mods/prs/` → `Cannot find module './model.js'`.
- [ ] **Step 3: Implement `model.js`.**
- [ ] **Step 4: Run, expect PASS**: même commande, tous verts.
- [ ] **Step 5: Commit** `Add pure model for the Herdr pull requests panel`.

### Task 2: mod `prs` (données, ouverture, vue)

**Files:**
- Create: `herdr/.config/herdr-app/mods/prs/mod.json` : `{ "place": "none", "title": "Pull requests" }`
- Create: `herdr/.config/herdr-app/mods/prs/open.js`
- Create: `herdr/.config/herdr-app/mods/prs/main.js`
- Test: `herdr/.config/herdr-app/mods/prs/open.test.mjs`
- Modify: `.gitignore` : ajouter `herdr/.config/herdr-app/mods/*/jsconfig.json` et `herdr/.config/herdr-app/mods/*/gpui-kit.d.ts` (fichiers écrits par Herdr).

**Interfaces:**
- Consumes: tout `model.js` (Task 1).
- Produces (`open.js`, dépendances injectées pour être testable sous Node) :
  - `type Deps = { exec(cmd, args, opts?): Promise<{code, stdout, stderr}>, home: string, spaces(): SpaceInfo[], panes(): PaneInfo[], run(name, args): void, notify(n): void }`
  - `fetchGroups(deps): Promise<Group[]>` : `gh api graphql -f query=GRAPHQL -f drafts=… -f ready=… -f review=… -f assigned=…` ; `code !== 0` → `throw new Error(<1re ligne de stderr>)`.
  - `openPr(pr: Pr, deps): Promise<"focused" | "opened" | "github">`, dans l'ordre :
    1. `spaceShowing(...)` → `run("space.select", { id })`, `"focused"`.
    2. clone = premier de `~/work/<name>`, `~/perso/<name>` où `exec("test", ["-d", dir+"/.git"])` ou `-e` réussit ; aucun → `notify` « Pas de clone local de <repo> » + `xdg-open`, `"github"`.
    3. `checkoutOf(git worktree list --porcelain)` trouvé → `space.new { folder }`, `"opened"`.
    4. `git -C clone fetch origin <branch>` puis `git -C clone worktree add <worktreePath> <branch>` (DWIM : suit `origin/<branch>`) ; un échec → `notify` avec la 1re ligne de stderr + `xdg-open`, `"github"`. Succès → `space.new { folder: worktreePath }`, `"opened"`.
    - Un `openPr` déjà en cours pour la même `pr.url` renvoie la même promesse (pas de second `git`).

- [ ] **Step 1: Write the failing tests** (`open.test.mjs`, `exec` simulé qui enregistre ses appels)
  - espace existant → `space.select` avec son id, aucun `exec git`.
  - pas de clone → `notify` appelé, `xdg-open` appelé avec `pr.url`, résultat `"github"`.
  - checkout existant dans le porcelain → `space.new { folder: <ce dossier> }`, pas de `fetch`.
  - fetch en échec (fork) → `notify` + `xdg-open`, pas de `worktree add`, pas de `space.new`.
  - cas nominal → `fetch`, `worktree add /h/.herdr/worktrees/vira/feat-x feat/x`, `space.new`.
  - deux `openPr` simultanés sur la même PR → un seul `fetch`.
  - `fetchGroups` avec `code: 1, stderr: "gh: not logged in\n…"` rejette avec `gh: not logged in`.
- [ ] **Step 2: Run, expect FAIL**: `node --test herdr/.config/herdr-app/mods/prs/` → `Cannot find module './open.js'`.
- [ ] **Step 3: Implement `open.js`.**
- [ ] **Step 4: Run, expect PASS.**
- [ ] **Step 5: Implement `main.js`**: `export default class Prs extends View`.
  - `init` : `this.groups = []`, `this.error = null`, `this.loading = false`, `this.opening = new Set()` ; si `checking()` rien d'autre ; sinon `cx.timer.every(300000, (cx) => this.refresh(cx))` et `this.refresh(cx)`.
  - `refresh(cx)` : `cx.spawn` → `fetchGroups` ; succès remplace `groups` et vide `error`, échec ne touche qu'`error` ; `cx.notify()`.
  - `render` : en-tête « Pull requests » + bouton « Rafraîchir » (`…` pendant `loading`) ; `error` en `theme().blocked` ; par section un titre, par groupe un sous-titre avec le compte, puis les lignes (titre tronqué, `repo#numéro` en `dim`, « ouverture… » si dans `opening`). Ligne : `.id(pr.url)`, `.on_click` → `openPr` dans `cx.spawn`, `.on_mouse_down("right", …)` → `exec("xdg-open", [pr.url])`. Zone scrollable `overflow_y_scrollbar()`. Couleurs via `theme()`. Aucune liste : « Aucune PR ».
  - Deps réelles : `exec, home(), spaces, panes, run, notify` importés de `"herdr"`.
- [ ] **Step 6: Stow and check**: ajouter au `install.sh`, après le bloc `claude`, un bloc `stow --verbose --restow herdr` sur le même modèle (message d'erreur avec `stow --adopt herdr`). Lancer `stow --verbose --restow herdr` puis `herdr-app check ~/.config/herdr-app/mods/prs`. Attendu : check sans erreur et `~/.config/herdr-app/mods/prs` est un lien vers le dépôt. Si Herdr ne suit pas le lien (check ou chargement en échec), s'arrêter et le signaler.
- [ ] **Step 7: Commit** `Add Herdr pull requests panel mod` (avec `.gitignore` et `install.sh`).

### Task 3: layout `nico` et essai dans l'app

**Files:**
- Create: `herdr/.config/herdr-app/layouts/nico.json`

**Interfaces:**
- Consumes: le mod `prs` (Task 2).

- [ ] **Step 1: Clone the layout**: `herdr-app do layout.clone '{"name":"main","as":"nico"}'` (bascule sur `nico`), puis déplacer `~/.config/herdr-app/layouts/nico.json` dans `herdr/.config/herdr-app/layouts/` et relancer `stow --restow herdr`.
- [ ] **Step 2: Add the block**: dans `work-body`, après `panel`, ajouter `{ "id": "prs", "type": "block", "size": { "px": 340 }, "min": 260, "max": 700, "content": { "mod": "prs" } }`.
- [ ] **Step 3: Verify**: `herdr-app status` sans `layout.error` ni erreur de mod ; `herdr-app shot $SCRATCH/prs.png` montre le panneau à droite avec les groupes non vides (aujourd'hui : 3 brouillons, 9 en relecture, 2 approuvées, 4 relectures demandées, 2 assignées, à quelques unités près).
- [ ] **Step 4: Try the clicks** avec Nicolas : clic gauche sur une PR dont l'espace est ouvert (focus), sur une PR sans worktree (`~/.herdr/worktrees/<repo>/<branche>` créé, nouvel espace), sur une PR KentBeck (toast + GitHub) ; clic droit (GitHub).
- [ ] **Step 5: Commit** `Add Herdr layout with the pull requests panel`.

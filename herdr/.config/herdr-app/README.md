# Herdr — antisèche

Mémo pour se servir de l'app Herdr (Linux) avec **cette** config : le layout `nico`, les raccourcis de `keys.json` et le mod `prs`. La doc complète, réécrite par Herdr à chaque démarrage, est dans `AGENTS.md` (et `herdr-app --skill`).

---

## 1. Le modèle

| Mot | C'est quoi |
|---|---|
| **Space** | Un lieu de travail, en général un dépôt ou un worktree. Il porte le nom de son dossier tant qu'on ne le renomme pas. |
| **Tab** | Une tâche dans un space : ses terminaux et leurs découpes. Fermer le dernier tab ferme le space. |
| **Pane** | Un terminal à l'écran, ou un mod posé à côté. |
| **Agent** | Un terminal dont le programme publie un état (Claude) : `working`, `blocked` (il t'attend), `done` (fini pendant que tu regardais ailleurs), `idle`. |

Les terminaux tournent dans **herdr-core** (`hc`), pas dans la fenêtre : fermer ou mettre à jour l'app ne tue rien.

---

## 2. L'écran (layout `nico`)

```
┌─────────────┬──────────────────────────────────────┬────────────────┐
│ Spaces      │ tabs …………………… + Files Changes       │ Pull requests  │
│             ├──────────────────────────────────────┤ MES PR         │
│             │                                      │  En cours      │
│─────────────│     tab courant (ses panes)          │  En relecture  │
│ Agents      │                                      │  Approuvées ✓  │
│             │                                      │ JE CONTRIBUE   │
│             │                                      │  Relecture dem.│
│             │                                      │  Assignées     │
├─────────────┴──────────────────────────────────────┴────────────────┤
│ machine · branche · N agents                    Ctrl+Shift+P cmds   │
└─────────────────────────────────────────────────────────────────────┘
```

- **Sidebar** (`Ctrl+Shift+B` pour la replier) : les spaces, puis les agents de tous les spaces.
- **Files / Changes** : panneau livré par Herdr, entre les terminaux et le panneau PR.
- **Pull requests** (`Ctrl+Shift+R` pour le masquer) : le mod `prs`, voir §4.

`nico` est un clone du layout `main` de Herdr : `Ctrl+Shift+L` passe d'un layout à l'autre, `main` n'a pas le panneau PR.

---

## 3. Raccourcis

### Les indispensables

| Touche | Action |
|---|---|
| `Ctrl+Shift+P` | Palette de commandes |
| `Ctrl+Shift+K` | Picker : aller à un tab, un space ou un agent |
| `Ctrl+Shift+?` | Aide de Herdr |
| `Ctrl+,` | Réglages |

### Spaces, tabs, agents

| Touche | Action |
|---|---|
| `Ctrl+Shift+N` | Nouveau space |
| `Ctrl+Shift+T` / `Ctrl+Shift+W` | Nouveau tab / fermer le tab |
| `Ctrl+1` … `Ctrl+9` | Aller au tab n |
| `Alt+1` … `Alt+9` | Aller au space n |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` (ou `Alt+]` / `Alt+[`) | Tab suivant / précédent |
| `Ctrl+Shift+PgDn` / `Ctrl+Shift+PgUp` | Space suivant / précédent |
| `Alt+↓` / `Alt+↑` | Agent suivant / précédent |
| `F2` / `Shift+F2` | Renommer le tab / le space |

### Panes

| Touche | Action |
|---|---|
| `Ctrl+Shift+O` / `Ctrl+Shift+E` | Split à droite / en bas |
| `Ctrl+Shift+X` | Fermer le pane (tue son terminal) |
| `Ctrl+Shift+Z` | Zoomer / dézoomer le pane |
| `Alt+H J K L` (ou `Alt+←` `Alt+→`) | Aller au pane voisin |
| `Alt+Shift+H J K L` | Échanger avec le pane voisin |

### Dans un terminal

| Touche | Action |
|---|---|
| `Ctrl+Shift+F` | Chercher dans l'écran et l'historique |
| `Ctrl+Shift+C` / `Ctrl+Shift+V` | Copier / coller |
| `Ctrl+V` | Coller une **image** (capture pour Claude) |
| `Ctrl+←` / `Ctrl+→` | Mot précédent / suivant |
| `Ctrl+Backspace` | Effacer le mot avant le curseur |

### Fenêtre

| Touche | Action |
|---|---|
| `Ctrl+Shift+B` | Replier / déplier la sidebar |
| `Ctrl+Shift+R` | Masquer / afficher le panneau Pull requests |
| `Ctrl+Shift+L` | Changer de layout |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | Zoom + / − / normal |
| `Ctrl+Alt+Shift+Échap` | **Secours** : remet le layout `main` et met `keys.json` de côté |

---

## 4. Le panneau Pull requests (mod `prs`)

Mes PR GitHub ouvertes, en deux sections :

- **Mes PR** : *En cours* (brouillons `softwarevidal` actifs depuis 30 jours), *En relecture* (prêtes, sans approbation), *Approuvées* (badge vert avec le nombre d'approbations, une par relecteur).
- **Je contribue** : *Relecture demandée* à moi, *Assignées* à moi.

| Geste | Effet |
|---|---|
| Clic gauche | Va dans le space de la branche de la PR. Sinon crée un worktree dans `~/.herdr/worktrees/<repo>/<branche>` depuis le clone `~/work/<repo>` ou `~/perso/<repo>` et ouvre un space dessus (un shell, pas d'agent). Sans clone, ou PR venant d'un fork : toast et PR sur GitHub. |
| Clic droit | La PR sur GitHub. |
| Rafraîchir | Recharge tout de suite (sinon toutes les 5 min). |

Données : un seul `gh api graphql`. Une erreur de `gh` s'affiche en rouge en tête, la liste précédente reste. Conception : `docs/specs/2026-11-19-herdr-pr-panel-design.md` à la racine des dotfiles.

---

## 5. En ligne de commande

```sh
herdr-app ls                 # spaces, tabs, terminaux
herdr-app status             # ce qui est à l'écran, erreurs des fichiers et des mods
herdr-app commands           # toutes les commandes et leurs arguments
herdr-app do layout.toggle '{"id":"prs"}'
herdr-app shot /tmp/herdr.png  # capture de la fenêtre

hc ls                        # tous les terminaux de herdr-core
hc read t3 --lines 50        # lire l'écran d'un terminal
hc send t3 "texte"           # lui écrire
hc wait t3                   # attendre qu'un agent ait fini
```

---

## 6. Personnaliser sans casser

- **Où sont les fichiers** : `keys.json`, `layouts/nico.json` et `mods/prs/` sont dans le paquet stow `herdr` des dotfiles (`stow --restow herdr`, fait par `install.sh`). Le reste de `~/.config/herdr-app` appartient à Herdr.
- **Recharger un mod** : Herdr ne voit pas les modifications à travers le lien stow. Changer de layout et revenir :
  `herdr-app do layout.switch '{"name":"main"}' && herdr-app do layout.switch '{"name":"nico"}'`
- **Vérifier un mod** : `herdr-app check ~/.config/herdr-app/mods/prs` et `node --test ~/.dotfiles/herdr/.config/herdr-app/mods/prs/`.
- **Layout ou mod livré par Herdr** : ne jamais l'éditer (écrasé au démarrage), le cloner (`layout.clone`, `mod.clone`).
- **Après le raccourci de secours** ou si Herdr réécrit `keys.json`, le lien stow devient un vrai fichier : `stow --adopt herdr && git diff`.
- `gpui-kit.d.ts` et `jsconfig.json`, écrits par Herdr dans chaque mod, sont ignorés par git.

# Herdr — antisèche

Mémo pour se servir de l'app Herdr (Linux) avec **cette** config : le layout `nico` et les raccourcis de `keys.json`. La doc complète, réécrite par Herdr à chaque démarrage, est dans `AGENTS.md` (et `herdr-app --skill`).

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
┌─────────────┬──────────────────────────────────────┐
│ Spaces      │ tabs …………………… + Files Changes       │
│             ├──────────────────────────────────────┤
│             │                                      │
│─────────────│     tab courant (ses panes)          │
│ Agents      │                                      │
├─────────────┴──────────────────────────────────────┤
│ machine · branche · N agents   Ctrl+Shift+P cmds   │
└────────────────────────────────────────────────────┘
```

- **Sidebar** (`Ctrl+Shift+B` pour la replier) : les spaces, puis les agents de tous les spaces.
- **Files / Changes** : panneau livré par Herdr, à droite des terminaux.

`nico` est un clone du layout `main` de Herdr : `Ctrl+Shift+L` passe d'un layout à l'autre.

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
| `Ctrl+Shift+L` | Changer de layout |
| `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | Zoom + / − / normal |
| `Ctrl+Alt+Shift+Échap` | **Secours** : remet le layout `main` et met `keys.json` de côté |

---

## 4. En ligne de commande

```sh
herdr-app ls                 # spaces, tabs, terminaux
herdr-app status             # ce qui est à l'écran, erreurs des fichiers et des mods
herdr-app commands           # toutes les commandes et leurs arguments
herdr-app do layout.toggle '{"id":"sidebar"}'
herdr-app shot /tmp/herdr.png  # capture de la fenêtre

hc ls                        # tous les terminaux de herdr-core
hc read t3 --lines 50        # lire l'écran d'un terminal
hc send t3 "texte"           # lui écrire
hc wait t3                   # attendre qu'un agent ait fini
```

---

## 5. Personnaliser sans casser

- **Où sont les fichiers** : `keys.json` et `layouts/nico.json` sont dans le paquet stow `herdr` des dotfiles (`stow --restow herdr`, fait par `install.sh`). Le reste de `~/.config/herdr-app` appartient à Herdr.
- **Recharger un mod** : Herdr ne voit pas les modifications à travers le lien stow. Changer de layout et revenir :
  `herdr-app do layout.switch '{"name":"main"}' && herdr-app do layout.switch '{"name":"nico"}'`
- **Vérifier un mod** : `herdr-app check ~/.config/herdr-app/mods/<mod>`.
- **Layout ou mod livré par Herdr** : ne jamais l'éditer (écrasé au démarrage), le cloner (`layout.clone`, `mod.clone`).
- **Après le raccourci de secours** ou si Herdr réécrit `keys.json`, le lien stow devient un vrai fichier : `stow --adopt herdr && git diff`.
- `gpui-kit.d.ts` et `jsconfig.json`, écrits par Herdr dans chaque mod, sont ignorés par git.

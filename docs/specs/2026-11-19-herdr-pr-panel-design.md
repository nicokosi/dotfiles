# Panneau « Pull requests » pour Herdr

## Pourquoi

Voir d'un coup d'œil, à côté des terminaux, les PR GitHub qui demandent
mon attention (les miennes, et celles où l'on m'attend) et sauter dans
l'espace Herdr de l'une d'elles en un clic.

## Ce que montre le panneau

Bloc à droite des terminaux, identique quel que soit l'espace affiché.
PR ouvertes de `nicokosi`, en deux groupes :

- **Mes PR**
  - En cours : brouillons de l'organisation `softwarevidal` mis à jour
    dans les 30 derniers jours (les autres brouillons sont cachés, sans
    dépliage).
  - En relecture : prêtes, sans approbation (aucune revue ou changements
    demandés).
  - Approuvées.
- **Je contribue**
  - Relecture demandée à moi (`review-requested:@me`).
  - Assignées à moi (`assignee:@me`).

Ligne : titre, `repo#numéro`. Un groupe vide est masqué.

## Actions

- **Clic gauche** : naviguer, sans lancer d'agent.
  1. Un espace local montre déjà la branche (dossier d'un espace ou cwd
     d'une de ses panes sur cette branche) : le mettre au premier plan.
  2. Sinon, clone trouvé dans `~/work/<repo>` puis `~/perso/<repo>` :
     `git fetch origin <branche>`, worktree dans
     `~/.herdr/worktrees/<repo>/<branche>` (slashes en tirets, comme
     Herdr), nouvel espace dessus avec un shell. Un worktree existant à
     cet endroit est réutilisé.
  3. Sinon : toast « pas de clone local » et ouverture de la PR sur
     GitHub.
- **Clic droit** : ouvrir la PR sur GitHub.

## Approches

- **A, retenue** : mod `prs` + layout `nico` cloné de `main` avec un bloc à
  droite. Vue globale, `main` intact.
- B : panneau à onglets façon `tabs-jc` de jcgay. Écarté : beaucoup de
  code pour un seul panneau.
- C : mod posé en pane (`pane.split`). Écarté : lié à un tab, disparaît
  en changeant d'espace.

## Données et rafraîchissement

Un seul `gh api graphql` avec cinq recherches en alias (`isDraft`,
`reviewDecision`, `headRefName`, `updatedAt`, `url`, dépôt). Rafraîchi à
l'affichage, toutes les 5 min tant que le panneau est visible, et par un
bouton « Rafraîchir ». Une erreur `gh` s'affiche en tête du panneau ; la
dernière liste reste affichée.

## Hors périmètre

Checks CI, builds Jenkins, merge, démarrage d'agent, autres comptes ou
GitHub Enterprise.

## Laissé au builder

Style des lignes et badges, emplacement exact du bloc dans le layout,
logique pure isolée dans `model.js` testée avec `node --test` (comme
jcgay). Les fichiers vivent dans le paquet stow `herdr` de ce dépôt
(`herdr/.config/herdr-app/...`).

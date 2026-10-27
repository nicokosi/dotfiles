# Git commit messages

The harnais team rule (git-commit) applies. These overrides win over it:

- Committing directly on `master`/`main` is allowed in repositories whose
  remote is not under `github.com/softwarevidal/`. In `softwarevidal`
  repositories, keep the team rule: create a branch first.
- Skip the Jira footer (`See MERLIN-2303`) when the subject already carries
  the ticket prefix.

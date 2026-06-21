---
name: project-main-branch
description: The real main branch is samba/develop; samba/main is unmaintained. Fix origin/HEAD on fresh clones.
metadata:
  type: project
---

The actual main/integration branch for this project is **`samba/develop`**. `samba/main` exists but is **unmaintained** — never use it as a PR base or diff target.

Claude Code derives "the main branch" from git's `refs/remotes/origin/HEAD` pointer, which is per-clone local state (in `.git/`) and does **not** sync through the `claude-config` repo. A fresh clone usually points `origin/HEAD` at `samba/main`, making diffs/PR bases wrong.

**Fix per clone** (one-time, local, reversible):
```
git remote set-head origin samba/develop
```
Applied to the three desktop clones (Hole.io, Hole.io_Live, Hole.io_Release) on 2026-06-09. Re-run it on any new clone on any machine. See [[user-project-copies]].

# todo-maintainer — notes

## What this agent does differently

Most agents that maintain a to-do list edit a `TODO.md` at the target repo's root.
This one does **not**. Every repo's list is centralised here, in `todos/<repo>.md`,
keyed by the repo's directory/folder name (from `git rev-parse --show-toplevel`,
falling back to `pwd`).

Why centralise:
- One agent, many repos — no per-repo agent copy or per-repo TODO.md to seed.
- The lists travel with the agent (except the contents themselves — see "Privacy").

## todos/ folder

One file per repo, named after the repo's folder. Each file keeps **its own**
section + numbering convention — the agent follows whatever scheme is already in
the file it opens and must not impose one repo's scheme on another. When a repo
has no file yet, the agent creates one on first use.

## Privacy

`todos/` holds real project backlog detail, so it is **gitignored** in this repo
(`todos/` entry in `.gitignore`). The agent definition, README, and these notes
are committed; the to-do contents are not. If you ever want them version-
controlled, move them to a private repo and adjust the gitignore.

## Design

- Earlier this agent lived inside a single project and was hardcoded to that
  repo's `TODO.md` path and section structure. It has been generalised so one
  global definition serves every repo.
- The agent leaves each target repo's working tree untouched — it only edits
  files under `todos/`.

## Source-of-truth caveat

If a repo also keeps its to-do items somewhere else (a root `TODO.md`, project
memory, an issue tracker), that original and this agent's `todos/` copy can drift.
Going forward, edits via this agent land in `todos/`. Decide per repo whether to
retire the original location or keep both in sync.

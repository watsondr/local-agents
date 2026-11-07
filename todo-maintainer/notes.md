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

One file per repo, named after the repo's folder. Every file uses the **same
format**: one single ordered list of items, newest at position 1, contiguous
numbering with no gaps, no per-type sections, no stable IDs. Item type is an
inline `[type]` tag, not a grouping. When a repo has no file yet, the agent
creates one on first use. Any file still in the old sectioned/ID format gets
migrated to the single-list format the next time the agent touches it.

### Why single-list (user decision 2026-07-23)

The earlier design gave each repo per-type sections (backend/product/UI) with
stable prefixed IDs (`B1`, `P1`, `U1`) plus a separate cross-cutting "execution
order" list. The user found this confusing: they want **one** list of things to
do, ordered by priority, with the newest item always at 1 — and the *type* of an
item kept separate from its place in the queue. So sections and stable IDs were
removed in favour of a single recency-topped list with inline type tags.

## history/ folder (user decision 2026-09-27)

Completed work, shipped write-ups, review sign-offs and migration notes go in
`history/<repo>.md`, newest first, never in the to-do file. The agent had been
stacking "History — Shipped" blockquotes in the to-do preamble, and budgetApp's
list grew about 100 lines of it before any open item appeared. Every spawn read
all of that to edit one item. The existing blocks were moved out on 2026-09-27;
the agent now appends a dated entry on every mark-done and only reads the
history file when asked about past work.

Standing list rules (ordering principle, branch policy) stay in the to-do file
because they govern open work. Past-work context inside an open item's body
also stays when the item needs it.

## Privacy

`todos/` holds real project backlog detail, so it is **gitignored** in this repo
(`todos/` entry in `.gitignore`). `history/` is gitignored for the same
reason. The agent definition, README, and these notes are committed; the to-do
contents are not. If you ever want them version-controlled, move them to a
private repo and adjust the gitignore.

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

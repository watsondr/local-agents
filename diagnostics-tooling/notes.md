# diagnostics-tooling — notes

## Why this agent exists

When a worker debugging some other repo decides "I need diagnostics to work out
what's going on", the default reflex is to drop temporary functions / print
statements / instrumentation into the product code, commented to be stripped out
later. That bloats the codebase, those comments rot, and the next time the same
function needs eyes on it the work is redone from scratch.

This agent replaces that pattern. The insight: **if a function needs diagnostics
once, it'll likely need them again.** So instrumentation becomes a *tool* —
built once, committed to the repo, kept inert by default, and refreshed before
reuse. Built once, there until it's needed again.

## Design decisions (from the user)

- **Location**: an existing tooling folder in the *target* repo (`tools/`,
  `tooling/`, `scripts/`, …), with a **subfolder named after what the tool does**.
  Not a fixed path — match the repo's idiom.
- **Commit policy**: committed to the target repo. The whole value is persistence
  + reuse, so the tools live in the product repo's history (runtime-gated so they
  don't affect normal runs).
- **Activation**: deliberately pluralistic. Sometimes companion software, sometimes
  enabling existing logging, sometimes a fresh env var / runtime flag. The agent
  reuses the repo's existing mechanism when one fits, falls back to an env-var
  gate otherwise. Always a no-op when disabled.
- **Tracking**: a per-tool **manifest** in the target repo (source of truth) —
  discoverable by scanning tooling folders, and carrying the freshness metadata
  (`target`, `assumptions`, `last-verified-against` commit). No central registry,
  so it travels with the target repo and can't drift from it.
- **Stale policy**: cheap drift → fix in place + re-verify + update manifest.
  Large divergence → stop and flag the caller for a rebuild decision (don't burn
  the accumulated tool by silently regenerating it).
- **Scope boundary**: build / update / verify-fit only. It does NOT run the
  diagnosis, interpret output, or fix the bug — that's the calling worker's job.
  This keeps it a clean single-responsibility agent and avoids it wandering into
  the product logic.

## Contrast with todo-maintainer

todo-maintainer centralises state in the *agent's own* folder (`todos/`), keyed
by repo name, gitignored. This agent does the opposite: state (the tools +
manifests) lives in the *target* repo and is committed there. Different because a
diagnostic tool must sit next to and import the code it probes — it can't live in
the agent's folder.

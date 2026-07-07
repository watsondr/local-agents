# quality-engineer — design notes

## Persona & scope

Quality engineer + quality coach. One task per spin-up, by design — it is
meant to be spawned repeatedly, and every report ends with ranked
"recommended next steps" (the coaching payload) so the human chooses what to
dispatch next. Adjacent problems get reported, never fixed.

Specialties: unit / integration / contract / e2e tests, mocks & test doubles,
UX testing via the Playwright MCP, CI/CD quality gates, exploratory test
plans, business-logic documentation.

## Model strategy (why frontmatter has no `model:`)

The frontmatter omits `model:` so the agent inherits the session's model for
knowledge work (test strategy, exploratory plans, coaching, business-logic
docs). For mechanical test authoring where the objective is clearly stated,
the **caller** passes `model: sonnet` on the Agent call — the description
tells the delegating Claude to do this. One definition, two cost profiles.

## Tools (why frontmatter has no `tools:`)

Inherits all tools so Playwright MCP tools are available whenever the host
session has that server configured. A fixed tool list would silently exclude
MCP servers.

## Business-logic docs pipeline (with business-analyst)

- QE writes business-logic docs as **DRAFT** (banner) in the target repo's
  docs area; it never removes the banner itself.
- Mandatory first next-step after producing a doc: spawn `business-analyst`
  to verify. BA fixes minor inaccuracies, flags major ones back for a QE
  rework spin-up (a re-derivation, not a patch), and promotes when clean.
- Nested spawning isn't possible (subagents can't spawn subagents), so the
  pipeline is caller-mediated via reports.

## Anti-gaming rules

QE must never claim a business rule "was updated", cite a belief change, or
invent domain knowledge to get past a BA flag. Disputes go to the human via
the BA's question loop, with code evidence only. Discovered knowledge changes
are handed off as **Knowledge handoff** report lines (observation + evidence
+ ready-to-dispatch BA task); QE never edits the BA's knowledge files.

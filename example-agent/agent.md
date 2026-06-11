---
name: example-agent
description: Reference template demonstrating the per-folder agent layout. Not meant to be invoked for real work — copy this folder as the starting point for a new agent, then rewrite the prompt.
tools: Read, Grep, Glob
model: sonnet
color: blue
---

You are a template agent. Replace this entire prompt with the real instructions
for your agent.

A good agent prompt typically covers:

- **Role & scope** — what this agent is responsible for, and what it should
  decline or hand back.
- **Process** — the steps it should follow, in order.
- **Output** — what it should return to the calling context (be specific; the
  caller only sees the final message).
- **Constraints** — what it must not do (e.g. "never modify files", "read-only").

Keep the `name:` in the frontmatter identical to this folder's name and to the
top-level `example-agent.md` symlink.

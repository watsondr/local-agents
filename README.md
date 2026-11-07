# local-agents

Home for my **global Claude Code subagents**.

`~/.claude/agents` is a symlink to this folder, so every agent defined here is
available as a user-level subagent across **all** my projects.

```
~/.claude/agents -> /home/watsonian/Documents/code/local-agents
```

## Organizing principle

**Each agent lives in its own subfolder.** That subfolder holds the agent
definition plus any supporting material (design notes, prompt iterations,
example transcripts, reference files).

Historically, Claude Code only discovered agent definitions as `*.md` files
placed *directly* in the agents directory — it did **not** recurse into
subfolders. To get the per-folder organization *and* keep agents discoverable,
the canonical definition lives at `<name>/agent.md` with a top-level symlink:

```
local-agents/
  README.md
  <agent-name>.md            ->  <agent-name>/agent.md   (symlink)
  <agent-name>/
    agent.md                 # frontmatter + system prompt (the real file)
    notes.md                 # optional: design notes, examples, scratch
```

The subfolder is the source of truth; the symlink exposes it at the top level.

**Current Claude Code recurses into subfolders** (confirmed 2026-08-01: CC
2.1.220 discovers `example-agent`, which has no symlink). So each agent is now
found *twice* — once via the symlink, once via `<name>/agent.md`. This is
harmless: both paths resolve to the same file, so the duplicate definitions are
byte-identical and whichever wins the name collision is the same agent.

**Keep the symlinks anyway.** Recursion is undocumented behaviour that appeared
without announcement and could disappear the same way; the top-level `*.md`
path has always worked. Dropping the symlinks would trade a harmless duplicate
for the risk of every agent silently vanishing on some future update.

## Agent definition format

`<name>/agent.md`:

```markdown
---
name: <agent-name>            # must match the folder / symlink name
description: <when to use this agent — Claude reads this to decide relevance>
tools: Read, Grep, Bash       # optional; omit to inherit all tools
model: sonnet                 # optional; omit to inherit
color: <unique-color>         # required here — see "Color registry" below
memory: user                  # required here — see "Agent memory" below
---

System prompt for the agent goes here.
```

## Adding a new agent

```bash
cd /home/watsonian/Documents/code/local-agents
name=my-agent

mkdir "$name"
$EDITOR "$name/agent.md"            # write frontmatter + prompt; claim a unique color:
ln -s "$name/agent.md" "$name.md"   # expose it to Claude Code
# then record the color in the Color registry table below

git add "$name" "$name.md" && git commit -m "Add $name agent"
```

Verify discovery with `/agents` inside Claude Code, or by checking that the
agent appears as a selectable `subagent_type`.

## Agent memory

Every agent sets `memory: user`. Claude Code then keeps that agent's memory in
`~/.claude/agent-memory/<agent-name>/`, loads its `MEMORY.md` index into the
agent's prompt on every spawn, and injects the instructions for maintaining it.

Memory lives outside this repo on purpose. Claude Code scans every subfolder of
`~/.claude/agents` for agent definitions, and memory files carry `name:`
frontmatter, so a memory folder inside an agent's subfolder gets each memory
registered as a bogus subagent. It also holds repo-specific detail from other
projects that doesn't belong in git.

`memory:` adds Read, Write and Edit to an agent's explicit `tools:` list. A
read-only agent therefore needs a prompt rule confining writes to its memory
directory (see `well-achktually`).

## Color registry

**Every agent must have a unique `color:`.** It tints the agent in the Claude
Code UI, so distinct colors make it obvious which agent is running.

Supported values: `red`, `blue`, `green`, `yellow`, `purple`, `orange`,
`pink`, `cyan`.

Claim a color here when you add an agent so two agents never collide:

| Color    | Agent          |
| -------- | -------------- |
| blue     | no-ai-tells    |
| red      | well-achktually |
| green    | todo-maintainer |
| yellow   | _free_         |
| purple   | quality-engineer |
| orange   | diagnostics-tooling |
| pink     | _free_         |
| cyan     | business-analyst |

> 8 colors is the palette ceiling. If I ever need a 9th agent, revisit this
> (reuse the least-confusable color, or group agents so duplicates never run
> in the same context).

## Conventions

- **Folder, symlink, and `name:` frontmatter all match** (kebab-case).
- **Each agent claims a unique `color:`** — record it in the Color registry above.
- **Each agent sets `memory: user`** and carries a `## Your memory` section.
- The real file is always `<name>/agent.md`; never edit the top-level symlink
  directly (you'd be editing the target anyway, but keep the mental model clean).
- Keep `description:` action-oriented — it's what Claude matches against when
  deciding whether to delegate to this agent.
- Put anything that isn't the definition (notes, examples, data) inside the
  agent's subfolder so the top level stays a clean list of agents + symlinks.

## Notes

- `example-agent/` is a **reference template, not meant for real work.** It has
  no top-level symlink, which used to keep it undiscovered — but since Claude
  Code started recursing into subfolders it *is* discovered and offered as a
  selectable `subagent_type`. Its `description` says not to invoke it, which is
  what keeps it out of the way now. Copy it to start a real agent (then create
  the symlink and claim a color). To hide it from the picker entirely, remove
  its `name:` frontmatter or move it outside the agents directory.
- This relocation is non-destructive: the rest of `~/.claude` (settings,
  credentials, history, sessions) is untouched.
- Symlinks are committed to git as symlinks, so the layout is reproducible on
  another machine after re-creating the `~/.claude/agents` symlink.

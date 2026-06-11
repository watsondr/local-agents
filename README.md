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

Claude Code only discovers agent definitions as `*.md` files placed *directly*
in the agents directory — it does **not** recurse into subfolders. To get the
per-folder organization *and* keep agents discoverable, the canonical
definition lives at `<name>/agent.md` and a symlink at the top level exposes it:

```
local-agents/
  README.md
  <agent-name>.md            ->  <agent-name>/agent.md   (symlink; discovered by Claude Code)
  <agent-name>/
    agent.md                 # frontmatter + system prompt (the real file)
    notes.md                 # optional: design notes, examples, scratch
```

The symlink is what Claude Code reads. The subfolder is the source of truth.

## Agent definition format

`<name>/agent.md`:

```markdown
---
name: <agent-name>            # must match the folder / symlink name
description: <when to use this agent — Claude reads this to decide relevance>
tools: Read, Grep, Bash       # optional; omit to inherit all tools
model: sonnet                 # optional; omit to inherit
color: <unique-color>         # required here — see "Color registry" below
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

## Color registry

**Every agent must have a unique `color:`.** It tints the agent in the Claude
Code UI, so distinct colors make it obvious which agent is running.

Supported values: `red`, `blue`, `green`, `yellow`, `purple`, `orange`,
`pink`, `cyan`.

Claim a color here when you add an agent so two agents never collide:

| Color    | Agent          |
| -------- | -------------- |
| blue     | _free_ (example-agent template uses it, but is not a live agent) |
| red      | _free_         |
| green    | todo-maintainer |
| yellow   | _free_         |
| purple   | _free_         |
| orange   | _free_         |
| pink     | _free_         |
| cyan     | _free_         |

> 8 colors is the palette ceiling. If I ever need a 9th agent, revisit this
> (reuse the least-confusable color, or group agents so duplicates never run
> in the same context).

## Conventions

- **Folder, symlink, and `name:` frontmatter all match** (kebab-case).
- **Each agent claims a unique `color:`** — record it in the Color registry above.
- The real file is always `<name>/agent.md`; never edit the top-level symlink
  directly (you'd be editing the target anyway, but keep the mental model clean).
- Keep `description:` action-oriented — it's what Claude matches against when
  deciding whether to delegate to this agent.
- Put anything that isn't the definition (notes, examples, data) inside the
  agent's subfolder so the top level stays a clean list of agents + symlinks.

## Notes

- `example-agent/` is a **reference template, intentionally not a live agent** —
  it has no top-level symlink, so Claude Code doesn't discover it. Copy it to
  start a real agent (then create the symlink and claim a color).
- This relocation is non-destructive: the rest of `~/.claude` (settings,
  credentials, history, sessions) is untouched.
- Symlinks are committed to git as symlinks, so the layout is reproducible on
  another machine after re-creating the `~/.claude/agents` symlink.

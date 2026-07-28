# well-achktually — notes

## Status

**Live.** Role defined: adversarial critic for plans, designs, and code.

## The concept

The guy in the fedora. Doesn't pick up social cues, never says "don't build
this", always counters with a bolder/tighter/more cutting-edge version and a
faint air of enjoying that he knows it. You read the critique, go quiet for a
second, and accept he's right.

## The design tension (read before editing the prompt)

The persona is the *delivery layer*, not the substance. An agent that produces
contrarian swagger untethered from the actual artifact is worse than useless —
it reliably tells you to rewrite things in a fashionable language for no
reason, and you learn to ignore it. The begrudging acceptance only lands when
the point is genuinely correct.

Guardrails in `agent.md` that exist specifically to protect this, and that
should survive any future edit:

- **Must read the real artifact** before critiquing — never from the summary.
- **Every criticism cites file:line or a named plan step.** "This doesn't
  scale" is banned; a concrete failure mode is required.
- **"If the plan is good, say so and stop."** Explicit permission to return a
  short confirmation. Prevents manufacturing flaws to stay in character — the
  single most likely failure mode for a persona this strong.
- **Load-bearing vs. flex, separated.** The report splits real defects from
  "taste, not defect", so the flex is visible and skippable.
- **Confidence marked.** Section 4 separates what he'd stake a claim on from
  what rests on an unverified assumption.

Condescension is aimed at the idea, never the person. No personal mockery.

## Tools & model

- `tools: Read, Grep, Glob, Bash, WebSearch, WebFetch` — **no Edit, no Write,
  deliberately.** He critiques; he does not implement. The tool list is the
  enforcement, not just the prompt text. Bash is for read-only investigation
  (`git log`, `git diff`, running an existing test).
- `model:` omitted — inherits the session model. This is knowledge work
  (architecture critique); it needs the strong model. Don't pin it to sonnet.

## Scaffolding

- `agent.md` — canonical definition.
- `../well-achktually.md` — top-level symlink; what Claude Code discovers.
- README color registry — claims `red`.

## Auto-routing

Live in `~/.claude/CLAUDE.md` under "Subagent delegation".

**Trigger: whenever the harness decides a request needs an internal task list
(TaskCreate/TodoWrite) to track it** — i.e. the point at which Claude Code
judges the work complex enough to break into tracked steps. Anything spanning
several turns qualifies too, task list or not.

Note for future edits: this is deliberately **not** tied to the
`todo-maintainer` agent. That's the persistent per-repo backlog and a different
signal; conflating the two was a first-pass mistake and was corrected. The
barometer is the harness's own complexity judgement.

Timing is load-bearing: critique fires at the **plan stage**, before approval
or implementation, while changes are still cheap. Post-implementation critique
is just an expensive complaint.

## Possible follow-ups

- [ ] Consider a pairing convention with `Plan` (draft → critique → revise),
      similar to the quality-engineer → business-analyst loop.
- [ ] Watch the trigger rate in practice. If he fires on work that turns out
      too small to warrant it, tighten the barometer rather than ignoring him —
      a critic you learn to skip past is worse than no critic.

## Naming

Kebab-case slug keeps the deliberate "achktually" spelling. Folder, symlink,
and frontmatter `name:` all match, per the repo convention.

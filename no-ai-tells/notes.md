# no-ai-tells — design notes

## Why this exists

Text drafted by a model has a recognizable signature. Anything a human will
read and judge — PR descriptions, READMEs, release notes, emails — is worse for
carrying it, regardless of whether the content is correct.

## Sources

The tell catalogue in `agent.md` is drawn from published detection work rather
than introspection, which matters: a model asked to describe its own tells
tends to list the famous ones (*delve*, em dashes) and miss the structural
ones, which are the stronger signal.

- [Wikipedia: Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing)
  — the most rigorous catalogue available. Maintained by editors who screen
  submissions at volume, and organized by category (language, style, formatting,
  citation, communication) rather than as a word blacklist. Also tracks how the
  vocabulary shifts by model generation.
- [COLING 2025 focal-word study](https://www.medrxiv.org/content/10.1101/2024.05.14.24307373.full.pdf)
  — measured word-frequency spikes in PubMed abstracts after ChatGPT's release:
  *underscore, meticulous, boast, commendable, showcase, surpass, intricate,
  tapestry*. Empirical rather than anecdotal.
- [Siege Media: how to spot AI-generated text](https://www.siegemedia.com/creation/how-to-spot-ai-generated-text)
  and [Olivia Cal: AI writing tells](https://www.oliviacal.com/post/ai-writing-tells)
  — practitioner-side pattern lists.
- [Mozilla Foundation: How to tell if AI is writing this](https://www.mozillafoundation.org/en/nothing-personal/superficial-intelligence-ai-writing/)
  — sycophancy and hedging as tells.

## Design decisions

**Patterns, not a blacklist.** A grep-able banned-word list would be easy to
follow and wrong. *Crucial* is sometimes the right word. The prompt therefore
teaches recognition and requires judgement, and the report format has a
"judgement calls" section so the caller can see where a flagged pattern was
deliberately kept.

**Structure over vocabulary.** Negative parallelism, participial tails, triads,
and flat rhythm survive a find-and-replace pass and are what readers actually
react to. The vocabulary section is listed first because it is the most
familiar, but the sentence-shape and rhythm sections do the heavier work.

**Editor, not author.** Hard separation between *how it reads* and *what it
says*. The agent has Edit/Write but is forbidden from changing claims, adding
content, or fact-checking — anything it notices goes to the report instead.
This keeps it safe to point at a doc without it quietly rewriting the argument.

**Overcorrection is a failure mode.** Clipped, punchy, uniformly short prose is
its own signature. So is forced informality. The target is unremarkable
competent writing that matches the surrounding material, which is why the
process step requires reading neighbouring files before editing.

**Audit mode.** Detection is the same skill as removal, so the agent will
report tells without editing when asked. Useful on text you did not write, or
when you want to see the diagnosis before committing to a rewrite.

## Deliberately not covered

- **Detector-score gaming.** The goal is prose that reads human, not prose that
  beats a specific classifier. Those tools have well-documented false-positive
  problems and optimizing against them would produce worse writing.
- **Voice or persona.** This agent is strictly professional and register-
  matching. Personality belongs in the caller's own instructions, not here —
  a subagent spawned into an arbitrary work repo should not be performing.

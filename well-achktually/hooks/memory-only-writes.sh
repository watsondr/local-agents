#!/usr/bin/env bash
# PreToolUse guard for well-achktually (wired in its agent.md frontmatter).
# memory: user adds Edit and Write to the agent's tools. This hook keeps them
# confined to the agent's memory directory, so the critic still cannot touch
# the code it reviews. Fails closed: anything it cannot resolve is blocked.
set -u

mem_dir="$(realpath -m -- "${CLAUDE_CONFIG_DIR:-$HOME/.claude}/agent-memory/well-achktually")"
path="$(jq -r '.tool_input.file_path // empty' 2>/dev/null)"

if [ -n "$path" ]; then
  target="$(realpath -m -- "$path" 2>/dev/null)"
  case "$target" in
    "$mem_dir"/*) exit 0 ;;
  esac
fi

echo "well-achktually is critique-only: Edit and Write may only touch $mem_dir (blocked: ${path:-<no path>})" >&2
exit 2

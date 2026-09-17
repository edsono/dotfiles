# Agent Instructions

## Package Manager
- Use system tooling only.
- Core commands:
```bash
stow -t ~ zsh tmux git bin nvim
stow -t ~ --no-folding claude
config-skills
stow -D -t ~ <package>
bash -n bin/bin/*
stylua nvim/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

## Commit Attribution
- AI commits MUST include a `Co-Authored-By` trailer naming the agent
  that actually authored the commit:
```text
Co-Authored-By: Codex (GPT-5) <codex@openai.com>
Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
```
- Use `commit-code` skill for commit workflow and message format. See `agents/.agents/skills/commit-code/SKILL.md`.
- Amend/fix commit messages only before push. After push, do not rewrite history.

## Key Conventions
- Repo structure: top-level directories are GNU Stow packages linked into `$HOME`, except `agents` (see below) and `system` (reconciled by scripts).
- Shared skills source of truth: `agents/.agents/skills`, one versioned path per skill and no mirror tree. The `agents` package is NOT stowed: `bin/bin/config-skills` publishes it to `~/.agents/skills` and links `~/.claude/skills` and `~/.codex/skills` to it, preserving local state.
- Claude Code global config source of truth: `claude/.claude` — `CLAUDE.md` (global agent guidelines) and `claude/.claude/agents/` (subagent definitions). Stow the package with `--no-folding`.
- Shell scripts: use `#!/usr/bin/env bash` when bash features are required and keep `set -e`.
- Quote variables and use explicit flags.
- Lua formatting: `nvim/.config/nvim/stylua.toml` (indent 2, width 120).
- Do not commit secrets, tokens, or private host data.

## Local Skills
- Use `agents-md` for updates to agent docs.
- Skill path: `agents/.agents/skills/agents-md/SKILL.md`

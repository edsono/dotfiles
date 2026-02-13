# Agent Instructions

## Package Manager
- Use system tooling only.
- Core commands:
```bash
stow -t ~ zsh tmux git bin nvim
stow -D -t ~ <package>
bash -n bin/bin/*
stylua nvim/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

## Commit Attribution
- AI commits MUST include:
```text
Co-Authored-By: Codex (GPT-5) <codex@openai.com>
```

## Key Conventions
- Repo structure: top-level directories are GNU Stow packages linked into `$HOME`.
- Shell scripts: use `#!/usr/bin/env bash` when bash features are required and keep `set -e`.
- Quote variables and use explicit flags.
- Lua formatting: `nvim/.config/nvim/stylua.toml` (indent 2, width 120).
- Do not commit secrets, tokens, or private host data.

## Local Skills
- Use `agents-md` for updates to agent docs.
- Skill path: `/Users/edsono/.codex/skills/agents-md/SKILL.md`

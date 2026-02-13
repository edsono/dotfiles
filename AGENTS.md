# Repository Guidelines

## Project Structure & Module Organization
- This repository is organized as **GNU Stow packages**. Each top-level directory maps to files linked into `$HOME`.
- `zsh/.zshrc`: interactive shell defaults, aliases, PATH, and tool setup.
- `tmux/.tmux.conf`: tmux keybindings, plugin bootstrap, and theme settings.
- `git/.gitconfig`, `git/.gitignore`: Git defaults.
- `bin/bin/`: utility scripts (environment bootstrap, installs, SSH helpers, DB/tool wrappers).
- `nvim/.config/nvim/`: LazyVim-based Neovim config (`init.lua`, `lua/config/*`, `lua/plugins/*`).

## Build, Test, and Development Commands
- `stow -t ~ zsh tmux git bin nvim`: link selected packages into your home directory.
- `stow -D -t ~ <package>`: remove symlinks for one package.
- `bash -n bin/bin/*.sh`: syntax-check shell scripts.
- `stylua nvim/.config/nvim`: format Neovim Lua config using repo settings.
- `nvim --headless "+Lazy! sync" +qa`: sync Neovim plugins non-interactively.
- `./bin/bin/install-chezmoi.sh`: bootstrap dotfiles via chezmoi on a fresh machine.

## Coding Style & Naming Conventions
- Shell scripts: `#!/usr/bin/env bash` + `set -e` for fail-fast behavior.
- Prefer POSIX-safe quoting and explicit command flags; avoid implicit globals where possible.
- Lua formatting uses `nvim/.config/nvim/stylua.toml` (spaces, width `2`, column width `120`).
- Script naming in `bin/bin/` uses action-oriented patterns such as `install-*.sh`, `start-*.sh`, `*-fix-*.sh`.

## Testing Guidelines
- No formal automated test suite exists for this repo.
- Minimum validation before PR:
  - Run `bash -n` for changed shell scripts.
  - Open `nvim` after Lua changes and verify startup/plugins load cleanly.
  - Reload tmux config with `tmux source-file ~/.tmux.conf` after tmux edits.

## Commit & Pull Request Guidelines
- Keep commits short, imperative, and scoped (e.g., `Add tmux TPM bootstrap fallback`).
- Prefer one logical change per commit.
- PRs should include:
  - What changed and why.
  - Affected package(s) (`zsh`, `tmux`, `nvim`, `bin`, `git`).
  - Manual verification steps and outcomes.
  - Screenshots/terminal snippets for UI-facing changes (prompt, tmux statusline, Neovim UI).

## Security & Configuration Tips
- Never commit secrets, private hosts, or tokens in shell configs/scripts.
- Keep machine-specific values overridable via environment variables when possible.

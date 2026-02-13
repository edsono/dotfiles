# dotfiles

Configurações pessoais de terminal/editor gerenciadas com **GNU Stow**.

## Estrutura do repositório
- `zsh/`: configuração do shell (`.zshrc`).
- `tmux/`: configuração do tmux (`.tmux.conf`).
- `git/`: configuração global e ignore (`.gitconfig`, `.gitignore`).
- `nvim/`: configuração do Neovim (LazyVim em `nvim/.config/nvim`).
- `bin/bin/`: scripts utilitários (bootstrap, instalação, SSH e helpers).

## Pré-requisitos
- `stow`
- `git`
- `zsh`, `tmux`, `nvim` (opcional, conforme os pacotes que quiser usar)

Exemplo no macOS (Homebrew):

```bash
brew install stow git neovim tmux
```

## Instalação
No diretório deste repositório:

```bash
stow -t ~ zsh tmux git bin nvim
```

Para instalar apenas um pacote:

```bash
stow -t ~ zsh
```

Para remover symlinks de um pacote:

```bash
stow -D -t ~ zsh
```

## Fluxo de atualização
1. Edite os arquivos neste repositório.
2. Reaplique o pacote com `stow -t ~ <pacote>` quando necessário.
3. Commit e push das mudanças.

## Validação rápida
- Shell scripts:

```bash
bash -n bin/bin/*.sh
```

- Config do Neovim:

```bash
stylua nvim/.config/nvim
nvim --headless "+Lazy! sync" +qa
```

## Bootstrap em máquina nova
Script disponível para instalar/aplicar via chezmoi:

```bash
./bin/bin/install-chezmoi.sh
```

## Contribuição
- Commits curtos, no imperativo e com escopo claro.
- Um assunto por commit.
- Em PR, descreva: o que mudou, por que mudou e como validou localmente.

# dotfiles

Gerenciamento de configurações pessoais com [GNU Stow](https://www.gnu.org/software/stow/).

## Pacotes

- `zsh`
- `tmux`
- `git`
- `bin`
- `nvim`
- `codex`
- `ghostty`

## Requisitos

- `stow` instalado no sistema
- `curl` e `unzip` (para auto-instalar JetBrainsMono Nerd Font)
- `zsh` (o script tenta instalar automaticamente via package manager, quando disponível)

## Instalação

Aplicar todos os pacotes no `$HOME`:

```bash
./install.sh
```

Por padrão, o script também garante a instalação da JetBrainsMono Nerd Font
(macOS e Linux) caso ela não exista, e também tenta instalar `zsh` quando não
estiver disponível no sistema.
Em Linux, também roda `bin/bin/config-modern-unix` (best effort), incluindo
instalação de `git` e `lazygit`.

Quando executado sem `--adopt`, o script detecta conflitos do Stow e move os
arquivos existentes para `~/.dotfiles-backups/<timestamp>/` antes de instalar.

Simular sem alterar nada:

```bash
./install.sh --dry-run
```

Adotar arquivos já existentes (quando necessário):

```bash
./install.sh --adopt
```

Remover links criados pelo Stow:

```bash
./install.sh --delete
```

Pular instalação/verificação de fonte:

```bash
./install.sh --skip-font-install
```

Pular instalação/verificação de `zsh`:

```bash
./install.sh --skip-zsh-install
```

Pular bootstrap `modern-unix` (git/lazygit e ferramentas relacionadas):

```bash
./install.sh --skip-modern-unix-install
```

Definir `zsh` como shell padrão de login:

```bash
./install.sh --set-default-shell
```

## Uso manual do stow

```bash
stow -t ~ zsh tmux git bin nvim codex ghostty
```

Remover um pacote específico:

```bash
stow -D -t ~ <pacote>
```

## Overrides locais (não versionados)

Para configurações específicas de máquina/sistema, use arquivos locais:

- Zsh: `~/.zshrc-local` (carregado no final de `~/.zshrc`)
- Ghostty Linux: `~/.config/ghostty/config.local`
- Ghostty macOS: `~/Library/Application Support/com.mitchellh.ghostty/config.local`

Exemplos de override para Ghostty:

- `ghostty/.config/ghostty/config.local.example`
- `ghostty/Library/Application Support/com.mitchellh.ghostty/config.local.example`

## Observação sobre Codex `.system`

O diretório `codex/.codex/skills/.system` permanece versionado no repositório,
mas a instalação via `install.sh` ignora esse caminho no `stow` para preservar
o conteúdo local existente em `~/.codex/skills/.system`.

## Skills do Codex

- Fonte de verdade: `codex/.codex/skills` neste repositório.
- `install.sh` sincroniza essas skills para `~/.codex/skills` e valida o resultado.
- `bin/bin/ssh-push` também sincroniza as skills para hosts remotos, inclusive no fallback sem `rsync`.
- O caminho `~/.codex/skills/.system` local é preservado por padrão.

Verificação local:

```bash
find -L ~/.codex/skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l
```

Verificação remota:

```bash
ssh <host> 'find -L ~/.codex/skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l'
```

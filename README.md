# dotfiles

Gerenciamento de configurações pessoais com
[GNU Stow](https://www.gnu.org/software/stow/).

## Pacotes

- `zsh`
- `tmux`
- `git`
- `bin`
- `vim`
- `nvim`
- `codex`
- `ghostty`
- `lazygit`
- `claude`
- `bat`

## Requisitos

- `stow` instalado no sistema
- `curl` e `unzip` (para auto-instalar JetBrainsMono Nerd Font)
- `zsh` (o script tenta instalar automaticamente via gerenciador de pacotes,
  quando disponível)

## Instalação

Em uma máquina nova, sem nada clonado ainda (instala `git`/`stow` se
faltarem, clona em `~/Code/dotfiles` e roda `./install.sh`):

```bash
curl -fsSL \
  https://raw.githubusercontent.com/edsono/dotfiles/main/bootstrap.sh | bash
```

Com o repositório já clonado, aplicar todos os pacotes no `$HOME`:

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
stow -t ~ zsh tmux git bin vim nvim codex ghostty lazygit claude bat
```

## VPS com `ssh-vps`

Para preparar uma VPS AlmaLinux/RHEL-like usando apenas `dnf`, criar um clone
Git HTTPS em `~/.dotfiles` e aplicar um subset seguro dos dotfiles:

```bash
bin/bin/ssh-vps usuario@host
```

O script:

- instala via `dnf`: `stow`, `git`, `tmux`, `ripgrep`, `fd-find`, `jq`,
  `fzf`, `htop`, `zsh`, `vim-enhanced`, `starship`, `zoxide`, `duf`,
  `procs`, `ncdu`, `bat`, `git-delta`, `dnf-automatic` e `dnf-utils`

- se `starship` não existir nos repositórios atuais, habilita via `dnf` o
  COPR `atim/starship`

- clona `https://github.com/edsono/dotfiles.git` em `~/.dotfiles`

- atualiza clones existentes com `git pull --ff-only`

- preserva cópias antigas sem Git em `~/.dotfiles-backups`

- aplica apenas `zsh`, `git`, `tmux`, `bin`, `vim` e `bat`

- aborta se encontrar conflitos de `stow`

- aborta se o clone remoto tiver alterações locais

- define `zsh` como shell padrão do usuário remoto

- força `EDITOR=vim` e `VISUAL=vim` via `~/.zshrc-local`

- deixa o prompt com `starship` através do `.zshrc` sincronizado

- instala o banner SSH padronizado e seus timers

Simular sem alterar nada:

```bash
bin/bin/ssh-vps --dry-run usuario@host
```

Usar uma chave pública específica:

```bash
bin/bin/ssh-vps --key ~/.ssh/id_ed25519.pub usuario@host
```

Trocar os grupos sincronizados:

```bash
bin/bin/ssh-vps --packages zsh,git,tmux,bin,vim,bat usuario@host
```

## Deploy em vários hosts

Cadastre os aliases SSH localmente, sem versionar dados de infraestrutura:

```bash
mkdir -p ~/.config/dotfiles
printf '%s\n' host-a host-b > ~/.config/dotfiles/deploy-hosts
```

O deploy exige `main` limpa e idêntica a `origin/main`. Ele atualiza todos os
hosts, reaplica o Stow e retorna erro ao final se algum destino falhar:

```bash
dotfiles-deploy
dotfiles-deploy --dry-run
dotfiles-deploy host-a host-b
```

Para a primeira instalação ou para migrar uma cópia antiga sem Git, use
`ssh-vps`. O comando legado `ssh-push` é apenas um wrapper depreciado.

## Banner SSH

O banner separa as informações em duas partes:

- `/etc/motd` mantém a lista completa da última transação aplicada pelo
  `dnf-automatic`

- um bloco compacto mostra host, sistema, atividade, recursos, rede,
  atualizações pendentes, reinício necessário e serviços falhos

O bloco compacto aparece apenas em sessões SSH interativas. A consulta ao DNF
fica em cache e é atualizada diariamente por um timer persistente, por volta
das 07:30.

Instalar ou reconciliar a configuração manualmente:

```bash
config-ssh-banner
config-ssh-banner --dry-run
```

Remover um pacote específico:

```bash
stow -D -t ~ <pacote>
```

## Overrides locais (não versionados)

Para configurações específicas de máquina/sistema, use arquivos locais:

- Zsh: `~/.zshrc-local` (carregado no final de `~/.zshrc`)
- Vim: `~/.vimrc-local` (carregado no final de `~/.vimrc`)
- Ghostty Linux: `~/.config/ghostty/config.local`
- Ghostty macOS:
  `~/Library/Application Support/com.mitchellh.ghostty/config.local`

Exemplos de override para Ghostty:

- `ghostty/.config/ghostty/config.local.example`
- `ghostty/Library/Application
  Support/com.mitchellh.ghostty/config.local.example`

## Observação sobre Codex `.system`

O diretório `codex/.codex/skills/.system` permanece versionado no repositório,
mas a instalação via `install.sh` ignora esse caminho no `stow` para preservar
o conteúdo local existente em `~/.codex/skills/.system`.

## Skills do Codex

- Fonte de verdade: `codex/.codex/skills` neste repositório.
- `install.sh` sincroniza essas skills para `~/.codex/skills` e valida o
  resultado.

- Hosts com o clone Git recebem as skills publicadas junto com o restante do
  repositório.
- O caminho `~/.codex/skills/.system` local é preservado por padrão.

Verificação local:

```bash
find -L ~/.codex/skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l
```

Verificação remota:

```bash
ssh <host> \
  'find -L ~/.codex/skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l'
```

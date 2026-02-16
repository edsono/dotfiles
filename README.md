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

## Instalação

Aplicar todos os pacotes no `$HOME`:

```bash
./install.sh
```

Por padrão, o script também garante a instalação da JetBrainsMono Nerd Font
(macOS e Linux) caso ela não exista.

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

## Uso manual do stow

```bash
stow -t ~ zsh tmux git bin nvim codex ghostty
```

Remover um pacote específico:

```bash
stow -D -t ~ <pacote>
```

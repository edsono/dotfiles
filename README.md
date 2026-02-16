# dotfiles

Gerenciamento de configurações pessoais com [GNU Stow](https://www.gnu.org/software/stow/).

## Pacotes

- `zsh`
- `tmux`
- `git`
- `bin`
- `nvim`
- `codex`

## Requisitos

- `stow` instalado no sistema

## Instalação

Aplicar todos os pacotes no `$HOME`:

```bash
./install.sh
```

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

## Uso manual do stow

```bash
stow -t ~ zsh tmux git bin nvim codex
```

Remover um pacote específico:

```bash
stow -D -t ~ <pacote>
```

# Scripts e arquivos de configuração

## Scripts em `bin/bin`
| Script | Uso principal | Descrição |
|---|---|---|
| `fs-find-rm` | `fs-find-rm [FILE] [FILE]...` | Remove arquivos recursivamente a partir do diretório atual. |
| `fs-targz-dirs` | `fs-targz-dirs [-q] DIR [DIR]...` | Gera `.tar.gz` de diretórios e remove os diretórios originais. |
| `linux-sssd-db-reset` | `linux-sssd-db-reset` | Reinicia e limpa DB do SSSD em Linux RH-like. |
| `oracle-start` | `oracle-start` | Inicia o serviço Oracle XE 21c via init script. |
| `oracle-xepdb-login` | `oracle-xepdb-login` | Abre `sqlplus` como `sysdba` em `xepdb1`. |
| `proc-kill-by-pidfile` | `proc-kill-by-pidfile [-SIGNAL] <pidfile...>` | Mata processos lendo PIDs de arquivos `.pid`. |
| `select-java` | `select-java` | Seleciona versão do Java em Linux RH-like, Debian-like e Arch-like. |
| `selectNode` | `selectNode` | Seleciona versão do Node.js em Linux RH-like, Debian-like e Arch-like. |
| `selectPython` | `selectPython` | Seleciona versão do Python em Linux RH-like, Debian-like e Arch-like. |
| `runtime-node-select` | `runtime-node-select` | Wrapper de compatibilidade para `selectNode`. |
| `ssh-fix-perms` | `ssh-fix-perms` | Ajusta permissões em `~/.ssh` e conteúdos. |
| `ssh-push-config` | `ssh-push-config <ssh-host>` | Prepara host remoto: envia chave e scripts base de SSH. |
| `ssh-push-key` | `ssh-push-key <host> [host...]` | Publica chave SSH local em hosts remotos. |
| `user-add` | `user-add [--admin\|--app] <username>` | Cria usuário Linux como comum, admin ou app/service. |
| `user-del` | `user-del <username>` | Remove usuário em Linux/macOS (com tratamento por SO). |

## Arquivos de configuração deste repositório

### Shell (`zsh`)
- `zsh/.zshrc`

### Tmux (`tmux`)
- `tmux/.tmux.conf`

### Git (`git`)
- `git/.gitconfig`
- `git/.gitignore`

### Neovim (`nvim/.config/nvim`)
- `nvim/.config/nvim/init.lua`
- `nvim/.config/nvim/lazyvim.json`
- `nvim/.config/nvim/lazy-lock.json`
- `nvim/.config/nvim/stylua.toml`
- `nvim/.config/nvim/.neoconf.json`
- `nvim/.config/nvim/lua/config/autocmds.lua`
- `nvim/.config/nvim/lua/config/keymaps.lua`
- `nvim/.config/nvim/lua/config/lazy.lua`
- `nvim/.config/nvim/lua/config/options.lua`
- `nvim/.config/nvim/lua/plugins/catppuccin.lua`
- `nvim/.config/nvim/lua/plugins/example.lua`
- `nvim/.config/nvim/lua/plugins/nvim-cmp.lua`
- `nvim/.config/nvim/lua/plugins/nvim-lspconfig.lua`
- `nvim/.config/nvim/lua/plugins/test.lua`
- `nvim/.config/nvim/spell/en.utf-8.add`
- `nvim/.config/nvim/spell/en.utf-8.add.spl`
- `nvim/.config/nvim/spell/pt.utf-8.add`
- `nvim/.config/nvim/spell/pt.utf-8.add.spl`
- `nvim/.config/nvim/spell/pt.utf-8.spl`
- `nvim/.config/nvim/.gitignore`
- `nvim/.config/nvim/README.md`
- `nvim/.config/nvim/LICENSE`

### Utilitários (`bin`)
- `bin/RENAMES.md`
- `bin/bin/*`

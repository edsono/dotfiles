### LC
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_LANG en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

### Editor
set -gx EDITOR vim

### Home/bin
set --global fish_user_paths $fish_user_paths ~/.local/bin

### PyEnv
set -gx PYENV_ROOT ~/.pyenv
set --global fish_user_paths $fish_user_paths ~/.pyenv/bin
set --global fish_user_paths $fish_user_paths ~/.pyenv/shims
pyenv init -| source

### Fisher
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

### Oracle
#set --global fish_user_paths $fish_user_paths /opt/oracle/instantclient_12_2

### Postgres.app
#set --global fish_user_paths $fish_user_paths /Applications/Postgres.app/Contents/Versions/latest/bin

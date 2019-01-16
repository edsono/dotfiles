### LC
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx LC_LANG en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8

### Editor
set -gx EDITOR vim

### Home/bin
set --global fish_user_paths $fish_user_paths ~/bin
set --global fish_user_paths $fish_user_paths ~/.local/bin

### Oracle
set --global fish_user_paths $fish_user_paths /opt/oracle/instantclient_12_2

### Postgres.app
set --global fish_user_paths $fish_user_paths /Applications/Postgres.app/Contents/Versions/latest/bin

### PyEnv
set -gx PYENV_ROOT ~/.pyenv
set --global fish_user_paths $fish_user_paths ~/.pyenv/shims
. (pyenv init -|psub)

### Fisher
if not functions -q fisher
    echo "Installing fisher for the first time..." >&2
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fisher
end

# added by pipsi (https://github.com/mitsuhiko/pipsi)
set -x PATH /Users/edsono/.local/bin $PATH


# Enable VI mode
# set -o vi

# Fix for backspace in vi mode
# bindkey -v '^?' backward-delete-char
# bindkey -M viins '\e.' insert-last-word

# Habilita a busca no histórico com as setas para cima/para baixo
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^[[A' up-line-or-beginning-search # Seta para cima
bindkey '^[[B' down-line-or-beginning-search # Seta para baixo

# History configuration
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
HISTFILE="$HOME/.zsh_history"
HISTORY_IGNORE="(ls|cd|pwd|exit)*"

# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# https://zsh.sourceforge.io/Doc/Release/Options.html (16.2.4 History)
setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY         # Share history between all sessions.
setopt HIST_IGNORE_DUPS      # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS  # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE     # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS     # Do not write a duplicate event to the history file.
setopt HIST_VERIFY           # Do not execute immediately upon history expansion.
setopt APPEND_HISTORY        # append to history file (Default)
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.

setopt autocd                    # allows you to change directories without typing cd
autoload -U compinit; compinit   # initializes the Zsh completion system

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Configure timezone
export TZ=America/Manaus

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ---- Python ----
# Set breakpoint() in Python to call pudb
export PYTHONBREAKPOINT="pudb.set_trace"

# Oracle client
export PATH=$HOME/oracle:$PATH
export DYLD_LIBRARY_PATH=$HOME/oracle:$DYLD_LIBRARY_PATH

# MySQL
export PATH=$PATH:/usr/local/mysql/bin
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ls='ls --color'
alias g="git"
alias gg="lazygit"
alias zrc="nvim ~/.zshrc"
alias stow='stow -t ~'
alias cx='codex-profiles'

# ---- HomeBrew ----
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_AUTO_UPDATE=1
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
      if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      fi
      ;;
    Darwin*)
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
      ;;
    *)
      ;;
esac

# ---- FZF -----
# Set up fzf key bindings and fuzzy completion
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  if command -v fd >/dev/null 2>&1; then
    fd --hidden --exclude .git . "$1"
  else
    find "$1" -mindepth 1 -not -path '*/.git/*'
  fi
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  if command -v fd >/dev/null 2>&1; then
    fd --type=d --hidden --exclude .git . "$1"
  else
    find "$1" -mindepth 1 -type d -not -path '*/.git/*'
  fi
}

if command -v lsd >/dev/null 2>&1; then
  dir_preview='lsd --tree --color=always {} | head -200'
else
  dir_preview='ls -la {} | head -200'
fi
if command -v bat >/dev/null 2>&1; then
  file_preview='bat -n --color=always --line-range :500 {}'
else
  file_preview='sed -n "1,200p" {}'
fi
show_file_or_dir_preview="if [ -d {} ]; then ${dir_preview}; else ${file_preview}; fi"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'lsd --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# --- Bat ---
export BAT_THEME="Catppuccin Mocha"

# ---- Zoxide (better cd) ----
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Java
set_java_home() {
  local java_bin=""
  local java_home_candidate=""

  if command -v select-java >/dev/null 2>&1; then
    java_bin="$(select-java --current 2>/dev/null || true)"
    if [[ -n "$java_bin" && -x "$java_bin" ]]; then
      java_home_candidate="$(cd "$(dirname "$java_bin")/.." && pwd -P 2>/dev/null || true)"
    fi
  fi

  if [[ -z "$java_home_candidate" && "$(uname -s)" = "Darwin" && -x /usr/libexec/java_home ]]; then
    java_home_candidate="$(/usr/libexec/java_home 2>/dev/null || true)"
  fi

  if [[ -n "$java_home_candidate" && -d "$java_home_candidate" ]]; then
    export JAVA_HOME="$java_home_candidate"
    export PATH="$JAVA_HOME/bin:$PATH"
  fi
}
set_java_home
unset -f set_java_home

# Starship
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
else
  autoload -U colors && colors
  PROMPT='%F{cyan}%n@%m%f %F{blue}%~%f %F{green}%#%f '
fi

if command -v lsd >/dev/null 2>&1; then
  alias l="lsd"
  alias ll="lsd -lh"
  alias la="lsd -lha"
else
  alias l="ls"
  alias ll="ls -lh"
  alias la="ls -lha"
fi

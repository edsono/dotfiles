#!/bin/zsh

# ----------------------------------------------------------------------
# ZSH ENVIRONMENT
# ----------------------------------------------------------------------

# load non-interactive environment too
[ -r ~/.zshenv ] && . ~/.zshenv

# load shared configuration for interactive shell
[ -r ~/.shrc ] && . ~/.shrc

# ----------------------------------------------------------------------
#  ZSH OPTIONS
# ----------------------------------------------------------------------

autoload -U zmv
autoload -U colors && colors
autoload -U compinit && compinit
autoload -U select-word-style && select-word-style bash

setopt zle               # Use magic (this is default, but it can't hurt!)
setopt no_hup            # Dont automatically kill all my process on logout
setopt auto_cd           # Why would you type 'cd dir' if you could just type 'dir'?
setopt correct           # Spell check commands!  (Sometimes annoying)
setopt no_clobber        # If you really do want to clobber a file, you can use the >! operator
setopt rm_star_wait      # 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt no_flow_control   # If I could disable Ctrl-s completely I would!
setopt prompt_subst      # Allow use of variables in prompt
setopt auto_pushd        # This makes cd=pushd
setopt pushd_to_home     # Have pushd without argumens act like pushd $HOME
setopt auto_name_dirs    # This will use named dirs when possible
setopt numeric_glob_sort # Be Reasonable!

# setopt PUSHD_SILENT # No more annoying pushd messages...

# History Stuff

# Where it gets saved
HISTFILE=~/.history

# Remember about a years worth of history (AWESOME)
SAVEHIST=10000
HISTSIZE=10000

# If a line starts with a space, don't save it.
setopt hist_ignore_space
setopt hist_no_store

# Forget about duplicates
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_expire_dups_first

setopt append_history       # Don't overwrite, append!
setopt inc_append_history   # Write after each command
setopt share_history        # Killer: share history between multiple shells
setopt hist_ignore_dups     # If I type cd and then cd again, only save the last one
setopt hist_ignore_all_dups # Even if there are commands inbetween commands that are the same, still only save the last one
setopt hist_reduce_blanks   # Pretty    Obvious.  Right?
setopt hist_verify          # When using a hist thing, make a newline show the change before executing it.
setopt extended_history     # Save the time and how long a command ran

# ----------------------------------------------------------------------
#  ZLE OPTIONS
# ----------------------------------------------------------------------

# Emacs style and Meta act like ESC
bindkey -e

# Convert inputrc to zle
eval "$(grep '^\"' ~/.inputrc | sed -n 's/^/bindkey /; s/: / /p')" > /dev/null

# zsh is different from readline for this command
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "\e[B" history-beginning-search-forward-end
bindkey "\e[A" history-beginning-search-backward-end
bindkey "\eOA" history-beginning-search-forward-end
bindkey "\eOB" history-beginning-search-backward-end


# Complete in the middle of some text ignoring the suffix
bindkey "^i" expand-or-complete-prefix

# it's like, space AND completion for history expansion using !
bindkey " " magic-space

autoload -U edit-command-line
zle -N edit-command-line
bindkey "\ee" edit-command-line

function fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    bg
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^z' fancy-ctrl-z

function show-dir-stack () {
  echo
  dirs -v
  zle redisplay
}
zle -N show-dir-stack
bindkey "\ed" show-dir-stack

# ----------------------------------------------------------------------
#  ZSH COMPLETION
# ----------------------------------------------------------------------

# Faster! (?)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _force_rehash _complete _approximate _ignored

_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1  # Because we didn't really complete anything
}

# generate descriptions with magic.
zstyle ':completion:*' auto-description 'specify: %d'

# Don't prompt for a huge list, page it!
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Don't prompt for a huge list, menu it!
zstyle ':completion:*:default' menu 'select=0'

# Have the newer files last so I see them first
zstyle ':completion:*' file-sort modification reverse

# color code completion!!!!  Wohoo!
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31"

setopt complete_in_word
unsetopt list_ambiguous

# Separate man page sections.  Neat.
zstyle ':completion:*:manuals' separate-sections true

# complete with a menu for xwindow ids
zstyle ':completion:*:windows' menu on=0
zstyle ':completion:*:expand:*' tag-order all-expansions

# more errors allowed for large words and fewer for small words
zstyle ':completion:*:approximate:*' max-errors 'reply=(  $((  ($#PREFIX+$#SUFFIX)/3  ))  )'

# Errors format
zstyle ':completion:*:corrections' format '%B%d (errors %e)%b'

# Don't complete stuff already on the line
zstyle ':completion::*:(rm|vi):*' ignore-line true

# Don't complete directory we are already in (../here)
zstyle ':completion:*' ignore-parents parent pwd

zstyle ':completion::approximate*:*' prefix-needed false

# -------------------------------------------------------------------
# ZSH ALIASES
# -------------------------------------------------------------------

alias zmv='noglob zmv'
alias zcp='noglob zmv -C'
alias zln='noglob zmv -L'

# Global aliases

alias -g G='|grep '
alias -g L='|less '
alias -g DN='>/dev/null'

# -------------------------------------------------------------------
# ZSH FUNCTIONS
# -------------------------------------------------------------------

# popd
function - {
  [[ $# -eq 0 ]] && popd || builtin - "$@"
}

# set proxy
function @ {
  if [[ $# -eq 0 ]]; then
    unset all_proxy
    unset ALL_PROXY
    unset ftp_proxy
    unset FTP_PROXY
    unset http_proxy
    unset HTTP_PROXY
  else
    export all_proxy=$1
    export ALL_PROXY=$1
    export ftp_proxy=$1
    export FTP_PROXY=$1
    export http_proxy=$1
    export HTTP_PROXY=$1
  fi
}


# Colorize STDERR (enable if needed, might cause issues with password prompts or escape sequences)
# #exec 2>>(while read line; do; print '\e[91m'${(q)line}'\e[0m' > /dev/tty; print -n $'\0'; done)


# -------------------------------------------------------------------
# PROMPT CONFIGURATION
# -------------------------------------------------------------------
#   Context: :prompt:edsono
#   Current Format: USER@HOST [dynamic section] { CURRENT DIRECTORY }$
#   USER:      (also sets the base color for the prompt)
#     Red       == Root(UID 0)
#     Yellow    == SU to user other than root(UID 0)
#     Green     == Normal user
#   @:
#     White     == http_proxy or all_proxy environmental variable undefined.
#     Yellow    == http_proxy or all_proxy environmental variable configured.
#   HOST:
#     Green     == Local session
#     Cyan      == Secure remote connection (i.e. SSH)
#     Yellow    == Unknown remote connection (i.e. RSH, Telnet...)
#   CURRENT DIRECTORY:
#     Red       == Current user does not have write priviledges
#     Green     == Current user does have write priviledges

prompt_edsono_setup () {
  setopt noxtrace localoptions

  precmd  () {
    # user
    if [ $UID -eq 0 ]; then
      pc_user='red'
    elif [ "$USER" = "$LOGNAME" ]; then
      pc_user='green'
    else
      pc_user='yellow'
    fi

    # http proxy var configured or not
    if [ -n "$http_proxy" -o -n "$HTTP_PROXY" -o \
         -n "$all_proxy"  -o -n "$ALL_PROXY" ]; then
      pc_proxy="yellow"
    else
      pc_proxy="white"
    fi

    # host
    if [ -n "$SSH_CLIENT" -o -n "$SSH_TTY" ]; then
      pc_host='cyan'
    elif [ -z "$DISPLAY" ]; then
      pc_host='yellow'
    else
      pc_host='green'
    fi

    # working directory
    if [ -w "$PWD" ]; then
      pc_dir='cyan'
    else
      pc_dir='red'
    fi

    PS1="%{$fg[$pc_user]%}%n%{$reset_color%}"
    PS1="$PS1%{$fg[$pc_proxy]%}@%{$reset_color%}"
    PS1="$PS1%{$fg[$pc_host]%}%m%{$reset_color%}:"
    PS1="$PS1%{$fg[$pc_dir]%}%~%{$reset_color%}"
    PS1="$PS1%{$fg[yellow]%}$(vcprompt -f '[%n:%b%m%u]')%{$reset_color%}"
    PS1="$PS1 %(?.%#.%{$fg[red]%}%?!)%{$reset_color%} "
  }

  preexec () {
    # Test for day change.
    if [ -z $DAY ]; then
      export DAY=$(date +%A)
    else
      local today=$(date +%A)
      if [ "${DAY}" != "${today}" ]; then
        echo "\n$fg[yellow]Day changed to $(date '+%A, %d %B %Y').$reset_color\n"
        export DAY=$today
      fi
    fi
  }

  PS4='+%N:%i:%_>'
}

prompt_edsono_setup

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

uname -a && uptime

#!/bin/zsh

# ----------------------------------------------------------------------
# SANE CONFIGURATION
# ----------------------------------------------------------------------

stty -ixon -ixoff     # disable flow control
unset MAILCHECK       # forget about mail check

# ----------------------------------------------------------------------
# INTERACTIVE CONFIGURATION
# ----------------------------------------------------------------------

# setup some basic variables
: ${CDPATH:=.:$HOME/PhD:$HOME/Code:$HOME/Projects}
export CDPATH

: ${INPUTRC:=~/.inputrc}
export INPUTRC

# ls colors
LSCOLORS="ExDxCxDxBxEGEDABAGACAD"
export LSCOLORS

# See what we have to work with ...
[ -n "$(command -v vim)" ] && EDITOR=vim || EDITOR=vi
export EDITOR

# hg
[ -n "$(command -v hg)" ] && export HGEDITOR=$EDITOR

# git
[ -n "$(command -v git)" ] && export GIT_EDITOR=$EDITOR

# pager
[ -n "$(command -v less)" ] && PAGER="less -FiRSX" || PAGER=more
MANPAGER="$PAGER"
export PAGER MANPAGER

# browser
[ -n "$DISPLAY" ] && BROWSER=chrome || BROWSER=links
export BROWSER

# Less Colors for Man Pages
export LESS_TERMCAP_md=$'\E[01;38;5;166m'          # begin bold
export LESS_TERMCAP_mb=$'\E[01;38;5;136m'          # begin blinking
export LESS_TERMCAP_us=$'\E[04;38;5;136m'          # begin underline
export LESS_TERMCAP_so=$'\E[01;38;5;233;48;5;166m' # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m'                    # end standout-mode
export LESS_TERMCAP_ue=$'\E[0m'                    # end underline
export LESS_TERMCAP_me=$'\E[0m'                    # end mode

alias ..='cd ..'
alias ...='cd ../..'

# hg
[ -n "$(command -v hg)" ] && alias h='hg'

# git
[ -n "$(command -v git)" ] && alias g='git'

# disk usage with human sizes and minimal depth
[ "$(uname)" = "Darwin" ] && DU_DEPTH="-d 1" || DU_DEPTH="--max-depth=1"
alias du1="command du -h $DU_DEPTH"

# django
alias dm='./manage.py'
alias dt='DJANGO_SETTINGS_MODULE=core.settings.test ./manage.py test'

# find extension
fx() { find . -name '*.'$* }

# find with name
fn() { find . -name "*$**" }

# find files with word
fw() { find . -name "*.$1" -exec grep -i -H "$2" {} \; }

# we always pass these to ls(1)
[ "$(uname)" = "Darwin" ] && LS_COMMON="-hBG" || LS_COMMON="-hB --color=auto"

# setup the main ls alias if we've established common args
alias ls="command ls $LS_COMMON"

# these use the ls aliases above
alias l="ls -la"
alias ll="ls -l"
alias l.="ls -d .*"

# ----------------------------------------------------------------------
#  ZSH OPTIONS
# ----------------------------------------------------------------------

unalias run-help &>/dev/null
autoload run-help
HELPDIR=/usr/local/share/zsh/helpfiles

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

# zsh key bindings
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# if mac...
if [[ $(uname) -eq "Darwin" ]]; then
  typeset -A key
  key[Home]=${terminfo[khome]}
  key[End]=${terminfo[kend]}
  key[Insert]=${terminfo[kich1]}
  key[Delete]=${terminfo[kdch1]}
  key[Up]=${terminfo[kcuu1]}
  key[Down]=${terminfo[kcud1]}
  key[Left]=${terminfo[kcub1]}
  key[Right]=${terminfo[kcuf1]}
  key[PageUp]=${terminfo[kpp]}
  key[PageDown]=${terminfo[knp]}

  # Finally, make sure the terminal is in application mode, when zle is
  # active. Only then are the values from $terminfo valid.
  function zle-line-init () {
      echoti smkx
  }
  function zle-line-finish () {
      echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Ensure that arrow keys work as they should
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

# Search through history
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      history-beginning-search-backward-end
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    history-beginning-search-forward-end

# pageup/pagedown for old history navigation
[[ -n "${key[PageUp]}"   ]] && bindkey  "${key[PageUp]}"    up-line-or-history
[[ -n "${key[PageDown]}" ]] && bindkey  "${key[PageDown]}"  down-line-or-history

# ctrl+<- -> iTerm2
bindkey "\e[1;5C" forward-word
bindkey "\e[1;5D" backward-word

# Who doesn't want home and end to work?
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line

# insert/delete
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char

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

# map Esc-I to complete files even when default completer dont want
zle -C complete-files complete-word _generic
zstyle ':completion:complete-files:*' completer _files
bindkey '^[i' complete-files

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
    unset https_proxy
    unset HTTPS_PROXY
  else
    export all_proxy=$1
    export ALL_PROXY=$1
    export ftp_proxy=$1
    export FTP_PROXY=$1
    export http_proxy=$1
    export HTTP_PROXY=$1
    export https_proxy=$1
    export HTTPS_PROXY=$1
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

VCPROMPT="vcprompt_$(uname)_$(uname -m)"

prompt_edsono_setup () {
  setopt noxtrace localoptions

  ps1_context () {
    # For any of these bits of context that exist, display them and append
    # a space.
    virtualenv=`basename "$VIRTUAL_ENV"`
    for v in "$debian_chroot" "$virtualenv" "$PS1_CONTEXT"; do
        echo -n "${v:+$v }"
    done
  }

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
    else
      pc_host='green'
    fi

    # working directory
    if [ -w "$PWD" ]; then
      pc_dir='cyan'
    else
      pc_dir='red'
    fi

    PS1="%{$fg_bold[yellow]%}$(ps1_context)"
    PS1="$PS1%{$fg_bold[$pc_user]%}%n%{$reset_color%}"
    PS1="$PS1%{$fg_bold[$pc_proxy]%}@%{$reset_color%}"
    PS1="$PS1%{$fg_bold[$pc_host]%}%m%{$reset_color%}:"
    PS1="$PS1%{$fg_bold[$pc_dir]%}%~%{$reset_color%}"
    PS1="$PS1%{$fg_bold[yellow]%}$($VCPROMPT -f '(%n:%b%m%u)')%{$reset_color%}"
    PS1="$PS1 %(?.%#.%{$fg_bold[red]%}%?!)%{$reset_color%} "
  }

  preexec () {
    # Test for day change.
    if [ -z $DAY ]; then
      export DAY=$(date +%A)
    else
      local today=$(date +%A)
      if [ "${DAY}" != "${today}" ]; then
        echo "\n$fg_bold[yellow]Day changed to $(date '+%A, %d %B %Y').$reset_color\n"
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

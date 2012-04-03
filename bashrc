#!/bin/bash

# -------------------------------------------------------------------
# BASH ENVIRONMENT
# -------------------------------------------------------------------

# load non-interactive environment too
[ -r ~/.shenv ] && . ~/.shenv

# if shell is non-interactive. Be done now!
[[ $- == "*i*" ]] && return

# load shared configuration for interactive shell
[ -r ~/.shrc ] && . ~/.shrc

# complete hostnames from
: ${HOSTFILE=~/.ssh/known_hosts}
export HOSTFILE

# history
export HISTCONTROL=ignoreboth

# ----------------------------------------------------------------------
#  BASH OPTIONS
# ----------------------------------------------------------------------

# notify of bg job completion immediately
set -o notify

# shell opts. see bash(1) for details
shopt -u mailwarn                >/dev/null 2>&1
shopt -s cdspell                 >/dev/null 2>&1
shopt -s extglob                 >/dev/null 2>&1
shopt -s ignoreeof               >/dev/null 2>&1
shopt -s histappend              >/dev/null 2>&1
shopt -s hostcomplete            >/dev/null 2>&1
shopt -s interactive_comments    >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1

# ----------------------------------------------------------------------
# BASH COMPLETION
# ----------------------------------------------------------------------

if [ -z "$BASH_COMPLETION" ]; then
    bash=${BASH_VERSION%.*}; bmajor=${bash%.*}; bminor=${bash#*.}
    if [ "$PS1" ] && [ $bmajor -gt 1 ] ; then
        # search for a bash_completion file to source
        for f in /usr/pkg/etc/back_completion \
            /usr/local/etc/bash_completion \
            /opt/local/etc/bash_completion \
            /etc/bash_completion \
            ~/.bash_completion ;
        do
            if [ -f $f ]; then
                . $f
                break
            fi
        done
    fi
    unset bash bmajor bminor
fi

# override and disable tilde expansion
_expand() {
    return 0
}

# git completion
[ -n "$HAVE_GIT" ] && complete -o default -o nospace -F _git g

# skel completion
_skel() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  if (( COMP_CWORD == 1 )); then
    local templates=$(for f in `ls -1 $HOME/.skel`; do echo ${f}; done)
    COMPREPLY=( $(compgen -W "${templates}" -- ${cur}) )
  else
    # user must choose a target dirname
    COMPREPLY=()
  fi
}
[ -n "$(command -v skel)" ] && complete -F _skel skel


# -------------------------------------------------------------------
# BASH FUNCTIONS
# -------------------------------------------------------------------

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

# Configure Colors:
white='\033[1;37m'
lightgray='\033[0;37m'
gray='\033[1;30m'
black='\033[0;30m'
red='\033[0;31m'
lightred='\033[1;31m'
green='\033[0;32m'
lightgreen='\033[1;32m'
brown='\033[0;33m'
yellow='\033[1;33m'
blue='\033[0;34m'
lightblue='\033[1;34m'
purple='\033[0;35m'
pink='\033[1;35m'
cyan='\033[0;36m'
lightcyan='\033[1;36m'
default='\033[0m'

VCPROMPT="vcprompt_$(uname)"

# Function to set prompt_command to.
function promptcmd () {
  last="$?"
  history -a

  # user
  if [ $UID -eq 0 ]; then
    pc_user="$red"
  elif [ "$user" = "$logname" ]; then
    pc_user="$green"
  else
    pc_user="$yellow"
  fi

  # http proxy var configured or not
  if [ -n "$http_proxy" -o -n "$HTTP_PROXY" -o \
    -n "$all_proxy"  -o -n "$ALL_PROXY" ]; then
  pc_proxy="$yellow"
  else
    pc_proxy="$white"
  fi

  # host
  if [ -n "$SSH_CLIENT" -o -n "$SSH_TTY" ]; then
    pc_host="$cyan"
  elif [ -z "$DISPLAY" ]; then
    pc_host="$yellow"
  else
    pc_host="$green"
  fi

  # working directory
  if [ -w "$PWD" ]; then
    pc_dir="$cyan"
  else
    pc_dir="$red"
  fi

  PS1="\[$pc_user\]\u"
  PS1="$PS1\[$pc_proxy\]@"
  PS1="$PS1\[$pc_host\]\h\[$default\]:"
  PS1="$PS1\[$pc_dir\]\w"
  PS1="$PS1\[$yellow\]$($VCPROMPT -f '[%n:%b%m%u]')\[$default\]"

  # working directory
  if [ $last -eq 0 ]; then
    PS1="$PS1 \$ "
  else
    PS1="$PS1 \[$red\]$last!\[$default\] "
  fi

  # Test for day change.
  if [ -z $DAY ]; then
    export DAY=$(date +%A)
  else
    local today=$(date +%A)
    if [ "${DAY}" != "${today}" ]; then
      echo "\n\[$yellow\]Day changed to $(date '+%A, %d %B %Y').\[$default\]\n"
      export DAY=$today
    fi
  fi
}

PROMPT_COMMAND=promptcmd
export PS1 PROMPT_COMMAND

# -------------------------------------------------------------------
# MOTD / FORTUNE
# -------------------------------------------------------------------

uname -a && uptime


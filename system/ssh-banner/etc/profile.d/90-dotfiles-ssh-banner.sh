if [ -n "${SSH_CONNECTION:-}" ] &&
  [ -t 1 ] &&
  [ -z "${DOTFILES_SSH_BANNER_SHOWN:-}" ] &&
  [ -x /usr/local/bin/dotfiles-ssh-banner ]; then
  export DOTFILES_SSH_BANNER_SHOWN=1
  /usr/local/bin/dotfiles-ssh-banner
fi

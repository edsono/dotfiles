### Pipenv
set -gx PIPENV_VENV_IN_PROJECT True

### PyEnv
set -gx PYENV_ROOT ~/.pyenv
set --global fish_user_paths $fish_user_paths ~/.pyenv/bin
. (pyenv init -|psub)

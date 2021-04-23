if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
alias mkvenv='pyenv virtualenv'
alias rmvenv='pyenv virtualenv-delete'
alias acvenv='pyenv activate'
alias devenv='. deactivate'

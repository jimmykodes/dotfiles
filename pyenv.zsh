if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

alias mkvenv='pyenv virtualenv'
alias rmvenv='pyenv virtualenv-delete'
alias workon='pyenv activate'

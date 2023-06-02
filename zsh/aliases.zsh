# ls Aliases
#######################################

platform=$(uname)
case $platform in
Darwin)
	colorflag="-G"
	;;
Linux)
	colorflag="--color"
	;;
esac

alias ls="ls ${colorflag}"
if [[ -x "$(command -v exa)" ]]; then
  alias l="exa --icons --git --long"
  alias la="exa --icons --git --all --long"
else
  alias l='ls -lFh'
  alias la='ls -alFh'
fi

# Arch Aliases
######################################
alias X="arch -x86_64"
alias Xbrew="X /usr/local/bin/brew"

# Python Aliases
######################################
alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

# Common Aliases
######################################
alias fd="find . -type d -name"
alias ff="find . -type f -name"
alias grep="grep --color"
alias h="history"
alias help="man"
alias H="| head"
alias G="| grep"
alias unexport='unset'

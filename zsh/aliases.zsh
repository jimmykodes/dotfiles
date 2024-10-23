# Movement Aliases
#######################################
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias -- -="cd -"

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
if [[ -x "$(command -v eza)" ]]; then
	iconflag=""
	if exa --icons >/dev/null 2>&1; then
		iconsflag="--icons"
	fi
	commonflags="--git --long --group-directories-first --no-user --no-time --no-filesize"
	alias l="eza ${iconsflag} ${commonflags}"
	alias la="eza ${iconsflag} ${commonflags} --all"
	alias tree="eza --tree --classify --group-directories-first"
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

if [[ -x "$(command -v kubectl)" ]]; then
	alias k="kubectl"
fi

if [[ -x "$(command -v k9s)" ]]; then
	alias ks="k9s"
fi

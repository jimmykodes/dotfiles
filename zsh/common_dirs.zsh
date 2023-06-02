[ -d "$HOME/go/src" ] && export gosrc=$HOME/go/src

if [ -d "$HOME/Code" ]; then
	export code=$HOME/Code
elif [ -d "$HOME/code" ]; then
	export code=$HOME/code
fi

if [ -d "$HOME/.venv" ]; then
  export venv=$HOME/.venv
fi

export kodes=$gosrc/github.com/jimmykodes
export custom=$code/zsh-custom

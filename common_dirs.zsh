[ -d "$HOME/go/src" ] && export gosrc=$HOME/go/src
[ -d "$HOME/go/src/github.com/Khan" ] && export k=$HOME/go/src/github.com/Khan

if [ -d "$HOME/Code" ]; then
	export code=$HOME/Code
elif [ -d "$HOME/code" ]; then
	export code=$HOME/code
fi

if [ -d "$HOME/.venv" ]; then
  export venv=$HOME/.venv
fi

if [ -d "$HOME/DBs" ]; then
  export dbs=$HOME/DBs
fi

export kodes=$gosrc/github.com/jimmykodes
export custom=$code/zsh-custom

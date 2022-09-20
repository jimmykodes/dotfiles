[ -d "$HOME/go/src" ] && export gosrc=$HOME/go/src
[ -d "$HOME/go/src/github.com/Khan" ] && export khan=$HOME/go/src/github.com/Khan

if [ -d "$HOME/Code" ]; then
	export code=$HOME/Code
elif [ -d "$HOME/code" ]; then
	export code=$HOME/code
fi

export kodes=$gosrc/github.com/jimmykodes
export custom=$code/zsh-custom

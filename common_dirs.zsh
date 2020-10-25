export custom=$ZSH/custom
[ -d "$HOME/go/src" ] && export gosrc=$HOME/go/src
[ -d "$HOME/go/src/git.dev.kochava.com" ] && export dev=$HOME/go/src/git.dev.kochava.com
[ -d "$HOME/go/src/github.com/Kochava" ] && export koch=$HOME/go/src/github.com/Kochava

if [ -d "$HOME/Code" ]; then
        export code=$HOME/Code
elif [ -d "$HOME/code" ]; then
        export code=$HOME/code
fi

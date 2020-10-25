export custom=$ZSH/custom
gosrc=$HOME/go/src
dev=$gosrc/git.dev.kochava.com
koch=$gosrc/github.com/Kochava
[ -d "$dev" ] && export dev=$dev
[ -d "$gosrc" ] && export gosrc=$gosrc
[ -d "$koch" ] && export koch=$koch
if [ -d "$HOME/Code" ]; then
        export code=$HOME/Code
elif [ -d "$HOME/code" ]; then
        export code=$HOME/code
fi

export GOSRC=$HOME/go/src
export VENV=$HOME/.venv
export CODE_DIR=$GOSRC/github.com/jimmykodes
export DOTFILES=$CODE_DIR/dotfiles
export XDG_CONFIG_HOME="$HOME/.config"

[[ -d "$HOME/.cargo" ]] && . "$HOME/.cargo/env"
[[ -d "$GOSRC" ]] || mkdir -p "$GOSRC"
[[ -d "$VENV" ]] || mkdir -p "$VENV"

if [[ -e ~/.zshenv.local ]]; then
	. ~/.zshenv.local
fi

fpath=(
	/opt/homebrew/share/zsh/site-functions
	$DOTFILES/zsh/completions
	$DOTFILES/zsh/functions
	$fpath
)

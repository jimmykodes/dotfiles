export gosrc=$HOME/go/src
export venv=$HOME/.venv
export CODE_DIR=$gosrc/github.com/jimmykodes
export DOTFILES=$CODE_DIR/dotfiles

[ -d $gosrc/github.com/Khan ] && export KHAN=$gosrc/github.com/Khan

export XDG_CONFIG_HOME="$HOME/.config"

[[ -d "$HOME/.cargo" ]] && . "$HOME/.cargo/env"

[[ -d "$gosrc" ]] || mkdir -p "$gosrc"
[[ -d "$venv" ]] || mkdir -p "$venv"

fpath=(
  /opt/homebrew/share/zsh/site-functions
  $DOTFILES/zsh/functions
  $fpath
)

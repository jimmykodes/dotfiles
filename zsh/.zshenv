export gosrc=$HOME/go/src
export venv=$HOME/.venv
export CODE_DIR=$gosrc/github.com/jimmykodes
export DOTFILES=$CODE_DIR/dotfiles
export OBSIDIAN="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents"
export JARVIS_FILE="$OBSIDIAN/Work/Jarvis.md"
export COMMITS_FILE="$OBSIDIAN/Work/commits.md"
export DAILY_DIR="$OBSIDIAN/Work/daily"

[ -d $gosrc/github.com/Khan ] && export KHAN=$gosrc/github.com/Khan

export XDG_CONFIG_HOME="$HOME/.config"

. "$HOME/.cargo/env"

[[ -d "$gosrc" ]] || mkdir -p "$gosrc"
[[ -d "$venv" ]] || mkdir -p "$venv"

fpath=(
  /opt/homebrew/share/zsh/site-functions
  $DOTFILES/zsh/functions
  $fpath
)

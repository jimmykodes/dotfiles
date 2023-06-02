export gosrc=$HOME/go/src
export venv=$HOME/.venv
export CODE_DIR=$gosrc/github.com/jimmykodes
export DOTFILES=$CODE_DIR/dotfiles
export JARVIS_FILE="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work/Jarvis.md"

[ -d $gosrc/github.com/Khan ] && export KHAN=$gosrc/github.com/Khan

export XDG_CONFIG_HOME="$HOME/.config"

# Default location for appliation default credentials for google cloud services
# run `gcloud auth application-default login` to generate these credentials
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"

. "$HOME/.cargo/env"

[[ -d "$gosrc" ]] || mkdir -p "$gosrc"
[[ -d "$venv" ]] || mkdir -p "$venv"

fpath=(
  /opt/homebrew/share/zsh/site-functions
  $DOTFILES/zsh/functions
  $fpath
)

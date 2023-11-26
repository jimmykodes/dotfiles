# Load all zsh files in $DOTFILES dir
if [[ -d $DOTFILES/zsh ]]; then
  for file in $DOTFILES/zsh/*.zsh; do
    source $file
  done
fi

# Functions
if [[ -d $DOTFILES/zsh/functions ]]; then
    for func in $DOTFILES/zsh/functions/*; do
      autoload -U $(basename $func)
    done
fi

# Load plugins
if [[ -d $DOTFILES/zsh/plugins ]]; then
    for plug in $DOTFILES/zsh/plugins/*; do
      n=$(basename $plug)
      source $plug/$n.plugin.zsh
    done
fi

autoload -Uz compinit
compinit

# PATH
# prepend_path will only add to path if the dir exists
prepend_path $HOME/go/bin
prepend_path $HOME/.local/bin
prepend_path $DOTFILES/bin
prepend_path /usr/local/opt/openjdk@8/bin
[[ -n "$(command -v gcloud)" ]] && prepend_path "$(gcloud info --format="value(installation.sdk_root)")/bin"
# rasbperry pi
prepend_path /snap/bin
prepend_path /usr/local/go/bin

# for signing git commits
export GPG_TTY=$TTY

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zsyh=/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[ -f "/usr/local/share/${zsyh}" ] && source "/usr/local/share/${zsyh}"
[ -f "/opt/homebrew/share/${zsyh}" ] && source "/opt/homebrew/share/${zsyh}"
[ -f "/usr/share/${zsyh}" ] && source "/usr/share/${zsyh}"

[ -x $(command -v lvim) ] && export EDITOR=lvim || export EDITOR=vim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

prepend_path $HOME/.rd/bin

source $HOME/go/src/github.com/jimmykodes/dotfiles/zsh/themes/jimple/jimple.zsh-theme

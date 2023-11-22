# Functions
if [[ -d $DOTFILES/zsh/functions ]]; then
    for func in $DOTFILES/zsh/functions/*; do
      autoload -U $(basename $func)
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

# oh my zsh
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="jimple/jimple"
COMPLETION_WAITING_DOTS="true"
ZSH_CUSTOM="$HOME/go/src/github.com/jimmykodes/dotfiles/zsh"

plugins=(colorize docker gcloud kubectl)

# Fix "insecure directories and files" warning on terminal start
ZSH_DISABLE_COMPFIX=true

ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE=dracula
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256

source $ZSH/oh-my-zsh.sh

# Setup

# for signing git commits
export GPG_TTY=$TTY

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
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

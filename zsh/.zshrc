# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
COMPLETION_WAITING_DOTS="true"
ZSH_CUSTOM="$HOME/go/src/github.com/jimmykodes/dotfiles/zsh"

plugins=(git common-aliases colorize gcloud kubectl)

# Fix "insecure directories and files" warning on terminal start
ZSH_DISABLE_COMPFIX=true

# Select tool to use for colorize plugin. options: pygmentize, chroma
ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE=dracula
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256

source $ZSH/oh-my-zsh.sh

# Override alias rm='rm -i' from common-aliases plugin
unalias rm

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

local zsyh=/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [[ -e "/usr/local/share/$zsyh" ]]; then
    source "/usr/local/share/${zsyh}"
  elif [[ -e "/opt/homebrew/share/${zsyh}" ]]; then
    source "/opt/homebrew/share/${zsyh}"
fi

# for signing git commits
export GPG_TTY=$TTY

if [[ -n $(command -v lvim) ]]; then
  export EDITOR=lvim
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/jimmykeith/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

if [[ -d $DOTFILES/zsh/functions ]]; then
    for func in $DOTFILES/zsh/functions/*(:t); autoload -U $func
fi

# The following lines were added by compinstall
autoload -Uz compinit
compinit
# End of lines added by compinstall

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

plugins=(docker git go)
for plugin in "${plugins[@]}"; do
  if [[ -f $DOTFILES/zsh/plugins/$plugin/init.zsh ]]; then
    source "$DOTFILES/zsh/plugins/$plugin/init.zsh"
  else
    echo "$plugin not found"
    # TODO: pull from git (if git) and store in $HOME/.zlug/$plugin
  fi
done

autoload -Uz compinit
compinit

# PATH
# prepend_path will only add to path if the dir exists
prepend_path $HOME/go/bin
prepend_path $HOME/.local/bin
prepend_path $DOTFILES/bin
prepend_path /usr/local/opt/openjdk@8/bin
[[ -n "$(command -v gcloud)" ]] && prepend_path "$(gcloud info --format="value(installation.sdk_root)")/bin"
prepend_path $HOME/.rd/bin

# raspberry pi
prepend_path /snap/bin
prepend_path /usr/local/go/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# TODO: profile this, is it any faster to check zsyh_loaded vs just checking file paths?
zsyh_loaded=0
zsyh=/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ ($zsyh_loaded -eq 0) && (-f "/usr/local/share/${zsyh}") ]] && source "/usr/local/share/${zsyh}" && zsyh_loaded=1
[[ ($zsyh_loaded -eq 0) && (-f "/opt/homebrew/share/${zsyh}") ]] && source "/opt/homebrew/share/${zsyh}" && zsyh_loaded=1
[[ ($zsyh_loaded -eq 0) && (-f "/usr/share/${zsyh}") ]] && source "/usr/share/${zsyh}" && zsyh_loaded=1

[ -x $(command -v lvim) ] && export EDITOR=lvim || export EDITOR=vim

# TODO: figure out how to lazy load nvm, cause this is the slowest part of
# zsh load time
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

source $HOME/go/src/github.com/jimmykodes/dotfiles/zsh/themes/jimple/init.zsh

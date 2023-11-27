unsetopt beep

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

plugins=(
  docker
  git
  go
  "gh;zsh-users/zsh-syntax-highlighting;zsh-syntax-highlighting.zsh"
  "gh;zsh-users/zsh-autosuggestions;zsh-autosuggestions.zsh"
  "gh;marlonrichert/zsh-autocomplete;zsh-autocomplete.plugin.zsh"
)

OIFS=$IFS
for plugin in "${plugins[@]}"; do
  if [[ -f $DOTFILES/zsh/plugins/$plugin/init.zsh ]]; then
    source "$DOTFILES/zsh/plugins/$plugin/init.zsh"
  else
    parts=($(echo $plugin | tr ";" " "))
    if [ ${#parts[@]} -eq 1 ]; then
      echo "$plugin not found"
    else
      src=${parts[1]}
      repo=${parts[2]}
      init=${parts[3]}
      if [[ -z "$init" ]]; then init="init.zsh"; fi
      case $src in
        gh)
          if [ ! -d "$HOME/.zlug/$repo" ]; then
            git clone --depth=1 "git@github.com:$repo" "$HOME/.zlug/$repo"
          fi
          source "$HOME/.zlug/$repo/$init"
          ;;
        *)
          echo "invalid source - $src not supported"
          ;;
      esac fi
  fi
done
IFS=$OIFS

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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -x $(command -v lvim) ] && export EDITOR=lvim || export EDITOR=vim

# TODO: figure out how to lazy load nvm, cause this is the slowest part of
# zsh load time
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# up/down arrows search based on current line buffer
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

source $HOME/go/src/github.com/jimmykodes/dotfiles/zsh/themes/jimple/init.zsh

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
  colorize
  py_venv
  "gh;zsh-users/zsh-syntax-highlighting;zsh-syntax-highlighting.zsh"
  "gh;zsh-users/zsh-autosuggestions;zsh-autosuggestions.zsh"
)

for plugin in "${plugins[@]}"; do
  if [[ -f $DOTFILES/zsh/plugins/$plugin/init.zsh ]]; then
    source "$DOTFILES/zsh/plugins/$plugin/init.zsh"
  else
    IFS=";" read -Ar parts <<< "$plugin"
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
  if [[ -d $DOTFILES/zsh/plugins/$plugin/completions ]]; then
    fpath=(
      "$DOTFILES/zsh/plugins/$plugin/completions"
      $fpath
    )
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -x $(command -v lvim) ] && export EDITOR=lvim || export EDITOR=vim

export NVM_DIR="$HOME/.nvm"
# setting a default node bin
lp=($(find "$HOME/.nvm/versions/node" -regex ".*[0-9]/bin/npm" | sort))
prepend_path "$(dirname "${lp[-1]}")"
# passing --no-use speeds up load time a lot, by not having to lookup a default version
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# up/down arrows search based on current line buffer
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

source $HOME/go/src/github.com/jimmykodes/dotfiles/zsh/themes/jimple/init.zsh

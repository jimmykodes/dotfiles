if [[ -d "$HOME/.nvim" ]]; then
  export NVM_DIR="$HOME/.nvm"
  # setting a default node bin
  lp=($(find "$HOME/.nvm/versions/node" -regex ".*[0-9]/bin/npm" | sort))
  prepend_path "$(dirname "${lp[-1]}")"
  # passing --no-use speeds up load time a lot, by not having to lookup a default version
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" --no-use
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

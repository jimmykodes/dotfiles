if [[ -x $(command -v nvim) ]]; then
  export EDITOR='nvim'
  alias vim='nvim'
else
  export EDITOR='vim'
fi


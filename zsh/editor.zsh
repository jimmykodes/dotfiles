# if [[ -x $(command -v lvim) ]]; then
#   export EDITOR='lvim'
#   alias vim='lvim'
# elif [[ -x $(command -v nvim) ]]; then
if [[ -x $(command -v nvim) ]]; then
  export EDITOR='nvim'
  alias vim='nvim'
else
  export EDITOR='vim'
fi


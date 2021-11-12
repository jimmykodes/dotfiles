# Path to local go bin
export PATH=$HOME/go/bin:$PATH
export GOPATH=$HOME/go

alias ggclip='go get $(pbpaste | sed "s/http[s]*:\/\///")'
alias gmv='go mod vendor'
alias gmt='go mod tidy'

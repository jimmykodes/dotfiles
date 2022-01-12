# Path to local go bin
export PATH=$HOME/go/bin:$PATH
export GOPATH=$HOME/go

alias ggclip='go get $(pbpaste | sed "s/http[s]*:\/\///")'
alias gmi='go mod init'
alias gmv='go mod vendor'
alias gmt='go mod tidy'
alias gorm='go run main.go'

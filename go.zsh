# Path to local go bin
export GOPATH=$HOME/go

unalias gog
alias gog='go get -d'
alias ggclip='go get -d $(pbpaste | sed "s/http[s]*:\/\///")'
alias gmi='go mod init'
alias gmv='go mod vendor'
alias gmt='go mod tidy'
alias gorm='go run main.go'

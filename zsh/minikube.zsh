alias mkb='kubectl --context minikube'
alias mkba='mkb apply'
alias mkbak='mkba -k'
alias mkbd='mkb delete'
alias mkbdk='mkbd -k'

mkbb() {
    image=$(basename $PWD)
    docker build -t $(minikube ip):5000/${1:-$image}:local .
}

mkbp() {
    image=$(basename $PWD)
    docker push "$(minikube ip):5000/${1:-$image}:local"
}

mkbbp() {
    mkbb "$@"
    mkbp "$@"
}


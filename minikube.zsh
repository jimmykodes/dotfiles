alias mkba='kubectl --context minikube apply'
alias mkbak='kubectl --context minikube apply -k'
alias mkbd='kubectl --context minikube delete'
alias mkbdk='kubectl --context minikube delete -k'

mkp() {
    image=$(basename $PWD)
    docker push "$(minikube ip):5000/${1:-$image}:local"
}

mkb() {
    image=$(basename $PWD)
    docker build -t $(minikube ip):5000/${1:-$image}:local .
}

mkbp() {
    mkb "$@"
    mkp "$@"
}


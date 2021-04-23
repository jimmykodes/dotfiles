# Docker Aliases
#######################################
alias dc='docker compose'
alias dcd='docker compose down'
alias dcr='docker compose restart'
alias dcs='docker compose stop'

alias dcud='docker compose up -d'
alias dcudb='docker compose up -d --build'

alias dce='docker compose exec'
alias dcl='docker compose logs'
alias dclf='docker compose logs -f'

alias dl='docker logs'
alias dlf='docker logs -f'
alias de='docker exec'
alias deit='docker exec -it'
alias drn='docker run'
alias drrm='docker run --rm'
alias dp='docker pull'


alias dst='docker stats'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dk='docker kill'
alias drm='docker rm'

dcudblf() {
  docker compose up -d --build $1 && docker compose logs -f $1
}

drma() {
  if [ -z "$(docker ps -aq)" ]; then
    echo 'No containers to remove'
  else
    docker rm $(docker ps -aq)
  fi
}

dka() {
  if [ -z "$(docker ps -q)" ]; then
    echo 'No running containers'
  else
    docker kill $(docker ps -q)
  fi
}
dcln() {
  dka
  drma
}
dccb() {
  docker compose exec $1 bash
}

dccs() {
  docker compose exec $1 sh
}

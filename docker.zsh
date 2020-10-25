# Docker Aliases
#######################################
alias dc='docker-compose'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcs='docker-compose stop'

alias dcud='docker-compose up -d'
alias dcudb='docker-compose up -d --build'

alias dce='docker-compose exec'
alias dcdb='docker-compose exec django bash'
alias dcsp='docker-compose exec django python manage.py shell_plus'
alias dcm='docker-compose exec django python manage.py migrate'
alias dcmm='docker-compose exec django python manage.py makemigrations'
alias dcgd='docker-compose exec django python manage.py generate_data'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'

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

drma() {
  if [ -f "$(docker ps -aq)" ]; then
    echo 'No containers to remove'
  else
    docker rm $(docker ps -aq)
  fi
}

dka() {
  if [ -f "$(docker ps -q)" ]; then
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
  docker-compose exec $1 bash
}

dccs() {
  docker-compose exec $1 sh
}

# Docker Aliases
#######################################
alias dc='docker-compose'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcs='docker-compose stop'

alias dcud='docker-compose up -d'
alias dcb='docker-compose up -d --build'

alias dce='docker-compose exec'
alias dcdb='docker-compose exec django bash'
alias dcsp='docker-compose exec django python manage.py shell_plus'
alias dcm='docker-compose exec django python manage.py migrate'
alias dcmm='docker-compose exec django python manage.py makemigrations'
alias dcgd='docker-compose exec django python manage.py generate_data'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'

alias dst='docker stats'
alias dps='docker ps'
alias dpsa='docker ps -a'

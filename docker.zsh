# Docker Aliases
#######################################
alias dc='docker compose'
alias dcd='dc down'

alias dce='dc exec'
alias dcl='dc logs'

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

docker_services() {
	docker compose ps --services
}

dcr() {
	dc restart "$@"
}

dcs() {
	dc stop "$@"
}

dcud() {
	dc up -d "$@"
}

dcudb() {
	dcud --build "$@"
}

dclf() {
	dcl -f "$@"
}

dcudlf() {
	dcud "$@" && dclf "$@"
}

dcudblf() {
	dcudb "$@" && dclf "$@"
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
	dc exec $1 bash
}

dccs() {
	dc exec $1 sh
}

temp_mysql() {
	docker run \
        --rm \
        -d \
        -p ${1:-3306}:3306 \
        --env MARIADB_ALLOW_EMPTY_ROOT_PASSWORD="yes" \
        --name temp_mysql \
        mariadb:10.5
}

temp_mysql_init() {
    docker run \
        --rm \
        -d \
        -p ${1}:3306 \
        -v ${2}:/docker-entrypoint-initdb.d \
        --env MARIADB_ROOT_PASSWORD="password" \
        --name temp_mysql \
        mariadb:10.5
}

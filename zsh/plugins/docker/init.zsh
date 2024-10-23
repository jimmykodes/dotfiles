# Docker Aliases
#######################################
alias dc='docker compose'
alias dcd='dc down'
alias dcdv='dcd --volumes'
alias dce='dc exec'

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

dcl() {
	dc logs "$@"
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

temp_psql_init() {
	docker run \
		--rm \
		-d \
		-p 5432:5432 \
		-v ${1}:/docker-entrypoint-initdb.d \
		--env POSTGRES_PASSWORD=password \
		--name temp_psql \
		postgres:14
}

temp_psql() {
	docker run \
		--rm \
		-d \
		-p ${1:-5432}:5432 \
		--env POSTGRES_PASSWORD=password \
		--name temp_psql \
		postgres:14
}

temp_datastore() {
	docker run \
		--rm \
		-d \
		-p ${1:-8081}:8081 \
		--name temp_datastore \
		gcr.io/google.com/cloudsdktool/google-cloud-cli:latest \
		gcloud beta emulators datastore start --project local-test --host-port 0.0.0.0:8081
}

temp_pubsub() {
	docker run \
		--rm \
		-d \
		-p ${1:-8085}:8085 \
		--name temp_pubsub \
		gcr.io/google.com/cloudsdktool/google-cloud-cli:latest \
		gcloud beta emulators pubsub start --project local-test --host-port 0.0.0.0:8085
}

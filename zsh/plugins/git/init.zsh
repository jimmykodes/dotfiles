#!/usr/bin/env bash

alias g="git"

jkcln() {
	local repo="$1"
	shift 1
	git cl -r "jimmykodes/$repo" -d "$CODE_DIR/$repo" "$@"
}

wkcln() {
	if [ -z "$WORK" ] || [ -z "$WORK_ORG" ]; then
		echo "no work configs found. set WORK and WORK_ORG env vars."
		return 1
	fi
	local repo="$1"
	shift 1
	git cl -r "$WORK_ORG/$repo" -d "$WORK/$repo" "$@"
}

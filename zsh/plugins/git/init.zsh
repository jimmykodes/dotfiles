#!/usr/bin/env bash

alias g="git"

jkcln() {
	local repo="$1"
	shift 1
	git cl -r "jimmykodes/$repo" -d "$CODE_DIR/$repo" "$@"
}

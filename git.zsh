#!/usr/bin/env bash
# alias stuff
unalias gcl
alias gdb='git diff $(git_main_branch)...$(git_current_branch)'
alias gcnvm='git commit --no-verify -m'


# functions
gcl() {
	follow=
	repo=
	dir=
	while [[ -n $1 ]]; do
		case $1 in
		-f | --follow)
			follow=1
			;;
		*)
			if [[ -z "$repo" ]]; then
				repo=$1
			elif [[ -z "$dir" ]]; then
				dir=$1
			fi
			;;
		esac
		shift
	done
	if [[ "$1" == '--' ]]; then shift; fi

	if [[ -z $repo ]]; then
		echo "repo required"
		return
	fi
	i="git clone --recurse-submodules git@github.com:$repo"
	if [[ -n $dir ]]; then
		i="$i $dir"
	fi
	echo "running cmd: $i"
	eval $i
	if [[ -n $follow ]]; then
		cd $dir
	fi
}

jkcln() {
	gcl "jimmykodes/$1" "$kodes/$1" "$@"
}

kocln() {
	gcl "Kochava/$1" "$koch/$1" "$@"
}

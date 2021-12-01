#!/usr/bin/env bash
# alias stuff
unalias gcl
alias gdb='git diff $(git_main_branch)...$(git_current_branch)'

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
			echo "setting var"
			if [[ -z "$repo" ]]; then
				echo "setting repo $1"
				repo=$1
			elif [[ -z "$dir" ]]; then
				echo "setting dir $1"
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

jk_clone() {
	gcl "jimmykodes/$1" "$kodes/$1" "$@"
}

ko_clone() {
	gcl "Kochava/$1" "$koch/$1" "$@"
}

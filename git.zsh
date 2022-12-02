#!/usr/bin/env bash
# alias stuff
unalias gcl
unalias gcb

alias gdb='git diff $(git_main_branch)...$(git_current_branch)'
alias gcnvm='git commit --no-verify -m'

# functions
gitcc() {
    if [[ -z $(command -v convco) ]]; then
        echo 'convco not installed. Run `go install github.com/jimmykodes/convco@latest`'
    else
        convco "$@"
    fi
}

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

kcln() {
	gcl "Khan/$1" "$k/$1" "$@"
}

git_develop_branch() {
    command git rev-parse --git-dir &> /dev/null || return
	local branch
	for branch in initial_dev dev devel development
	do
		if command git show-ref -q --verify refs/heads/$branch
		then
			echo $branch
			return
		fi
	done
	echo develop
}

ghrc() {
  local git_cb=$(git_current_branch)
  gh release create $1 --target ${2:-"$git_cb"} --prerelease --generate-notes
}

gcb() {
  local branch=$1
  if [[ -z $branch ]]; then
    echo "branch required"
    return 1
  fi
  git config --add branch.lastcreated $branch
  git checkout -b $branch
}

gcol() {
  local branch=$(git config --get branch.lastcreated)
  if [[ -z $branch ]]; then
    echo "no previously created branch to checkout"
    return 1
  fi
  if [[ $branch == $(git rev-parse --abbrev-ref HEAD) ]]; then
    echo "last created branch already checked out"
    return
  fi
  git checkout $branch
}

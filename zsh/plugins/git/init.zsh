#!/usr/bin/env bash

alias g="git"
alias gdb='git diff @{upstream}...$(git current-branch)'
alias gcnvm='git commit --no-verify -m'

alias gp='git push origin $(git current-branch)'
alias "gp!"="gp --force"
alias gpsup='git push --set-upstream origin $(git current-branch)'

alias gl='git pull origin $(git current-branch)'
alias gf='git fetch'

alias gst='git status'

alias gapa='git add --patch'
alias ga='git add'
alias gaa='git add .'

alias gco="git checkout"

alias gb="git branch"
alias gbd="git branch -d"
alias gbD="git branch -D"
alias gbda="git bleach"

alias grs="git restore --staged"

alias gcd="git checkout-dev"
alias gcm="git checkout-main"

alias gmom="git merge-origin-main"

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
	gcl "jimmykodes/$1" "$CODE_DIR/$1" "$@"
}

kcln() {
	gcl "Khan/$1" "$KHAN/$1" "$@"
}

gcb() {
	local branch=$1
	local issue=$2
	if [[ -z $branch ]]; then
		echo "branch required"
		return 1
	fi
	git config --replace-all branch.lastcreated $branch
	git checkout -b $branch
	if [[ -n $issue ]]; then
		git config --add branch.$branch.issue $issue
	fi
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

gcmsg() {
	local message=$1
	if [[ -z $message ]]; then
		echo "message required"
		return 1
	fi
	git commit --message $message
	local project=$(basename $(project-root))
	local messageStore=$(git config --get commit.messageStore)
	if [[ -n "$messageStore" ]]; then
		echo "$(date +%Y-%m-%d): $project: $message" >>"$messageStore"
	fi
}

## GitHub Functions

ghrc() {
	local git_cb=$(git current-branch)
	gh release create $1 --target ${2:-"$git_cb"} --prerelease --generate-notes
}

escape() {
	sed 's/\//\\\//g' <<<"$1"
}

ghpr() {
	tmpl() {
		for location in "." "docs" ".github" "$HOME/.config/git-templates"; do
			for ft in md txt; do
				local file="$location/pull_request_template.${ft}"
				if [[ -e "$file" ]]; then
					echo "$file"
					return
				fi
			done
		done
	}

	local t
	local body_file
	local issue
	local args='--assignee=@me'

	t=$(tmpl)
	if [[ -n $t ]]; then
		body_file="$(mktemp -d)/body.md"
		issue=$(git current-issue)
		if [[ -n $issue ]]; then
			issue="Issue: [$issue]($JIRA_ADDRESS/browse/$issue)"
		fi
		sed "s/{{issue}}/$(escape "$issue")/" "$t" >"$body_file"
		eval "$EDITOR \"$body_file\""
		args="$args -F=$body_file"
		echo "Body file saved to $body_file"
	fi

	eval "gh pr create $args $*"
}

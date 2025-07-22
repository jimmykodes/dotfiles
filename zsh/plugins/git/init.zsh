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

alias gw="git worktree"

gws() {
	local branch="$1"
	if [[ -z $branch ]]; then
		echo "branch required"
		return 1
	fi
	local dir
	dir=$(git worktree list --porcelain | rg "refs/heads/$branch" -B2 | head -n 1 | awk '{print $2}')
	cd "$dir" || return 1
}

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

gcb() {
	local branch=$1
	local issue=$2
	if [[ -z $branch ]]; then
		echo "branch required"
		return 1
	fi
	git checkout -b $branch
	if [[ -n $issue ]]; then
		git config --add branch.$branch.issue $issue
	fi
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

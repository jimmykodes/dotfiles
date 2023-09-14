#!/usr/bin/env bash

alias gdb='git diff $(git_main_branch)...$(git_current_branch)'
alias gcnvm='git commit --no-verify -m'
alias gp='git push'
alias "gp!"="git push --force"
alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gl="git pull"
alias gst='git status'
alias gapa='git add --patch'
alias ga='git add'
alias gaa='git add .'
alias gco="git checkout"
alias gbd="git branch -d"
alias gbD="git branch -D"

gcd() {
  local branch
  local current

  branch=$(git_develop_branch)
  current=$(git_current_branch)

  if [[ -z $branch ]]; then
    echo "Could not find a develop branch to checkout"
    return 1
  elif [[ "$branch" == "$current" ]]; then
    echo "Develop branch is already checked out"
    return
  fi
  git checkout "$branch"
}

gcm() {
  local branch
  local current

  branch=$(git_main_branch)
  current=$(git_current_branch)

  if [[ -z $branch ]]; then
    echo "Could not find a main branch to checkout"
    return 1
  elif [[ "$branch" == "$current" ]]; then
    echo "Main branch is already checked out"
    return
  fi
  git checkout "$branch"
}

gmom() {
  local branch
  branch=$(git_main_branch)
  # if somehow a main branch doesn't exist locally, assume `main` is going
  # to be present on the remote, which I'm assuming is going to be `origin`
  # for simplicity. Will update this if I ever need a different remote.
  [[ -z $branch ]] && branch="main"
  git merge "origin/$branch"
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
	gcl "jimmykodes/$1" "$CODE_DIR/$1" "$@"
}

kcln() {
	gcl "Khan/$1" "$KHAN/$1" "$@"
}

git_main_branch() {
  command git rev-parse --git-dir &> /dev/null || return 1
	local branch
	for branch in main master
	do
		if command git show-ref -q --verify refs/heads/$branch
		then
			echo $branch
			return
		fi
	done
  return 1
}

git_develop_branch() {
  command git rev-parse --git-dir &> /dev/null || return 1
	local branch
	for branch in initial_dev dev devel development develop
	do
		if command git show-ref -q --verify refs/heads/$branch
		then
			echo $branch
			return
		fi
	done
  return 1
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
      echo "$(date +%Y-%m-%d): $project: $message" >> "$messageStore"
  fi
}

git_current_issue() {
  git config --get "branch.$(git_current_branch).issue"
}

git_add_issue() {
  git config --add "branch.$(git_current_branch).issue" "$1"
}

## GitHub Functions

ghrc() {
  local git_cb=$(git_current_branch)
  gh release create $1 --target ${2:-"$git_cb"} --prerelease --generate-notes
}

escape() {
  sed 's/\//\\\//g' <<< "$1"
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
  local args
  local body_file
  local issue

  t=$(tmpl)
  if [[ -n $t ]]; then
    body_file="$(mktemp -d)/body.md"
    issue=$(git_current_issue)
    if [[ -n $issue ]]; then
      issue="Issue: [$issue]($JIRA_ADDRESS/browse/$issue)"
    fi
    sed "s/{{issue}}/$(escape "$issue")/" "$t" > "$body_file"
    eval "$EDITOR \"$body_file\""
    args="-F=$body_file"
  fi

  gh pr create "$args" "$@"
}


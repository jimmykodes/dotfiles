# !/usr/bin/env zsh
# This allows expansion of the prompt.
# without it
# `$USER >>` stays the same,
# but when set this become `jimmykeith >>`
setopt prompt_subst

# this allows the color expansions like `%{$fg[green]%}`
autoload -Uz colors
colors

autoload -Uz add-zsh-hook
zmodload zsh/datetime zsh/stat

NEWLINE=$'\n'
DELIM=" %{$fg_bold[grey]%}|%{$reset_color%} "

declare -gA icons
icons=(
	APPLE_ICON '\uF179'          # 
	LINUX_RASPBIAN_ICON '\uF315' # 
	LINUX_UBUNTU_ICON '\uF31b'   # 
	ARCH_ICON '\uE266'           # 
	SSH_ICON '\uF489'            # 

	HOME_ICON '\uF015'     # 
	HOME_SUB_ICON '\uF07C' # 

	VCS_DIRTY_ICON ''
	VCS_BRANCH_ICON '\uF126'           # 
	VCS_STASH_ICON '\uF01C'            # 
	VCS_INCOMING_CHANGES_ICON '\u2193' # ↓
	VCS_OUTGOING_CHANGES_ICON '\u2191' # ↑
	VCS_PR '\uf407'                    # 

	DOCKER_ICON '\uf21f' # 
	PYTHON_ICON '\UE73C' # 
	NODE_ICON '\u2B22'   # ⬢

	MULTILINE_FIRST_PROMPT_PREFIX '\u256D\U2500' # ╭─
	MULTILINE_LAST_PROMPT_PREFIX '\u2570\U2500'  # ╰─
)

icon() {
	print $icons[$1]
}

_jimple_start() {
	echo "%{$fg_bold[grey]%}$icons[MULTILINE_FIRST_PROMPT_PREFIX]%{$reset_color%} "
}

_jimple_end() {
	echo "%{$fg_bold[grey]%}$icons[MULTILINE_LAST_PROMPT_PREFIX]%{$reset_color%}%(?:%{$fg[green]%}❯:%{$fg[red]%}❯) "
}

_jimple_ssh() {
	if [[ -n $SSH_CLIENT ]]; then
		echo "%{$fg[yellow]%}$icons[SSH_ICON] $USER@%m%{$reset_color%}${DELIM}"
	fi
}

_jimple_arch() {
	if [[ $(tput cols) -lt 100 ]]; then
		## don't show on terminals < 100 cols
		return
	fi
	local ret
	ret=$(uname -m)

	case $ret in
	arm64 | armv7l)
		ret="arm"
		;;
	x86_64)
		ret="x86"
		;;
	esac

	echo "${DELIM}${icons[ARCH_ICON]} $ret"
}

_jimple_wd() {
	local wd="${PWD/$HOME/~}"
	local icon="HOME_SUB_ICON"

	[[ $wd == "~" ]] && icon="HOME_ICON"
	echo "%{$fg[blue]%}${icons[$icon]} ${wd}%{$reset_color%}"
}

_jimple_venv() {
	local venv="$VIRTUAL_ENV"
	[[ -z $venv ]] && return
	venv=$(basename $venv)
	local version=$(python -V 2>/dev/null | awk '{ print $2 }')
	[[ -z $version ]] && version=$(python -V 2>&1 | awk '{ print $2 }')
	local machine=$(python -c "import platform; print(platform.machine())")
	echo "${DELIM}%F{magenta}${icons[PYTHON_ICON]} $venv($version)[$machine]%f"
}

_jimple_docker() {
	if docker version >/dev/null 2>&1; then
		local running
		local all
		running=$(docker ps -q | wc -l | sed 's/ //g')
		all=$(docker ps -aq | wc -l | sed 's/ //g')

		local out="${DELIM}%F{blue}${icons[DOCKER_ICON]}"
		if [ $all -gt 0 ]; then
			out="${out}  ${running}/${all}"
		fi
		echo "${out}%f"
	fi
}

declare -A git_strings
git_strings=(
	STASH "%F{white}${icons[VCS_STASH_ICON]}%f"
	AHEAD "%F{magenta}${icons[VCS_OUTGOING_CHANGES_ICON]}%f"
	BEHIND "%F{magenta}${icons[VCS_INCOMING_CHANGES_ICON]}%f"
)

_jimple_git_bare() {
	echo "${DELIM}%F{magenta}${icons[VCS_BRANCH_ICON]} root%f"
}

_jimple_git_branch() {
	local git_branch
	local git_status
	local num_stash
	git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

	# if fetching branch name failed, assume not a git repo
	[ $? -eq 0 ] || return

	git_status=$(git status --porcelain --branch)
	num_stash=$(git stash list | wc -l)

	stash=""

	if [ $num_stash -gt 0 ]; then stash+=${git_strings[STASH]}; fi
	if rg -q "\[ahead [\d]+\]" <<<$git_status; then stash+=${git_strings[AHEAD]}; fi
	if rg -q "\[behind [\d]+\]" <<<$git_status; then stash+=${git_strings[BEHIND]}; fi

	branch_color="green"
	if rg -q "^([AMD]|.[AMD]|\?{2})" <<<$git_status; then
		branch_color="yellow"
		git_branch="${git_branch}${icons[VCS_DIRTY_ICON]}"
	fi

	[[ $stash == "" ]] || stash=" ${stash}"

	echo "${DELIM}%F{cyan}${icons[VCS_BRANCH_ICON]}%f %F{$branch_color}${git_branch}%f${stash}"
}

_get_pr_num() {
	local cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/pr-status
	local key=${PWD//\//%}            # /a/b -> %a%b, filesystem-safe
	local cache_file=$cache_dir/$key
	local ttl=120 mtime # 2 minutes cache for PR status

	local pr

	mkdir -p "$cache_dir"

	if [[ -f $cache_file ]]; then
		zstat -A mtime +mtime "$cache_file"
		if (( EPOCHSECONDS - mtime < ttl )); then
			pr=$(cat "$cache_file")
		else
			rm -f $cache_file
		fi
	fi

	if [[ -z "$pr" ]]; then
		local tmp=$cache_file.$$
		if gh pr view --json number,state,statusCheckRollup > "$tmp" 2>/dev/null; then
			mv "$tmp" "$cache_file"   # atomic rename
			pr=$(cat "$cache_file")
		else
			rm -f "$tmp"
		fi
	fi

	if [[ -z "$pr" ]]; then
		echo ""
	else
		local pr_color=""
		local pr_icon=""
		local pr_number=$(jq -r .number <<< "$pr")
		local pr_state=$(jq -r .state <<< "$pr")
		local pr_review=$(jq -r .reviewDecision <<< "$pr")
		local pr_draft=$(jq -r .isDraft <<< "$pr")

    case $pr_state in
      OPEN)
        if [[ $pr_draft == true ]]; then
          pr_color=8                # dull: bright black
          pr_icon=$'\uf4dd'         # nf-oct-git_pull_request_draft
        elif [[ $pr_review == CHANGES_REQUESTED ]]; then
          pr_color=yellow           # warning
          pr_icon=$'\uf071'         # nf-fa-warning
        elif [[ $pr_review == APPROVED ]]; then
          pr_color=green            # success
          pr_icon=$'\uf00c'         # nf-fa-check
        else
          pr_color=blue             # info
					pr_icon=$'\uf407'         # nf-oct-git_pull_request
        fi
        ;;
      MERGED)
        pr_color=magenta            # visual
        pr_icon=$'\uf419'           # nf-oct-git_merge
        ;;
      CLOSED)
        pr_color=red                # failure
        pr_icon=$'\uf4dc'           # nf-oct-git_pull_request_closed
        ;;
      *)
        pr_color=default            # plain StatusLine
        pr_icon=
        ;;
    esac

		echo "%F{$pr_color}${pr_icon} ${pr_number}%f"
	fi
}

declare -g pr_num=""

_prompt_callback() {
  local fd=$1
  local line
  # read the result; the second arg may contain an error/hup indicator
  if [[ -z $2 || $2 == hup ]]; then
    read -r -u $fd line
		if [[ -z $line ]]; then
			pr_num=""
		else
			pr_num="${DELIM}${line}"
		fi
    zle && zle reset-prompt
  fi
  # clean up
  zle -F $fd
  exec {fd}<&-
}

_jimple_gh_pr() {
	pr_num=""
  # Open a fd reading from the background command
  exec {PROMPT_FD}< <(_get_pr_num)
  zle -F $PROMPT_FD _prompt_callback
}

_prompt_async_start() {
	_jimple_gh_pr
}

add-zsh-hook precmd _prompt_async_start


_jimple_git() {
	local bare
	bare=$(git rev-parse --is-bare-repository 2>/dev/null)

	[ $? -eq 0 ] || return $?

	if [ "$bare" = "true" ]; then
		_jimple_git_bare
	else
		_jimple_git_branch
	fi

}

VIRTUAL_ENV_DISABLE_PROMPT=1

P=""
P+='$(_jimple_start)'
P+='$(_jimple_ssh)'
P+='$(_jimple_wd)'
P+='$(_jimple_git)'
P+='${pr_num}'
P+='$(_jimple_venv)'
P+='$(_jimple_docker)'
# P+='$(_jimple_arch)'
P+="${NEWLINE}"
P+='$(_jimple_end)'
P+="%{$reset_color%}"

PROMPT=$P

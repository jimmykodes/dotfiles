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
zmodload zsh/datetime
zmodload -F zsh/stat b:zstat

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
	# %~ only abbreviates $HOME at a path boundary at the start of the path
	local wd="${(%):-%~}"
	local icon="HOME_SUB_ICON"

	[[ $wd == "~" ]] && icon="HOME_ICON"
	wd="${wd//\%/%%}" # escape % so the prompt doesn't treat it as a code
	echo "%{$fg[blue]%}${icons[$icon]} ${wd}%{$reset_color%}"
}

typeset -gA _jimple_py_cache

# Runs in the parent shell (precmd) so the cache assignment persists.
# One interpreter start per venv; empty results are not cached so a broken
# or half-built venv is retried on the next prompt.
_jimple_venv_cache() {
	[[ -z $VIRTUAL_ENV ]] && return
	[[ -n ${_jimple_py_cache[$VIRTUAL_ENV]} ]] && return
	local info
	info=$("$VIRTUAL_ENV/bin/python" -c 'import platform; print(platform.python_version(), platform.machine())' 2>/dev/null)
	[[ -n $info ]] && _jimple_py_cache[$VIRTUAL_ENV]=$info
}

add-zsh-hook precmd _jimple_venv_cache

# Called via $(...): only reads the cache, never starts a process.
_jimple_venv() {
	[[ -z $VIRTUAL_ENV ]] && return
	local info=${_jimple_py_cache[$VIRTUAL_ENV]}
	local version=${info%% *} machine=${info##* }
	echo "${DELIM}%F{magenta}${icons[PYTHON_ICON]} ${VIRTUAL_ENV:t}($version)[$machine]%f"
}

_jimple_docker() {
	(( $+commands[docker] )) || return

	# One daemon round trip, bounded so a hung daemon can't hang the prompt.
	local -a tmo
	if (( $+commands[timeout] )); then
		tmo=(timeout 1)
	elif (( $+commands[gtimeout] )); then
		tmo=(gtimeout 1)
	fi

	local counts
	counts=$($tmo docker info --format '{{.ContainersRunning}}/{{.Containers}}' 2>/dev/null) || return

	local out="${DELIM}%F{blue}${icons[DOCKER_ICON]}"
	if [[ -n $counts && $counts != 0/0 ]]; then
		out="${out}  ${counts}"
	fi
	echo "${out}%f"
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
	local -a lines
	lines=( ${(f)"$(command git status --porcelain=v2 --branch --show-stash 2>/dev/null)"} )

	# no output means not a work tree (or not a git repo at all)
	(( $#lines )) || return

	local line git_branch oid ahead=0 behind=0 stash=0 dirty=0
	for line in $lines; do
		case $line in
			'# branch.oid '*)  oid=${line#\# branch.oid } ;;
			'# branch.head '*) git_branch=${line#\# branch.head } ;;
			'# branch.ab '*)   [[ $line =~ '\+([0-9]+) -([0-9]+)' ]] && { ahead=$match[1]; behind=$match[2] } ;;
			'# stash '*)       stash=${line#\# stash } ;;
			'#'*) ;;
			*) dirty=1 ;;
		esac
	done

	# detached HEAD: show the short commit hash instead of "(detached)"
	[[ $git_branch == '(detached)' ]] && git_branch=${oid[1,7]}
	# escape % so it isn't read as a prompt code
	git_branch=${git_branch//\%/%%}

	local indicators=""
	(( stash > 0 ))  && indicators+=${git_strings[STASH]}
	(( ahead > 0 ))  && indicators+=${git_strings[AHEAD]}
	(( behind > 0 )) && indicators+=${git_strings[BEHIND]}

	local branch_color="green"
	if (( dirty )); then
		branch_color="yellow"
		git_branch="${git_branch}${icons[VCS_DIRTY_ICON]}"
	fi

	[[ $indicators == "" ]] || indicators=" ${indicators}"

	echo "${DELIM}%F{cyan}${icons[VCS_BRANCH_ICON]}%f %F{$branch_color}${git_branch}%f${indicators}"
}

_get_pr_num() {
	local cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}/pr-status-v2
	# key on repo root + branch, so subdirectories share an entry and
	# switching branches invalidates it
	local -a info
	info=("${(@f)$(git rev-parse --show-toplevel --abbrev-ref HEAD 2>/dev/null)}")
	[[ -n ${info[2]} ]] || return     # not a git repo (or no commits)
	local key=${info[1]//\//%}%%${info[2]//\//%}   # /a/b + feat/x -> %a%b%%feat%x
	local cache_file=$cache_dir/$key
	local ttl=120 mtime # 2 minutes cache for PR status

	local pr

	mkdir -p "$cache_dir"

	local fresh=0
	if [[ -f $cache_file ]]; then
		zstat -A mtime +mtime "$cache_file"
		(( EPOCHSECONDS - mtime < ttl )) && fresh=1
	fi

	if (( fresh )); then
		pr=$(<"$cache_file")   # may be empty: that's a valid cached "no PR"
	else
		# $$ is the parent shell's PID even inside <(...), so use mktemp
		# (same dir as the cache file, so the mv stays an atomic rename).
		local tmp err
		tmp=$(mktemp "$cache_file.XXXXXX") || return
		# cache one line: "STATE isDraft REVIEW number", e.g. "OPEN false APPROVED 123"
		# (reviewDecision is "" when no review yet; "//" doesn't catch that)
		err=$(gh pr view --json number,state,isDraft,reviewDecision \
			--jq '[.state, (.isDraft|tostring), (.reviewDecision | if . == null or . == "" then "NONE" else . end), (.number|tostring)] | join(" ")' \
			2>&1 >"$tmp")
		if (( $? == 0 )) || [[ $err == *"no pull requests found"* ]]; then
			# success, or a definite "no PR" (tmp is empty): cache for full TTL
			mv "$tmp" "$cache_file"   # atomic rename
		else
			# network/auth error: keep any previous entry, retry in ~20s
			rm -f "$tmp"
			[[ -f $cache_file ]] || : > "$cache_file"
			touch -t "$(strftime %Y%m%d%H%M.%S $(( EPOCHSECONDS - ttl + 20 )))" "$cache_file"
		fi
		pr=$(<"$cache_file")
	fi

	if [[ -z "$pr" ]]; then
		echo ""
	else
		local pr_color=""
		local pr_icon=""
		local pr_state pr_draft pr_review pr_number
		read -r pr_state pr_draft pr_review pr_number <<< "$pr"

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
declare -g _jimple_pr_fd=

typeset -g _jimple_pr_ctx=""   # repo+branch the current pr_num belongs to

_prompt_callback() {
  local fd=$1
  local line jctx
  # read the result; the second arg may contain an error/hup indicator
  if [[ -z $2 || $2 == hup ]]; then
    # first line: the context the job ran for; second: the PR segment
    read -r -u $fd jctx
    read -r -u $fd line
    # ignore a late result that belongs to a different repo/branch
    if [[ $jctx == $_jimple_pr_ctx ]]; then
      local new=""
      [[ -n $line ]] && new="${DELIM}${line}"
      if [[ $new != $pr_num ]]; then
        pr_num=$new
        zle && zle reset-prompt   # only redraw when something changed
      fi
    fi
  fi
  # clean up
  zle -F $fd
  exec {fd}<&-
  [[ $_jimple_pr_fd == $fd ]] && _jimple_pr_fd=
}

_jimple_gh_pr() {
  local ctx
  ctx=${(j:%:)${(f)"$(command git rev-parse --show-toplevel --abbrev-ref HEAD 2>/dev/null)"}}
  # keep the old value while the job runs; clear only on context change
  if [[ $ctx != $_jimple_pr_ctx ]]; then
    pr_num=""
    _jimple_pr_ctx=$ctx
  fi
  # Cancel the previous job so a stale result can't land in this prompt
  if [[ -n $_jimple_pr_fd ]]; then zle -F $_jimple_pr_fd; exec {_jimple_pr_fd}<&-; _jimple_pr_fd=; fi
  # Open a fd reading from the background command (ctx first, then result)
  exec {_jimple_pr_fd}< <(print -r -- "$ctx"; _get_pr_num)
  zle -F $_jimple_pr_fd _prompt_callback
}

_jimple_git() {
	# one git call in the common case: status fails outside a work tree,
	# so only then ask whether this is a bare repo
	local out
	out=$(_jimple_git_branch)
	if [[ -n $out ]]; then
		print -r -- "$out"
		return
	fi
	local bare
	bare=$(git rev-parse --is-bare-repository 2>/dev/null) || return
	[[ $bare == true ]] && _jimple_git_bare
}

VIRTUAL_ENV_DISABLE_PROMPT=1

# Sections are computed once per command in precmd. PROMPT itself holds no
# $(...), so zle reset-prompt (PR callback, window resize) starts no processes.
_jimple_s_start=$(_jimple_start)
_jimple_s_end=$(_jimple_end)   # keeps %(?...) so $? is read at draw time
_jimple_s_ssh= _jimple_s_wd= _jimple_s_git= _jimple_s_venv= _jimple_s_docker=

_jimple_precmd() {
	_jimple_s_ssh=$(_jimple_ssh)
	_jimple_s_wd=$(_jimple_wd)
	_jimple_s_git=$(_jimple_git)
	_jimple_s_venv=$(_jimple_venv)
	_jimple_s_docker=$(_jimple_docker)
	_jimple_gh_pr   # starts the async PR job
}
add-zsh-hook precmd _jimple_precmd

P=""
P+='${_jimple_s_start}'
P+='${_jimple_s_ssh}'
P+='${_jimple_s_wd}'
P+='${_jimple_s_git}'
P+='${pr_num}'
P+='${_jimple_s_venv}'
P+='${_jimple_s_docker}'
P+="${NEWLINE}"
P+='${_jimple_s_end}'
P+="%{$reset_color%}"

PROMPT=$P

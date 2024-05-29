#!/usr/bin/env zsh
# This allows expansion of the prompt.
# without it 
# `$USER >>` stays the same,
# but when set this become `jimmykeith >>`
setopt prompt_subst

# this allows the color expansions like `%{$fg[green]%}` 
autoload -Uz colors
colors

NEWLINE=$'\n'
DELIM=" %{$fg_bold[grey]%}|%{$reset_color%} "

declare -gA icons
icons=(
  APPLE_ICON                     '\uF179'             # 
  LINUX_RASPBIAN_ICON            '\uF315'             # 
  LINUX_UBUNTU_ICON              '\uF31b'             # 
  ARCH_ICON                      '\uE266'             # 
  SSH_ICON                       '\uF489'             # 

  HOME_ICON                      '\uF015'             # 
  HOME_SUB_ICON                  '\uF07C'             # 

  VCS_BRANCH_ICON                '\uF126'             # 
  VCS_UNTRACKED_ICON             '\uF059'             # 
  VCS_UNSTAGED_ICON              '\uF06A'             # 
  VCS_STAGED_ICON                '\uF055'             # 
  VCS_STASH_ICON                 '\uF01C'             # 
  VCS_INCOMING_CHANGES_ICON      '\u2193'             # ↓
  VCS_OUTGOING_CHANGES_ICON      '\u2191'             # ↑

  PYTHON_ICON                    '\UE73C'             # 
  NODE_ICON                      '\u2B22'             # ⬢

  MULTILINE_FIRST_PROMPT_PREFIX  '\u256D\U2500'       # ╭─
  MULTILINE_LAST_PROMPT_PREFIX   '\u2570\U2500'       # ╰─
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
    arm64 | armv7l )
      ret="arm"
      ;;
    x86_64 )
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

declare -A git_strings
git_strings=(
  STAGED    "%F{cyan}${icons[VCS_STAGED_ICON]}%f"
  UNSTAGED  "%F{yellow}${icons[VCS_UNSTAGED_ICON]}%f"
  UNTRACKED "%F{blue}${icons[VCS_UNTRACKED_ICON]}%f"
  STASH     "%F{white}${icons[VCS_STASH_ICON]}%f"
  AHEAD     "%F{magenta}${icons[VCS_OUTGOING_CHANGES_ICON]}%f"
  BEHIND    "%F{magenta}${icons[VCS_INCOMING_CHANGES_ICON]}%f"
)

_jimple_git() {
  local git_branch
  local git_status
  local num_stash 
  git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  # if fetching branch name failed, assume not a git repo
  [ $? -eq 0 ] || return

  git_status=$(git status --porcelain --show-stash --branch)
  num_stash=$(git stash list | wc -l)

  out=""

  if [ $num_stash -gt 0 ]; then out+=${git_strings[STASH]}; fi
  if rg -q "\[ahead [\d]+\]" <<< $git_status; then out+=${git_strings[AHEAD]}; fi
  if rg -q "\[behind [\d]+\]" <<< $git_status; then out+=${git_strings[BEHIND]}; fi
  if rg -q "^\?{2}" <<< $git_status; then out+=${git_strings[UNTRACKED]}; fi
  if rg -q "^[AMD]" <<< $git_status; then out+=${git_strings[STAGED]}; fi
  if rg -q "^.[AMD]" <<< $git_status; then out+=${git_strings[UNSTAGED]}; fi

  [[ $out == "" ]] || out=" ${out}"

  echo "${DELIM}%F{green}${icons[VCS_BRANCH_ICON]} ${git_branch}%f${out}"
}

VIRTUAL_ENV_DISABLE_PROMPT=1

P=""
P+='$(_jimple_start)'
P+='$(_jimple_ssh)'
P+='$(_jimple_wd)'
P+='$(_jimple_git)'
P+='$(_jimple_venv)'
P+='$(_jimple_arch)'
P+="${NEWLINE}"
P+='$(_jimple_end)'
P+="%{$reset_color%}"

PROMPT=$P

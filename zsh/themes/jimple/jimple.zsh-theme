#!/usr/bin/env zsh

NEWLINE=$'\n'
DELIM="%{$fg_bold[grey]%}|%{$reset_color%}"
PROMPT=""

declare -gA icons
icons=(
  APPLE_ICON                     '\uF179'             # 
  LINUX_RASPBIAN_ICON            '\uF315'             # 
  LINUX_UBUNTU_ICON              '\uF31b'             # 
  ARCH_ICON                      '\uE266'             # 

  HOME_ICON                      '\uF015'             # 
  HOME_SUB_ICON                  '\uF07C'             # 

  VCS_BRANCH_ICON                '\uF126'             # 
  VCS_UNTRACKED_ICON             '\uF059'             # 
  VCS_UNSTAGED_ICON              '\uF06A'             # 
  VCS_STAGED_ICON                '\uF055'             # 
  VCS_STASH_ICON                 '\uF01C'             # 

  PYTHON_ICON                    '\UE73C'             # 
  KUBERNETES_ICON                '\U2388'             # ⎈

  MULTILINE_FIRST_PROMPT_PREFIX  '\u256D\U2500'       # ╭─
  MULTILINE_LAST_PROMPT_PREFIX   '\u2570\U2500'       # ╰─
)

_jimple_start() {
  echo "%{$fg_bold[grey]%}$icons[MULTILINE_FIRST_PROMPT_PREFIX]%{$reset_color%} "
}
_jimple_end() {
  echo "%{$fg_bold[grey]%}$icons[MULTILINE_LAST_PROMPT_PREFIX]%{$reset_color%}%(?:%{$fg[green]%}❯:%{$fg[red]%}❯) "
}

_jimple_arch() {
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

  echo "${icons[ARCH_ICON]} $ret"
}

_jimple_k_ctx() {
  if ! command -v kubectl &> /dev/null; then
    return 0
  fi
  echo "%{$fg[yellow]%}${icons[KUBERNETES_ICON]} $(kubectl config current-context | sed 's/_/ /g' | awk '{print $(NF)}')%{$reset_color%} ${DELIM} "
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
  local version=$(python -V | awk '{ print $2 }')
  local machine=$(python -c "import platform; print(platform.machine())")
  echo "%F{magenta}${icons[PYTHON_ICON]} $venv($version)[$machine]%f ${DELIM} "
}

parse_git_dirty() {
  local git_status="$(git status 2> /dev/null)"
  local stash="$(git stash list 2> /dev/null)"
  out=""
  [[ -n $stash ]] && out+="%F{white}${icons[VCS_STASH_ICON]}%f"
  [[ "$git_status" =~ "Changes to be committed:" ]] && out+="%F{cyan}${icons[VCS_STAGED_ICON]}%f"
  [[ "$git_status" =~ "Changes not staged for commit:" ]] && out+="%F{yellow}${icons[VCS_UNSTAGED_ICON]}%f"
  [[ "$git_status" =~ "Untracked files:" ]] && out+="%F{blue}${icons[VCS_UNTRACKED_ICON]}%f"

  [[ -n $out ]] && out=" %{$reset_color%}$out%{$reset_color%}"
  echo $out
}

ZSH_THEME_GIT_PROMPT_PREFIX="${DELIM} %{$fg[green]%}%{$icons[VCS_BRANCH_ICON]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX=" ${DELIM} "
VIRTUAL_ENV_DISABLE_PROMPT=1

PROMPT+='$(_jimple_start)'
PROMPT+='$(_jimple_wd) '
PROMPT+='$(git_prompt_info)'
PROMPT+='$(_jimple_venv)'
PROMPT+='$(_jimple_k_ctx)'
PROMPT+='$(_jimple_arch)'
PROMPT+="${NEWLINE}"
PROMPT+='$(_jimple_end)'

#!/usr/bin/env zsh
setopt prompt_subst

autoload -Uz colors
colors

autoload -Uz vcs_info
precmd_functions+=vcs_info

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
  KUBERNETES_ICON                '\U2388'             # ⎈
  NODE_ICON                      '\u2B22'             # ⬢

  MULTILINE_FIRST_PROMPT_PREFIX  '\u256D\U2500'       # ╭─
  MULTILINE_LAST_PROMPT_PREFIX   '\u2570\U2500'       # ╰─
)

kshow() {
  if [[ -z $SHOW_KUBE_CTX ]]; then
    export SHOW_KUBE_CTX=1
  else
    unset SHOW_KUBE_CTX
  fi
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

_jimple_k_ctx() {
  if [[ $(tput cols) -lt 100 ]]; then
    ## don't show on terminals < 100 cols
    return
  fi
  if [[ -z $SHOW_KUBE_CTX ]]; then
    return
  fi
  if [[ ! -e "$HOME/.kube/config" ]]; then
    return 0
  fi
  local ctx=$(grep current-context "$HOME/.kube/config" | awk "{print $2}")
  local cluster=$(sed 's/_/ /g' <<< $ctx | awk '{print $NF}')
  echo "${DELIM}%{$fg[yellow]%}${icons[KUBERNETES_ICON]} $cluster%{$reset_color%}"
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

_jimple_node_version() {
  if which -s nvm > /dev/null; then
    local ls_default
    ls_default=$(nvm list default --no-colors)
    if [[ ${ls_default:0:2} == "->" ]]; then
      # using default version, so don't print node version
      return
    fi
    echo "${DELIM}%F{cyan}${icons[NODE_ICON]} $(nvm current)%f"
  fi
}

parse_git_dirty() {
  local git_status="$(git status 2> /dev/null)"
  local stash="$(git stash list 2> /dev/null)"
  out=""
  [[ "$git_status" =~ "branch is ahead" ]] && out+="%F{magenta}${icons[VCS_OUTGOING_CHANGES_ICON]}%f"
  [[ "$git_status" =~ "branch is behind" ]] && out+="%F{magenta}${icons[VCS_INCOMING_CHANGES_ICON]}%f"
  [[ -n $stash ]] && out+="%F{white}${icons[VCS_STASH_ICON]}%f"
  [[ "$git_status" =~ "Changes not staged for commit:" ]] && out+="%F{yellow}${icons[VCS_UNSTAGED_ICON]}%f"
  [[ "$git_status" =~ "Untracked files:" ]] && out+="%F{blue}${icons[VCS_UNTRACKED_ICON]}%f"

  [[ -n $out ]] && out=" %{$reset_color%}$out%{$reset_color%}"
  echo $out
}

# TODO: vcs info is the slowest part of this theme (at least in large repos). can we do this lazy?
zstyle ":vcs_info:*" enable git
zstyle ":vcs_info:git:*" check-for-changes true
zstyle ":vcs_info:git:*" formats "${DELIM}%F{green}$(print $icons[VCS_BRANCH_ICON]) %b%f%u%c"
zstyle ":vcs_info:git:*" stagedstr " %F{cyan}$(print $icons[VCS_STAGED_ICON])%f"
zstyle ":vcs_info:git:*" unstagedstr " %F{yellow}$(print $icons[VCS_UNSTAGED_ICON])%f"
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stashed

+vi-git-untracked() {
  [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] || return
  if (git status --porcelain 2> /dev/null | grep -q "?"); then
    hook_com[unstaged]+="%F{blue}$(print $icons[VCS_UNTRACKED_ICON])%f"
  fi
}

+vi-git-stashed() {
  [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] || return
  if [[ -n $(git stash list 2> /dev/null) ]]; then
    hook_com[unstaged]+="%F{white}$(print $icons[VCS_STASH_ICON])%f"
  fi
}

VIRTUAL_ENV_DISABLE_PROMPT=1

P=""
P+='$(_jimple_start)'
P+='$(_jimple_ssh)'
P+='$(_jimple_wd)'
P+='$vcs_info_msg_0_'
P+='$(_jimple_venv)'
P+='$(_jimple_node_version)'
P+='$(_jimple_k_ctx)'
P+='$(_jimple_arch)'
P+="${NEWLINE}"
P+='$(_jimple_end)'
P+="%{$reset_color%}"

PROMPT=$P

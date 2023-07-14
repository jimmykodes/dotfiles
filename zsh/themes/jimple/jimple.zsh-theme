#!/usr/bin/env zsh

NEWLINE=$'\n'

DIR='$(format_wd)'
PROMPT=""

declare -gA icons
icons=(
  APPLE_ICON                     '\uF179'               # 
  LINUX_RASPBIAN_ICON            '\uF315'               # 
  LINUX_UBUNTU_ICON              '\uF31b'$s             # 
  HOME_ICON                      '\uF015'$s             # 
  HOME_SUB_ICON                  '\uF07C'$s             # 
  VCS_UNTRACKED_ICON             '\uF059'$s             # 
  VCS_UNSTAGED_ICON              '\uF06A'$s             # 
  VCS_STAGED_ICON                '\uF055'$s             # 
  ARCH_ICON                      '\uE266'               # 
)

format_arch() {
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

append_prompt() {
  PROMPT+="%{$reset_color%}$1 %{$reset_color%}"
}

format_wd() {
  local wd="${PWD/$HOME/~}"
  local icon="HOME_SUB_ICON"

  [[ $wd == "~" ]] && icon="HOME_ICON"
  echo "${icons[$icon]} ${wd}"
}

parse_git_dirty() {
  git_status="$(git status 2> /dev/null)"
  out=""
  [[ "$git_status" =~ "Changes to be committed:" ]] && out="$out%F{green}${icons[VCS_STAGED_ICON]}%f"
  [[ "$git_status" =~ "Changes not staged for commit:" ]] && out="$out%F{yellow}${icons[VCS_UNSTAGED_ICON]}%f"
  [[ "$git_status" =~ "Untracked files:" ]] && out="$out%F{blue}${icons[VCS_UNTRACKED_ICON]}%f"
  [[ -n $out ]] && out=" %{$reset_color%}$out%{$reset_color%}"
  echo $out
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[grey]%}| %{$fg_bold[cyan]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[grey]%} |%{$reset_color%}"

append_prompt "%B%{$fg[grey]%}╭─%b"
append_prompt "%{$fg[blue]%}$DIR%{$reset_color%}"
append_prompt '$(git_prompt_info)'
append_prompt '$(format_arch)'
append_prompt "${NEWLINE}%{$fg_bold[grey]%}╰─"
append_prompt "%(?:%{$fg[green]%}❯:%{$fg[red]%}❯)"



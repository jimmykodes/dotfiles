# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

COMPLETION_WAITING_DOTS="true"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZSH_CUSTOM=${HOME}/Code/zsh-custom

plugins=(git common-aliases colorize gcloud kubectl)

# Fix "insecure directories and files" warning on terminal start
ZSH_DISABLE_COMPFIX=true

# Select tool to use for colorize plugin. options: pygmentize, chroma
ZSH_COLORIZE_TOOL=chroma
ZSH_COLORIZE_STYLE=dracula
ZSH_COLORIZE_CHROMA_FORMATTER=terminal256


source $ZSH/oh-my-zsh.sh

# Override alias rm='rm -i' from common-aliases plugin
unalias rm

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export XDG_CONFIG_HOME="$HOME/.config"

# Default location for appliation default credentials for google cloud services
# run `gcloud auth application-default login` to generate these credentials
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"

if [[ -n $(command -v watch-dot) ]]; then
    watch-dot check
fi

local zsyh=/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [[ -e "/usr/local/share/$zsyh" ]]; then
    source "/usr/local/share/${zsyh}"
  elif [[ -e "/opt/homebrew/share/${zsyh}" ]]; then
    source "/opt/homebrew/share/${zsyh}"
fi

# for signing git commits
export GPG_TTY=$TTY

if [[ -n $(command -v lvim) ]]; then
  export EDITOR=lvim
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/jimmykeith/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

fpath=(/opt/homebrew/share/zsh/site-functions $custom/completions $fpath)
# The following lines were added by compinstall
autoload -Uz compinit
compinit
# End of lines added by compinstall

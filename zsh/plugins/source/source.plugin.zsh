#!/bin/bash

# Filename of the file to source
: ${ZSH_SOURCE_FILE:=.source}

source_file() {
  if [[ ! -f "$ZSH_SOURCE_FILE" ]]; then
    # no file to source, return 
    return
  fi
  source $ZSH_SOURCE_FILE
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_file

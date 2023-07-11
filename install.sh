#!/bin/bash

set -e

# had to brew install coreutils for this to work on my mbp.
# can I automate that some other way? or do I need to use something
# other than realpath for this?
BASE_DIR=$(realpath "$(dirname "$0")")

colReset="\e[0m"
colRed="\e[31m"
colGreen="\e[32m"
colCyan="\e[36m"
colYellow="\e[1;33m"
colWhite="\e[1;37m"

colorize() {
  printf "%b%b%b\n" "$1" "$2" "$colReset"
}

success() {
  colorize "$colGreen" "$1"
}

info() {
  colorize "$colCyan" "$1"
}

warn() {
  colorize "$colYellow" "$1"
}

error() {
  colorize "$colRed" "$1"
}

line() {
  printf "%b" "$colWhite"
  for ((i=0; i< ${#1}; i++)); do
    printf "-"
  done
  printf "\n%b" "$colReset"
}

header() {
  line "$1"
  colorize "$colWhite" "$1"
  line "$1"
}

homebrew() {
  header "Checking Homebrew"
  if [ "$(uname)" != "Darwin" ]; then
    # todo: detect if we can install linux brew
    warn "Not a mac, cannot install Homebrew"
    return 0
  fi
  if command -v brew > /dev/null; then
    info "Homebrew already installed - updating"
    brew update
  else
    info "Installing Homebrew"
    # todo: maybe detect os and install linuxbrew, too?
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew bundle --file "$BASE_DIR/Brewfile"
}

lunarVim() {
  header "Checking LunarVim"
  if  ! command -v nvim > /dev/null ; then
    warn "Neovim not installed. Skipping LunarVim"
    return 0
  fi
  if [ "$(nvim --version | head -n 1 | grep -o "[0-9].[0-9]")" != "0.9" ]; then
    warn "Invalid version of neovim installed. Skipping LunarVim"
    return 0
  fi
  if command -v lvim > /dev/null; then
    info "LunarVim already installed"
  else
    info "Installing LunarVim"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/LunarVim/LunarVim/HEAD/utils/installer/install.sh)"
  fi
}

create_link() {
  local src=$1
  local dst=$2

  if [ -L "$HOME/$dst" ]; then
    # file is symlink
    if [ -e "$HOME/$dst" ]; then
      # link points to a valid file, lets see if it is the same file we are trying to link
      target=$(readlink "$HOME/$dst")
      if [ "$target" -ef "$BASE_DIR/$src" ]; then
        info "$HOME/$dst already linked"
        return 0
      else
        error "$HOME/$dst already linked to $target could not link"
        return 1
      fi
    else
      # link points to nothing, unlink it
      warn "$HOME/$dst is a symlink to a non-existent file, removing before linking"
      unlink "$HOME/$dst"
    fi
  else
    # not a link
    if [ -f "$HOME/$dst" ]; then
      # file is an actual file move file before creating symlink
      warn "$HOME/$dst already exists, moving to $HOME/$dst.bk before symlinking"
      mv "$HOME/$dst" "$HOME/$dst.bk"
    fi
  fi
  ln -s "$BASE_DIR/$src" "$HOME/$dst"
  success "$HOME/$dst linked to $BASE_DIR/$src"
}

symlinks() {
  header "Checking symlinks"
  files=("zsh/.p10k.zsh" "zsh/.zprofile" "zsh/.zshenv" "zsh/.zshrc" "config/wezterm/.wezterm.lua" "config/git/.global_gitignore")
  for f in "${files[@]}"
  do
    create_link "$f" "$(basename "$f")"
  done

  # handle more complicated symlinks
  mkdir -p "$HOME/.config/wezterm"
  create_link "config/wezterm/colors" ".config/wezterm/colors"

  mkdir -p "$HOME/.config/lvim"
  create_link "config/lvim/config.lua" ".config/lvim/config.lua"
}

git() {
  # todo: figure out how to handle the git config stuff, like creating signing key, ssh key, etc
  header "Checking git"
  warn "Unfortunately, git setup is still manual. This is a placeholder"
}

main() {
  homebrew
  lunarVim
  symlinks
  git
}

main

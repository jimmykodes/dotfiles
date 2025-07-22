#!/usr/bin/env bash

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
	for ((i = 0; i < ${#1}; i++)); do
		printf "-"
	done
	printf "\n%b" "$colReset"
}

header() {
	line "$1"
	colorize "$colWhite" "$1"
	line "$1"
}

homebrew_init() {
	header "Checking Homebrew"
	if [ "$(uname)" != "Darwin" ]; then
		# todo: detect if we can install linux brew
		warn "Not a mac, cannot install Homebrew"
		return 0
	fi
	if command -v brew >/dev/null; then
		info "Homebrew already installed - updating"
		brew update
	else
		info "Installing Homebrew"
		# todo: maybe detect os and install linuxbrew, too?
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
	brew bundle --file "$BASE_DIR/Brewfile"
}

k9sConf() {
	yq ".k9s.screenDumpDir = \"$HOME/.k9s/screendumps/\"" config/k9s/config.template.yaml >config/k9s/config.yaml
	success "Created k9s config"
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
	src="$(realpath "$BASE_DIR/$src")"
	dst="$HOME/$dst"
	ln -s "${src}" "${dst}"
	success "$dst linked to $src"
}

symlinks() {
	header "Creating config files"
	k9sConf
	header "Checking symlinks"
	local files=(
		"zsh/.zprofile"
		"zsh/.zshenv"
		"zsh/.zshrc"
		"config/wezterm/.wezterm.lua"
		"config/git/.global_gitignore"
		"config/git/.gitconfig.extras"
	)
	for f in "${files[@]}"; do
		create_link "$f" "$(basename "$f")"
	done
	local config_dir=(
		"git-hooks"
		"k9s"
	)
	for d in "${config_dir[@]}"; do
		mkdir -p "$HOME/.config/$(dirname "$d")"
		create_link "config/$d" ".config/$d"
	done
	local cloned_dirs=(
		"k9s/skins;;jimmykodes/colorschemes.k9s"
		"wezterm/colors;;jimmykodes/colorschemes.wezterm"
	)
	for item in "${cloned_dirs[@]}"; do
		# Split the item into path and repo using ';' as delimiter
		path="${item%%;;*}"
		repo="${item##*;;}"

		# Construct full path
		full_path="$HOME/.config/$path"

		# Check if directory doesn't exist
		if [ ! -d "$full_path" ]; then
			# Create parent directory if it doesn't exist
			mkdir -p "$(dirname "$full_path")"
			# Clone the repository
			git clone "https://github.com/$repo" "$full_path"
		fi
	done
}

git_init() {
	# todo: figure out how to handle the git config stuff, like creating signing key, ssh key, etc
	header "Checking git"
	warn "Unfortunately, git setup is still manual. This is a placeholder"
}

nvim_init() {
	header "Installing nvim"
	if [ -d "$HOME/.config/nvim" ]; then
		info "nvim already installed - skipping"
	else
		if [ -d "../neojim" ]; then
			info "neojim already cloned - skipping to link"
		else
			git clone https://github.com/jimmykodes/neojim ../neojim
		fi
		info "Linking neojim to nvim"
		create_link "../neojim" ".config/nvim"
	fi
}

all() {
	homebrew_init
	nvim_init
	symlinks
	git_init
}

main() {
	case $1 in
	brew | homebrew)
		homebrew_init
		;;
	vim)
		nvim_init
		;;
	sym | symlinks | links)
		symlinks
		;;
	git)
		git_init
		;;
	help | h)
		usage
		;;
	*)
		all
		;;
	esac
}

main "$@"

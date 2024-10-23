brew_init_86() {
	if [ -f /usr/local/bin/brew ]; then
		eval "$(/usr/local/bin/brew shellenv)"
	elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
}

brew_init() {
	if [ -f /opt/homebrew/bin/brew ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi
}

if [[ $(uname -m) == "x86_64" ]]; then
	brew_init
	brew_init_86
else
	brew_init_86
	brew_init
fi

if [[ -e ~/.zprofile.local ]]; then
	. ~/.zprofile.local
fi

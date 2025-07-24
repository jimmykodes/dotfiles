unsetopt beep

# enable vim mode
bindkey -v

# Functions
if [[ -d $DOTFILES/zsh/functions ]]; then
	for func in $DOTFILES/zsh/functions/*; do
		autoload -U $(basename $func)
	done
fi

plugins=(
	zlugin # must be first
	docker
	git
	go
	py_venv
	syntax_highlight
	auto_suggestions
)

for plugin in "${plugins[@]}"; do
	if [[ -f $DOTFILES/zsh/plugins/$plugin/init.zsh ]]; then
		source "$DOTFILES/zsh/plugins/$plugin/init.zsh"
	fi
	if [[ -d $DOTFILES/zsh/plugins/$plugin/completions ]]; then
		fpath=(
			"$DOTFILES/zsh/plugins/$plugin/completions"
			$fpath
		)
	fi
	if [[ -d "$DOTFILES/zsh/plugins/$plugin/bin" ]]; then
		prepend_path "$DOTFILES/zsh/plugins/$plugin/bin"
	fi
done

autoload -Uz compinit
compinit

# PATH
# prepend_path will only add to path if the dir exists
prepend_path $HOME/go/bin
prepend_path $HOME/.local/bin
prepend_path $DOTFILES/zsh/bin
prepend_path /usr/local/opt/openjdk@8/bin
prepend_path $HOME/.rd/bin

# raspberry pi
prepend_path /snap/bin
prepend_path /usr/local/go/bin

# gcloud
if [[ -n "$(command -v gcloud)" ]]; then
	if [[ -n "$(command -v python3.11)" ]]; then
		export CLOUDSDK_PYTHON="$(which python3.11)"
	elif [[ -n "$(command -v python3.9)" ]]; then
		export CLOUDSDK_PYTHON="$(which python3.9)"
	fi
	source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
	source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"
fi

[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# Load all zsh files in $DOTFILES dir
if [[ -d $DOTFILES/zsh ]]; then
	for file in $DOTFILES/zsh/*.zsh; do
		source $file
	done
fi

[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

source $HOME/go/src/github.com/jimmykodes/dotfiles/zsh/themes/jimple/init.zsh

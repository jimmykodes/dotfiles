# Change cursor shape for different vi modes
#  \e[0 q  - Default cursor (usually blinking block)
#  \e[1 q  - Blinking block
#  \e[2 q  - Steady block
#  \e[3 q  - Blinking underline
#  \e[4 q  - Steady underline
#  \e[5 q  - Blinking bar/beam (I-beam)
#  \e[6 q  - Steady bar/beam (I-beam)
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] ||
		[[ $1 = 'block' ]]; then
		echo -ne '\e[2 q' # normal mode
	elif [[ ${KEYMAP} == main ]] ||
		[[ ${KEYMAP} == viins ]] ||
		[[ ${KEYMAP} == '' ]] ||
		[[ $1 = 'beam' ]]; then
		echo -ne '\e[6 q' # insert mode
	fi
}

zle -N zle-keymap-select

# Set initial cursor
echo -ne '\e[6 q'

# Also handle when the shell starts
function zle-line-init {
	echo -ne '\e[6 q'
}

zle -N zle-line-init

autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd '^e' edit-command-line

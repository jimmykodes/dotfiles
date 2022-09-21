# ls Aliases
#######################################
platform=$(uname)
case $platform in
Darwin)
	alias ls='ls -GF'
	;;
Linux)
	alias ls='ls -F --color'
	;;
esac
alias la='ls -AF'
alias ll='ls -alFh'
alias l='ls -alFh'

# Other Aliases
######################################
alias X="arch -x86_64"
alias Xbrew="X /usr/local/bin/brew"
alias mod_host='sudo vim /etc/hosts'
alias flush_dns='pgrep mDNSResponder | xargs sudo kill'
alias insomnia='open -a Insomnia.app'

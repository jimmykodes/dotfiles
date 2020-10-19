# ls Aliases
#######################################
alias ls='ls -GF'
alias la='ls -AF'
alias ll='ls -alFh'
alias l='ls -alFh'

# Convenience Aliases
######################################
alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'
alias cat=ccat
alias less=cless
alias mod_host='sudo vim /etc/hosts'

# PyCharm Aliases
#######################################
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

# Functions
#######################################
cdt(){
    cd ${PWD//$1*/$1}
}

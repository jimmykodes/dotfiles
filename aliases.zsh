# ls Aliases
#######################################
alias ls='ls -F --color'
alias la='ls -AF'
alias ll='ls -alFh'
alias l='ls -alFh'

# Convenience Aliases
######################################
alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'

# PyCharm Aliases
#######################################
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

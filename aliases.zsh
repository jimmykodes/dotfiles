# ls Aliases
#######################################
alias ls='ls -GF'
alias la='ls -AF'
alias ll='ls -alFh'

# Docker Aliases
#######################################
alias django-bash='docker-compose exec django bash'
alias dcud='docker-compose up -d'
alias docker-shell-plus='docker-compose exec django python manage.py shell_plus'

# Convenience Aliases
######################################
alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'

# PostgreSQL Aliases
#######################################
alias pg_start='pg_ctl start'
alias pg_stop='pg_ctl stop'

# Image First Aliases
#######################################
alias runimagefirst='USE_POSTGRES=1 FILE_BASED_EMAIL=1 python manage.py runserver'
alias imagefirstshell='USE_POSTGRES=1 python manage.py shell_plus'

# PyCharm Aliases
#######################################
alias rmpycache='find . -name *.pyc -delete && echo pycache files removed'

# SSH aliases
#######################################
alias piconnect='ssh pi@192.168.1.148'
# password hint: Labyrinth

# V2 staging server connection
alias v2_connect='ssh ubuntu@134.158.74.47'

#mini ssh
alias mini_ssh='ssh minikeith@keith-mini.local'

#ubuntu machine
alias ubuntu_connect='ssh jimmy@192.168.1.145'
alias office_connect='ssh jimmy@205.173.78.34'

# CKC Blog Aliase
alias run_blog='bundle exec jekyll serve --future --drafts'

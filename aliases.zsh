# ls Aliases
#######################################
alias ls='ls -GF'
alias la='ls -AF'
alias ll='ls -alFh'
alias l='ls -alFh'

# Docker Aliases
#######################################
alias dcdb='docker-compose exec django bash'
alias dcd='docker-compose down'
alias dcr='docker-compose restart'
alias dcs='docker-compose stop'
alias dst='docker status'
alias dcud='docker-compose up -d'
alias dcsp='docker-compose exec django python manage.py shell_plus'
alias dcm='docker-compose exec django python manage.py migrate'
alias dcmm='docker-compose exec django python manage.py makemigrations'
alias dcl='docker-compose logs'
alias dclf='docker-compose logs -f'

# Convenience Aliases
######################################
alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'

# CKC Blog Aliase
alias run_blog='bundle exec jekyll serve --future --drafts'

# Image First Aliases
#######################################
alias runimagefirst='USE_POSTGRES=1 FILE_BASED_EMAIL=1 python manage.py runserver'
alias imagefirstshell='USE_POSTGRES=1 python manage.py shell_plus'

# PyCharm Aliases
#######################################
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

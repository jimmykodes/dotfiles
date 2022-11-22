alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

if [[ -d "/opt/homebrew" ]]; then
  alias python="/opt/homebrew/bin/python3"
else
  alias python="/usr/local/bin/python3"
fi

if [[ -f "/usr/local/bin/python2" ]]; then
  alias brewthon2='/usr/local/bin/python2'
fi

mkvenv() {
  python -m venv ${1:-venv}
}

acvenv() {
  source ${1:-venv}/bin/activate
}

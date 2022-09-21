alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

if [[ -d "/opt/homebrew" ]]; then
  alias brewthon="/opt/homebrew/bin/python3"
else
  alias brewthon="/usr/local/bin/python3"
fi

if [[ -f "/usr/local/bin/python2" ]]; then
  alias brewthon2='/usr/local/bin/python2'
fi

mkvenv() {
  python -m venv ${1:-venv}
}

acvenv() {
  source venv/bin/activate
}

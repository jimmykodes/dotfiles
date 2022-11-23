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
  local global=0
  local bn
  while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -g | --global )
    global=1
    ;;
  esac; shift; done
  if [[ "$1" == '--' ]]; then shift; fi
  if [[ $global != 0 ]]; then
    python -m venv "$venv/${1:-$(basename $PWD)}"
  else
    python -m venv ${1:-venv}
  fi
}

acvenv() {
  if [[ -e ${1:-venv}/bin/activate ]]; then
    . ${1:-venv}/bin/activate
  elif [[ -e $venv/${1:-$(basename $PWD)}/bin/activate ]]; then
    . $venv/${1:-$(basename $PWD)}/bin/activate
  else
    echo "could not determine venv to activate"
    return 1
  fi
}

rmvenv () {
  if [[ -e ${1:-venv}/bin/activate ]]; then
    rm -rf ${1:-venv}
  elif [[ -e $venv/${1:-$(basename $PWD)}/bin/activate ]]; then
    rm -rf $venv/${1:-$(basename $PWD)}
  else
    echo "could not determine venv to remove"
    return 1
  fi
}

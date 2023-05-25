alias pip-uninstall-all='pip freeze | xargs pip uninstall -y'
alias rmpc='find . -name *.pyc -delete && echo pycache files removed'

lsvenv() {
  local max=0
  local bn
  local count
  for i in $venv/*; do
    bn=$(basename $i)
    count=${#bn}
    if [[ $count -gt $max ]]; then
      max=$count
    fi
  done
  for i in $venv/*; do
    padding=$((max + 1))
    printf "%-${padding}s %s\n" "$(basename $i)" "$($i/bin/python -V | sed 's/Python //')"
  done
}

mkvenv() {
  local global=0
  local version=3

  while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  -g | --global )
    global=1
    ;;
  -v | --version )
    shift
    version=$1
    ;;
  esac; shift; done
  if [[ "$1" == '--' ]]; then shift; fi

  if [[ $global != 0 ]]; then
    eval "python$version -m venv $venv/${1:-$(basename $PWD)}"
  else
    eval "python$version -m venv ${1:-venv}"
  fi
}

acvenv() {
  if [[ -e ${1:-venv}/bin/activate ]]; then
    . ${1:-venv}/bin/activate
  elif [[ -e $venv/${1:-$(basename $PWD)}/bin/activate ]]; then
    . $venv/${1:-$(basename $PWD)}/bin/activate
  elif [[ -e .venv && -e $venv/$(cat .venv)/bin/activate ]]; then
    . $venv/$(cat .venv)/bin/activate
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

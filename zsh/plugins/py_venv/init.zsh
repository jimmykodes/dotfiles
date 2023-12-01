_VENV_DIR="$HOME/.venv"

ls_venv() {
  local venv=${VENV_DIR:-$_VENV_DIR}
  if [ -z "$venv" ]; then 
    echo "no venv defined"
    return 1
  fi
  if [ -z "$(ls $venv)" ]; then
    echo "venv is empty"
    return 1
  fi

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
    if [ -e $i/bin/python ]; then
      version=$($i/bin/python -V | sed 's/Python //')
    else
      version="N/A"
    fi
    padding=$((max + 1))
    printf "%-${padding}s %s\n" $(basename $i) $version
  done
}

acvenv() {
  if [[ -e .venv && -e $venv/$(cat .venv)/bin/activate ]]; then
    # if a .venv file exists, use its value as an override for the name of the venv
    # to activate from the $venv global location
    . "$venv/$(cat .venv)/bin/activate"
  elif [[ -e ${1:-venv}/bin/activate ]]; then
    # if a venv folder location is passed, look for it, and try to activate it
    # if one is not passed, use `./venv` as the folder name
    . "${1:-venv}/bin/activate"
  elif [[ -e $(project-root)/${1:-venv}/bin/activate ]]; then
    # check the project-root of the cwd for a venv and activate it if found
    . "$(project-root)/${1:-venv}/bin/activate"
  elif [[ -e $venv/${1:-$(basename "$PWD")}/bin/activate ]]; then
    # if a venv name is passed, look for it in the $venv global location
    # if one is not passed, use the basename of the cwd as the venv name
    . "$venv/${1:-$(basename "$PWD")}/bin/activate"
  else
    echo "could not determine venv to activate"
    return 1
  fi
}

mkvenv() {
  local global=0
  local version=3
  local no_activate=0

  while getopts 'ngv:' OPTION; do
    case "$OPTION" in
      g )
        global=1
        ;;
      v )
        version=$OPTARG
        ;;
      n )
        no_activate=1
        ;;
      * )
        echo "invalid opt: $OPTION"
        return 1
        ;;
    esac
  done
  shift "$((OPTIND - 1))"

  local envname="${1:-venv}"
  if [[ $global != 0 ]]; then
    local venv=${VENV_DIR:-$_VENV_DIR}
    envname="$venv/${1:-$(basename "$PWD")}"
  fi

  eval "python$version -m venv ${envname}" 
  if [[ $no_activate == 1 ]]; then
    return
  fi

  eval "acvenv $(basename "$envname")"
}

rmvenv() {
  if [[ -e "${1:-venv}/bin/activate" ]]; then
    rm -rf "${1:-venv}"
  elif [[ -e $venv/${1:-$(basename "$PWD")}/bin/activate ]]; then
    rm -rf "$venv/${1:-$(basename "$PWD")}"
  else
    echo "could not determine venv to remove"
    return 1
  fi
}

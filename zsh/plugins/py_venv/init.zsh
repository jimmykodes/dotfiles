_VENV_DIR="$HOME/.venv"

lsvenv() {
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
		if [ -e "$i/bin/python" ]; then
			version=$($i/bin/python -V | sed 's/Python //')
		else
			version="N/A"
		fi
		padding=$((max + 1))
		printf "%-${padding}s %s\n" $(basename $i) $version
	done
}

get_venv() {
	if [[ -n "$1" ]]; then
		if [[ "$1" == "venv" ]]; then
			echo "venv/bin/activate"
			return 0
		elif [[ -e "${_VENV_DIR}/${1}/bin/activate" ]]; then
			# the name of the venv to activate was passed. This will always be a global venv
			echo "${_VENV_DIR}/${1}/bin/activate"
			return 0
		else
			echo "venv '${1}' does not exist"
			return 1
		fi
	elif [[ -f .venv ]]; then
		# there is a .venv file in cwd
		local venv
		venv=$(
			lua <<EOF
local venv = dofile(".venv")
if type(venv) == "string" then
  print(venv)
elseif type(venv) == "table" then
  print(venv.get_venv({
    current = "$(git current-branch)", 
    main = "$(git main-branch)", 
    dev = "$(git dev-branch)"
  }))
else
  os.exit(1)
end
EOF
		)
		if [ $? -ne 0 ]; then
			echo "invalid .venv file"
			return 1
		fi

		if [[ -e "${_VENV_DIR}/${venv}/bin/activate" ]]; then
			echo "${_VENV_DIR}/${venv}/bin/activate"
			return 0
		else
			echo "venv ${venv} does not exist"
			return 1
		fi

	elif [[ -e venv/bin/activate ]]; then
		# there is a venv/ dir in cwd
		echo venv/bin/activate
	elif [[ -e "$(project-root)/venv/bin/activate" ]]; then
		# there is a venv dir in the root of the project
		echo "$(project-root)/venv/bin/activate"
	elif [[ -e "${_VENV_DIR}/$(basename "$PWD")/bin/activate" ]]; then
		# there is a global venv with the name of the current enclosing folder
		echo "${_VENV_DIR}/$(basename "$PWD")/bin/activate"
	elif [[ -e "${_VENV_DIR}/$(basename "$(project-root)")/bin/activate" ]]; then
		# there is a global venv with the name of the current project root
		echo "${_VENV_DIR}/$(basename "$(project-root)")/bin/activate"
	else
		echo "could not determine which venv to activate"
		return 1
	fi
}

acvenv() {
	local venv
	venv=$(get_venv "$@")
	. "$venv"
	if [[ -f .env ]]; then
		envup
	fi
}

mkvenv() {
	local global=0
	local version=3
	local no_activate=0

	while getopts 'ngv:' OPTION; do
		case "$OPTION" in
		g)
			global=1
			;;
		v)
			version=$OPTARG
			;;
		n)
			no_activate=1
			;;
		*)
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
	local venv
	venv=$(get_venv "$@")

	if [ $? -ne 0 ]; then
		echo "could not determine venv to remove"
		return 1
	fi

	local dir
	dir="$(dirname "$(dirname "$venv")")"

	printf "Delete venv '%s'? (y/N) " "$dir"
	read -r choice
	if [[ $choice =~ ^[Yy]$ ]]; then
		echo "Deleting"
		rm -rf "$dir"
	else
		echo "Skipping deletion"
	fi
}

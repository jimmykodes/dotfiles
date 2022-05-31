cdt() {
	cd ${PWD//$1*/$1}
}

uuid() {
	python -c "import uuid; print(uuid.uuid4())"
}

envup() {
	f=${1:-".env"}
	if [[ ! -e $f ]]; then
		echo "${f} could not be found"
		return
	fi
	export $(grep -v '^#' $f | xargs)
}

ipaddr() {
  echo $(ipconfig getifaddr en0)
}

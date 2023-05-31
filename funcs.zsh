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

dark() {
  isDark=$(osascript -e 'tell application "System Events" to tell appearance preferences to set darkMode to dark mode
darkMode as text')
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
  if [[ $isDark == "true" ]]; then
    echo -e "\033]50;SetProfile=Light Mode\a"
  else
    echo -e "\033]50;SetProfile=One Dark\a"
  fi
}

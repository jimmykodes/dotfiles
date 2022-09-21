alias python="python3"

mkvenv() {
  python -m venv ${1:-venv}
}

acvenv() {
  source venv/bin/activate
}

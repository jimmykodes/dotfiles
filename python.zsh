mkvenv() {
  python -m venv ${1:-venv}
}

acvenv() {
  source venv/bin/activate
}

#!/bin/bash

project-root() {
  local wd
  local i=0
  wd=$(pwd)
  while true; do
    i=$((i+1))
    if [ $i -gt 15 ]; then
      echo "max recursion depth reached"
      return 1
    fi
    if stat -q "$wd"/.git > /dev/null; then
      echo "$wd"
      break
    else
      wd=$(dirname "$wd")
    fi
  done
}

relpath() {
  local from=$1
  local to=$2
  local rel
  while [ "$to" != "$from" ]; do
    rel="$(basename "$from")/${rel}"
    from=$(dirname "$from")
  done
  echo "$rel"
}

tf-version() {
  if [[ -e ".tf-version" ]]; then
    cat .tf-version
  elif [[ -e $HOME/.tf-version ]]; then
    cat "$HOME/.tf-version"
  else
    echo "latest"
  fi
}

tf() {
  local projectRoot
  local relativePath
  projectRoot=$(project-root)
  relativePath=$(relpath "$PWD" "$projectRoot")
  local cmd="docker run -it --rm -v $projectRoot:/app -v $HOME/.config/gcloud/:/root/.config/gcloud"
  if [[ -d ../shared ]]; then
    cmd="${cmd} -v $PWD/../shared:/shared"
  fi
  if [[ -d ../shared-iam ]]; then
    cmd="${cmd} -v $PWD/../shared-iam:/shared-iam"
  fi
  eval "${cmd} --platform linux/amd64 -w /app/${relativePath} hashicorp/terraform:$(tf-version) $*"
}

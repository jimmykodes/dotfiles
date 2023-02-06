tf-version() {
  if [[ -e ".tf-version" ]]; then
    cat .tf-version
  elif [[ -e $HOME/.tf-version ]]; then
    cat $HOME/.tf-version
  else
    echo "latest"
  fi
}

tf() {

  local cmd="docker run -it --rm -v $PWD:/app -v $HOME/.config/gcloud/:/root/.config/gcloud"
  if [[ -d ../shared ]]; then
    cmd="${cmd} -v $PWD/../shared:/shared"
  fi
  if [[ -d ../shared-iam ]]; then
    cmd="${cmd} -v $PWD/../shared-iam:/shared-iam"
  fi
  eval "${cmd} --platform linux/amd64 -w /app hashicorp/terraform:$(tf-version) $@"
}

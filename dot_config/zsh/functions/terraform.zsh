_tf_run() {
  local action=$1 stack=$2 environment=$3
  if [[ $# -ne 3 ]]; then
    echo "Usage: tf_$action STACK ENVIRONMENT"
    return 1
  fi

  (
    cd "$stack" || { echo "Error: Directory $stack not found"; return 1; }
    if [[ "$action" == "init" ]]; then
      terraform init -backend-config=environments/${environment}.s3.tfbackend -var-file=environments/${environment}.tfvars -reconfigure
    else
      terraform "$action" -var-file=environments/${environment}.tfvars
    fi
  )
}

tf_init()    { _tf_run init    "$@" }
tf_plan()    { _tf_run plan    "$@" }
tf_apply()   { _tf_run apply   "$@" }
tf_destroy() { _tf_run destroy "$@" }

clean_terraform() {
  read "confirm?Are you sure you want to delete all .terraform.lock.hcl files and .terraform directories? (y/n) "
  if [[ "$confirm" == "y" ]]; then
    find . -name '.terraform.lock.hcl' -exec rm -f {} \;
    find . -type d -name '.terraform' -exec rm -rf {} +
    echo "Terraform files cleaned."
  else
    echo "Clean operation aborted."
  fi
}

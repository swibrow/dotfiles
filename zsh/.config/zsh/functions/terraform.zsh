tf_init() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: tf_init STACK ENVIRONMENT"
    return 1
  fi
  
  local STACK=$1
  local ENVIRONMENT=$2
  
  (
    cd "$STACK" || { echo "Error: Directory $STACK not found"; return 1; }
    terraform init -backend-config=environments/${ENVIRONMENT}.s3.tfbackend -var-file=environments/${ENVIRONMENT}.tfvars -reconfigure
  )
}

tf_plan() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: tf_plan STACK ENVIRONMENT"
    return 1
  fi
  
  local STACK=$1
  local ENVIRONMENT=$2
  
  (
    cd "$STACK" || { echo "Error: Directory $STACK not found"; return 1; }
    terraform plan -var-file=environments/${ENVIRONMENT}.tfvars
  )
}

tf_apply() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: tf_apply STACK ENVIRONMENT"
    return 1
  fi
  
  local STACK=$1
  local ENVIRONMENT=$2
  
  (
    cd "$STACK" || { echo "Error: Directory $STACK not found"; return 1; }
    terraform apply -var-file=environments/${ENVIRONMENT}.tfvars
  )
}

tf_destroy() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: tf_destroy STACK ENVIRONMENT"
    return 1
  fi
  
  local STACK=$1
  local ENVIRONMENT=$2
  
  (
    cd "$STACK" || { echo "Error: Directory $STACK not found"; return 1; }
    terraform destroy -var-file=environments/${ENVIRONMENT}.tfvars
  )
}

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


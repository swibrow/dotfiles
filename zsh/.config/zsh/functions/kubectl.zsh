kclean() {
  kubectl delete pod --field-selector=status.phase=${1:-Succeeded} --all-namespaces
}

kpodbynode() {
  kubectl get pods -A -owide --field-selector=spec.nodeName="${1}",status.phase=Running
}

kpodbylabel() {
  kubectl get pods -A -owide --selector="${1}"
}

kremovefinalizers() {
  if [ -z "${1}" ] || [ -z "${2}" ]; then
    echo "Please provide a resource type and name."
    return 1
  fi
  kubectl patch $1 $2 -p '{"metadata":{"finalizers":[]}}' --type=merge
}

kdelete_namespaces_with_prefix() {
    local prefix=$1
    if [ -z "$prefix" ]; then
        echo "Usage: delete_namespaces_with_prefix <prefix>"
        return 1
    fi

    namespaces=$(kubectl get namespaces -o json | \
    jq -r '.items[].metadata.name | select(startswith("'"$prefix"'"))')

    if [ -z "$namespaces" ]; then
        echo "No namespaces found with prefix: $prefix"
        return 0
    fi

    echo "The following namespaces will be deleted:"
    echo "$namespaces"

    echo -n "Are you sure you want to delete these namespaces? (y/n): "
    read confirm
    if [[ $confirm != "y" ]]; then
        echo "Aborted."
        return 0
    fi

    echo "$namespaces" | xargs -r kubectl delete namespace
}


kdelete_empty_namespaces() {
  local auto_delete=false
  if [[ "$1" == "--yes" || "$1" == "-y" ]]; then
    auto_delete=true
  fi

  echo "🔍 Scanning for empty namespaces..."

  # Get all namespaces (excluding kube-system, default, kube-public, and kube-node-lease)
  local namespaces=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | grep -v -E '^(kube-system|default|kube-public|kube-node-lease)$')

  local empty_count=0
  local deleted=()

  for ns in ${(f)namespaces}; do
    echo "📋 Checking namespace: $ns"

    # Check if there are any resources in the namespace using kubectl get all
    local resources=$(kubectl get all -n $ns 2>/dev/null)
    local resource_count=$(echo "$resources" | grep -v "No resources found" | wc -l)

    # Check specifically for any resources not caught by 'kubectl get all'
    # Some resources aren't included in 'get all' like secrets, configmaps, etc.
    local additional_types=(
      # "configmaps"
      # "secrets"
      "persistentvolumeclaims"
      # "roles"
      # "rolebindings"
      # "serviceaccounts"
    )

    local has_resources=false
    if [[ $resource_count -gt 1 ]]; then  # Count > 1 because the header line is counted
      has_resources=true
      echo "  - Found resources via 'kubectl get all'"
    else
      # Check additional resource types
      for resource in $additional_types; do
        local count=$(kubectl get $resource -n $ns -o name 2>/dev/null | wc -l)
        if [[ $count -gt 0 ]]; then
          has_resources=true
          echo "  - Found $count $resource"
          break
        fi
      done
    fi

    if [[ $has_resources == "false" ]]; then
      echo "  ✅ Namespace '$ns' is empty"

      # Auto-delete if --yes flag is provided, otherwise ask for confirmation
      if [[ $auto_delete == true ]]; then
        echo "  🗑️  Deleting empty namespace: $ns"
        kubectl delete namespace $ns
        deleted+=($ns)
        ((empty_count++))
      else
        # Ask for confirmation before deleting
        read -q "REPLY?  🗑️  Delete namespace '$ns'? (y/n) "
        echo ""

        if [[ $REPLY =~ ^[Yy]$ ]]; then
          echo "  🗑️  Deleting empty namespace: $ns"
          kubectl delete namespace $ns
          deleted+=($ns)
          ((empty_count++))
        else
          echo "  ⏭️  Skipping namespace: $ns"
        fi
      fi
    else
      echo "  ⏭️  Namespace '$ns' has resources, skipping"
    fi
  done

  # Summary
  echo "\n📊 Summary:"
  echo "🔍 Found $empty_count empty namespaces"

  if [[ ${#deleted[@]} -gt 0 ]]; then
    echo "🗑️  Deleted namespaces:"
    for ns in $deleted; do
      echo "  - $ns"
    done
  else
    echo "ℹ️  No namespaces were deleted"
  fi
}

inline_kubectl_editor() {
  local action=${1:-create}
  local tmpfile=$(mktemp)

  ${EDITOR:-vim} ${tmpfile}

  kubectl ${action} -f ${tmpfile}

  rm ${tmpfile}
}
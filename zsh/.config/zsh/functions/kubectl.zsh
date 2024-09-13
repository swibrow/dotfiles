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

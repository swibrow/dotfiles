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
  kubectl patch "${1} ${2}" -p '{"metadata":{"finalizers":[]}}' --type=merge
}

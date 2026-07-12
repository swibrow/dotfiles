#!/usr/bin/env zsh

url="${1:-}"

if [[ -z "$url" ]]; then
  echo "Usage: browser-open <url>" >&2
  exit 1
fi

work_dirs=(dnd-it tx-pts-dai tx-group-adm 20minuten)

cwd="$(pwd)"
profile="personal"

if [[ "$url" =~ (signin\.aws\.amazon\.com|console\.aws\.amazon\.com|awsapps\.com/start|sso\..*\.amazonaws\.com) ]]; then
  profile="aws"
else
  for d in "${work_dirs[@]}"; do
    if [[ "$cwd" == *"/dev/${d}"* ]]; then
      profile="work"
      break
    fi
  done
fi

case "$profile" in
  work)
    open -na "Google Chrome" --args --profile-directory="Profile 1" "$url"
    ;;
  personal)
    open -na "Google Chrome" --args --profile-directory="Profile 6" "$url"
    ;;
  aws)
    open -a "Zen" "$url"
    ;;
esac

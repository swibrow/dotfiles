#!/usr/bin/env zsh

set -euo pipefail

vault="${1:-Dev}"

read -r "title?Secret title: "
read -r "field_name?Field name [API Key]: "
field_name="${field_name:-API Key}"
read -rs "value?Secret value: "
echo

if [[ -z "$title" || -z "$value" ]]; then
  echo "Error: title and value are required" >&2
  exit 1
fi

template=$(cat <<EOF
{
  "title": "${title}",
  "note": "",
  "sections": [{
    "section_name": "Secrets",
    "fields": [{
      "field_name": "${field_name}",
      "field_type": "hidden",
      "value": "${value}"
    }]
  }]
}
EOF
)

echo "$template" | pass-cli item create custom --vault-name "$vault" --from-template -

echo "Created '${title}' in vault '${vault}'"
echo ""
echo "Mise usage:"
echo "  ${title} = \"{{exec(command='pass-cli item view --vault-name ${vault} --item-title ${title} --field \\\"${field_name}\\\"')}}\""

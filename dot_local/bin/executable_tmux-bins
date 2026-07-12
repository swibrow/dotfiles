#!/usr/bin/env zsh
# Fuzzy-pick an executable from $PATH and run it in the popup.

selected=$(
  print -rl -- ${(s.:.)PATH} \
    | xargs -I{} find {} -maxdepth 1 \( -type f -o -type l \) -perm -u+x 2>/dev/null \
    | xargs -n1 basename 2>/dev/null \
    | sort -u \
    | fzf --reverse --prompt='run> '
)

[[ -z "$selected" ]] && exit 0

exec zsh -ic "$selected"

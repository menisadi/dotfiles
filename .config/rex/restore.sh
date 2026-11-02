#!/bin/zsh
# Restore Rex.app appearance settings from rex-settings.plist. Quit Rex.app first.
set -euo pipefail

domain=com.superlogical.rex
src="${0:A:h}/rex-settings.plist"

[[ -f "$src" ]] || { echo "missing $src" >&2; exit 1; }
if pgrep -x Rex >/dev/null; then
  echo "Quit Rex.app first, it would overwrite the restored settings." >&2
  exit 1
fi

for key in $(plutil -convert json -o - "$src" | python3 -c 'import json,sys; print(*json.load(sys.stdin))'); do
  type=$(plutil -type "${key//./\\.}" "$src")
  if [[ $type == array ]]; then
    items=("${(@f)$(plutil -extract "${key//./\\.}" json -o - "$src" | python3 -c 'import json,sys; print(*json.load(sys.stdin), sep="\n")')}")
    defaults write "$domain" "$key" -array "${items[@]}"
    echo "restored $key"
    continue
  fi
  value=$(plutil -extract "${key//./\\.}" raw -o - "$src")
  case "$type" in
    string) defaults write "$domain" "$key" -string "$value" ;;
    integer) defaults write "$domain" "$key" -int "$value" ;;
    float) defaults write "$domain" "$key" -float "$value" ;;
    bool) defaults write "$domain" "$key" -bool "$value" ;;
    data) defaults write "$domain" "$key" -data "$(print -rn -- "$value" | base64 -d | xxd -p | tr -d '\n')" ;;
  esac
  echo "restored $key"
done

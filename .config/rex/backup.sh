#!/bin/zsh
# Export Rex.app appearance settings (font, size, themes) to rex-settings.plist.
set -euo pipefail

domain=com.superlogical.rex
out="${0:A:h}/rex-settings.plist"

src=$(mktemp)
trap 'rm -f "$src"' EXIT
defaults export "$domain" "$src"

plutil -create xml1 "$out"
for key in Workspace.terminalFontName Workspace.terminalFontPointSize \
    Workspace.darkThemeID Workspace.lightThemeID Workspace.customThemes \
    Workspace.interfaceStyle Workspace.paneDensity Workspace.inactivePaneFadeMode \
    Workspace.terminalSmoothScrolling Workspace.terminalUsesDisplayP3 \
    Workspace.terminalUseThemePalette Workspace.terminalFallbackFontNames \
    Workspace.terminalOptionKeyBehavior; do
  type=$(plutil -type "${key//./\\.}" "$src" 2>/dev/null || true)
  case "$type" in
    string) plutil -insert "${key//./\\.}" -string "$(plutil -extract "${key//./\\.}" raw -o - "$src")" "$out" ;;
    integer) plutil -insert "${key//./\\.}" -integer "$(plutil -extract "${key//./\\.}" raw -o - "$src")" "$out" ;;
    float) plutil -insert "${key//./\\.}" -float "$(plutil -extract "${key//./\\.}" raw -o - "$src")" "$out" ;;
    bool) plutil -insert "${key//./\\.}" -bool "$(plutil -extract "${key//./\\.}" raw -o - "$src")" "$out" ;;
    array) plutil -insert "${key//./\\.}" -json "$(plutil -extract "${key//./\\.}" json -o - "$src")" "$out" ;;
    data) plutil -insert "${key//./\\.}" -data "$(plutil -extract "${key//./\\.}" raw -o - "$src")" "$out" ;;
    *) echo "skipped $key (not set)" >&2 ;;
  esac
done
echo "wrote $out"

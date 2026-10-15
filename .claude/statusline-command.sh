#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
rate=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
vim=$(echo "$input" | jq -r '.vim.mode // empty')

mode_part=""
case "$vim" in
  INSERT) mode_part=$'\e[1;30;42m INSERT \e[0m' ;;
  NORMAL) mode_part=$'\e[1;30;43m NORMAL \e[0m' ;;
esac

branch=""
if [ -n "$cwd" ]; then
  branch=$(GIT_DIR="$cwd/.git" GIT_WORK_TREE="$cwd" git --no-optional-locks -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ "${#branch}" -gt 30 ]; then
    branch="${branch:0:30}…"
  fi
fi

rate_part=""
[ -n "$rate" ] && rate_part="rate: $(printf '%.0f' "$rate")%"

ctx_part=""
[ -n "$ctx" ] && ctx_part="ctx: $(printf '%.0f' "$ctx")%"

parts=()
[ -n "$mode_part" ] && parts+=("$mode_part")
if [ -n "$model" ]; then
  case "$(echo "$model" | tr '[:upper:]' '[:lower:]')" in
    *haiku*)  model=$'\e[36m'"$model"$'\e[0m' ;;
    *sonnet*) model=$'\e[94m'"$model"$'\e[0m' ;;
    *opus*)   model=$'\e[38;5;208m'"$model"$'\e[0m' ;;
    *fable*)  model=$'\e[1;91m'"$model"$'\e[0m' ;;
  esac
  parts+=("$model")
fi
[ -n "$branch" ] && parts+=("$branch")
[ -n "$rate_part" ] && parts+=("$rate_part")
[ -n "$ctx_part" ] && parts+=("$ctx_part")

out=""
for i in "${!parts[@]}"; do
  if [ "$i" -eq 0 ]; then
    out="${parts[$i]}"
  else
    out="$out | ${parts[$i]}"
  fi
done

echo "$out"

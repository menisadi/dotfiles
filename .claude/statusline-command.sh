#!/usr/bin/env bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')
rate=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

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
[ -n "$branch" ] && parts+=("$branch")
[ -n "$model" ] && parts+=("$model")
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

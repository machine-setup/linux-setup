#!/bin/bash
# Test: echo '{"model":{"display_name":"Claude Sonnet 4.6"},"context_window":{"used_percentage":42},"cost":{"total_cost_usd":0.0234}}' | bash ~/.claude/statusline-command.sh

# Claude Code pipes a JSON object to this script on every update.
# We read it all at once from stdin into a variable.
input=$(cat)

# --- Extract ALL fields in a single python3 invocation ---
# Outputs four lines: model, used_percentage, cost, color
parsed=$(echo "$input" | python3 -c "
import sys, json
d = json.load(sys.stdin)
model = d.get('model', {}).get('display_name', '')
used  = d.get('context_window', {}).get('used_percentage')
cost  = d.get('cost', {}).get('total_cost_usd')

# Pick ANSI color based on context usage
if used is None:
    color = ''
elif used < 50: color = '\033[0;32m'   # green
elif used < 80: color = '\033[0;33m'   # yellow
else:           color = '\033[0;31m'   # red

print(model)
print(used  if used  is not None else '')
print(f'\${cost:.4f}' if cost is not None else '')
print(color)
")

# --- Parse the four output lines ---
model=$(sed -n '1p' <<< "$parsed")
used=$(sed -n '2p'  <<< "$parsed")
cost=$(sed -n '3p'  <<< "$parsed")
color=$(sed -n '4p' <<< "$parsed")

RESET='\033[0m'
output="$model"

# --- Context bar ---
if [ -n "$used" ]; then
    bar_width=20
    filled=$(python3 -c "print(round($used * $bar_width / 100))")
    empty=$((bar_width - filled))

    bar="["
    for ((i=0; i<filled; i++)); do bar+="="; done
    for ((i=0; i<empty; i++)); do bar+=" "; done
    bar+="]"

    pct=$(printf "%.0f" "$used")
    output="$output | Context: ${color}${bar} ${pct}%${RESET}"
fi

# --- Cost ---
if [ -n "$cost" ]; then
    output="$output | Cost: $cost"
fi

echo -e "$output"

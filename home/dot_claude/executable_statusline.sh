#!/bin/bash
# Extract all fields in a single jq call, joined by the ASCII unit separator
# (a non-whitespace IFS keeps empty fields in place)
IFS=$'\x1f' read -r MODEL PROJECT_DIR CTX_PCT COST FIVE_H FIVE_H_RESET SEVEN_D < <(
    jq -r '[
        .model.display_name // "",
        .workspace.project_dir // .workspace.current_dir // "",
        .context_window.used_percentage // "",
        .cost.total_cost_usd // 0,
        .rate_limits.five_hour.used_percentage // "",
        .rate_limits.five_hour.resets_at // "",
        .rate_limits.seven_day.used_percentage // ""
    ] | map(tostring) | join("\u001f")'
)

PROJECT_NAME="${PROJECT_DIR##*/}"
CTX_PCT="${CTX_PCT%%.*}"

MODEL_DISP="${MODEL:--}"

BRANCH_DISP="-"
if git -C "$PROJECT_DIR" rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null)
    [ -n "$BRANCH" ] && BRANCH_DISP="$BRANCH"
fi

if [ -n "$CTX_PCT" ]; then
    CTX_DISP="${CTX_PCT}%"
else
    CTX_DISP="-"
fi

COST_DISP=$(awk -v c="$COST" 'BEGIN { printf "$%.2f", c }')

if [ -n "$FIVE_H" ]; then
    FIVE_H_DISP="$(printf '%.0f' "$FIVE_H")%"
else
    FIVE_H_DISP="-"
fi

RESET_DISP="--"
if [ -n "$FIVE_H_RESET" ]; then
    DIFF=$((FIVE_H_RESET - $(date +%s)))
    if [ "$DIFF" -gt 0 ]; then
        H=$((DIFF / 3600))
        M=$(((DIFF % 3600) / 60))
        if [ "$H" -gt 0 ]; then
            RESET_DISP="${H}h${M}m"
        else
            RESET_DISP="${M}m"
        fi
    fi
fi

if [ -n "$SEVEN_D" ]; then
    SEVEN_D_DISP="$(printf '%.0f' "$SEVEN_D")%"
else
    SEVEN_D_DISP="-"
fi

echo "🤖 $MODEL_DISP | 📁 $PROJECT_NAME | 🌿 $BRANCH_DISP | 🧠 $CTX_DISP | 💰 $COST_DISP | 5h: $FIVE_H_DISP ↻$RESET_DISP | 7d: $SEVEN_D_DISP"

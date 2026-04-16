#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // empty')

PROJECT_DIR=$(echo "$input" | jq -r '.workspace.project_dir // .workspace.current_dir')
PROJECT_NAME="${PROJECT_DIR##*/}"

CTX_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // empty' | cut -d. -f1)

COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
FIVE_H_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
SEVEN_D=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

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

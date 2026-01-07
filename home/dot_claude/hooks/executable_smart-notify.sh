#!/bin/bash
# Smart notification script for Claude Code hooks
# Plays sound if volume > 0, otherwise shows macOS notification

# Read JSON input from stdin (Claude Code hooks specification)
input_json=$(cat)

# Get volume and mute state
volume=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo "50")
muted=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null || echo "false")

# Extract info from JSON using jq
cwd=$(echo "$input_json" | jq -r '.cwd // empty' 2>/dev/null)
hook_message=$(echo "$input_json" | jq -r '.message // empty' 2>/dev/null)

# Get project name from cwd
if [ -n "$cwd" ]; then
    project=$(basename "$cwd")
else
    project="Claude Code"
fi

# Build notification message
# For Notification events, use the message field; for Stop events, use default
if [ -n "$hook_message" ]; then
    message="$hook_message"
else
    message="Ready for input"
fi

# If muted or volume is 0, show notification; otherwise play sound
if [ "$muted" = "true" ] || [ "$volume" -eq 0 ]; then
    osascript -e "display notification \"$message\" with title \"Claude Code\" subtitle \"$project\""
else
    afplay /System/Library/Sounds/Funk.aiff
fi

exit 0

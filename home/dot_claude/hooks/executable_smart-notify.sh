#!/bin/bash
# Smart notification script for Claude Code hooks
# Plays sound if volume > 0, otherwise shows macOS notification

# Read JSON input from stdin (Claude Code hooks specification)
input_json=$(cat)

# Get volume and mute state
volume=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null || echo "50")
muted=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null || echo "false")

# Check if Google Meet is active in Chrome
in_meet=false
if pgrep -q "Google Chrome"; then
    meet_check=$(osascript -e '
        tell application "Google Chrome"
            repeat with w in windows
                repeat with t in tabs of w
                    if URL of t contains "meet.google.com" then
                        return "true"
                    end if
                end repeat
            end repeat
        end tell
        return "false"
    ' 2>/dev/null)
    if [ "$meet_check" = "true" ]; then
        in_meet=true
    fi
fi

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

# If in Meet, muted, or volume is 0, show notification; otherwise play sound
if [ "$in_meet" = "true" ] || [ "$muted" = "true" ] || [ "$volume" -eq 0 ]; then
    osascript -e 'on run argv' \
              -e 'display notification (item 1 of argv) with title "Claude Code" subtitle (item 2 of argv)' \
              -e 'end run' \
              -- "$message" "$project"
else
    afplay /System/Library/Sounds/Funk.aiff
fi

exit 0

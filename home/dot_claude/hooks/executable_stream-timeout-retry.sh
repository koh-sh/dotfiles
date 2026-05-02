#!/bin/bash
# Stop hook: auto-retry on "API Error: Stream idle timeout - partial response received".
# Workaround for https://github.com/anthropics/claude-code/issues/46987

set -u

MAX_RETRIES=3
STATE_DIR="${HOME}/.claude/state/stream-retry"

input=$(cat)

stop_hook_active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false')
if [ "$stop_hook_active" = "true" ]; then
  exit 0
fi

session_id=$(printf '%s' "$input" | jq -r '.session_id // empty')
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')

if [ -z "$session_id" ] || [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
  exit 0
fi

mkdir -p "$STATE_DIR"
state_file="${STATE_DIR}/${session_id}.count"

last=$(jq -rs 'map(select(.type == "assistant" and ((.isSidechain // false) | not))) | last' "$transcript_path" 2>/dev/null)
is_error=$(printf '%s' "$last" | jq -r '.isApiErrorMessage // false')
last_text=$(printf '%s' "$last" | jq -r '.message.content[0].text // ""')

# Reset counter and exit unless the latest assistant turn ended with a Stream idle timeout error.
# (System meta entries like turn_duration are appended after the error, so we cannot rely on the very last line.)
if [ "$is_error" != "true" ] || ! printf '%s' "$last_text" | grep -q "Stream idle timeout"; then
  rm -f "$state_file"
  exit 0
fi

count=$(cat "$state_file" 2>/dev/null || echo 0)
case "$count" in ''|*[!0-9]*) count=0 ;; esac
count=$((count + 1))

if [ "$count" -gt "$MAX_RETRIES" ]; then
  rm -f "$state_file"
  exit 0
fi

printf '%s' "$count" > "$state_file"

jq -nc --arg n "$count" --arg max "$MAX_RETRIES" '{
  decision: "block",
  reason: ("Previous turn was aborted by Stream idle timeout (auto-retry " + $n + "/" + $max + "). Retry the last operation. Per Stream Timeout Prevention guidelines: do one task at a time, keep tool outputs small (use --include / -l flags), and write files in chunks of <=150 lines.")
}'

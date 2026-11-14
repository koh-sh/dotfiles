#!/bin/bash
# Tracks which parts of this project's Claude Code sessions harness-review has
# learned from. The state lives next to the transcripts, in
# ~/.claude/projects/<project>/harness-review/.
#
#   sessions.sh collect <current session id>
#       Condenses the unreviewed part of the project's other sessions, newest
#       first, into the dialogue file and prints its path.
#   sessions.sh mark <current session id>
#       Records the sessions behind the dialogue file as reviewed, including
#       the older ones left out of it.

# Stop adding sessions before the dialogue grows past this size; older
# sessions are left out.
MAX_BYTES=200000
# How many already reviewed dialogue entries to show before the new ones.
CONTEXT_ENTRIES=20

if [ $# -ne 2 ] || { [ "$1" != collect ] && [ "$1" != mark ]; }; then
    echo "usage: $0 collect|mark <current session id>" >&2
    exit 2
fi

# The current session's transcript tells which project directory to use.
current=$2
current_transcript=$(find ~/.claude/projects -maxdepth 2 -name "$current.jsonl" | head -n 1)
if [ -z "$current_transcript" ]; then
    echo "no transcript found for session $current" >&2
    exit 1
fi
transcripts=$(dirname "$current_transcript")
state="$transcripts/harness-review"
dialogue="$state/dialogue.md"
pending="$state/dialogue.pending"

if [ "$1" = mark ]; then
    while read -r id lines; do
        echo "$lines" >"$state/$id.offset"
    done <"$pending"
    exit 0
fi

scripts=$(dirname "$0")
mkdir -p "$state"
: >"$dialogue"
: >"$pending"
full=no
left_out=0

# Newest first. Once the dialogue is full, the older sessions are recorded as
# reviewed without being shown, so later runs do not fall back on stale
# sessions.
while IFS= read -r transcript; do
    id=$(basename "$transcript" .jsonl)
    [ "$id" = "$current" ] && continue
    done_lines=$(cat "$state/$id.offset" 2>/dev/null || echo 0)
    total_lines=$(wc -l <"$transcript" | tr -d ' ')
    [ "$total_lines" -gt "$done_lines" ] || continue
    echo "$id $total_lines" >>"$pending"
    if [ "$full" = yes ]; then
        left_out=$((left_out + 1))
        continue
    fi

    # Empty for `claude -p` runs and for parts with nothing to read; those
    # are recorded as reviewed like the rest.
    body=$(head -n "$total_lines" "$transcript" |
        jq -r -s --argjson reviewed "$done_lines" --argjson context "$CONTEXT_ENTRIES" -f "$scripts/dialogue.jq")
    [ -n "$body" ] || continue
    block="##### SESSION $id (last active $(date -r "$transcript" '+%F %T'))
$body"
    # The newest session is shown even when it alone is over the limit.
    if [ -s "$dialogue" ] && [ $(($(wc -c <"$dialogue") + $(printf '%s\n\n' "$block" | wc -c))) -gt "$MAX_BYTES" ]; then
        full=yes
        left_out=$((left_out + 1))
        continue
    fi
    printf '%s\n\n' "$block" >>"$dialogue"
done < <(find "$transcripts" -maxdepth 1 -name '*.jsonl' -exec stat -f '%m %N' {} + | sort -rn | cut -d ' ' -f 2-)

echo "dialogue: $dialogue"
echo "sessions to review: $(grep -c '^##### SESSION' "$dialogue")"
echo "older sessions left out to stay under the size limit: $left_out"

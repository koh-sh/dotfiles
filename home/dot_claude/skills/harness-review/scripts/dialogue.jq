# Condense a Claude Code transcript (JSONL) into the dialogue harness-review's
# session learning reads:
#
#   jq -r -s --argjson reviewed <lines reviewed before> --argjson context <entries> -f dialogue.jq
#
# Session learning looks for what the user said and did, so the user's side
# is kept whole and Claude's side only where it gives that context:
# - what the user typed, their answers, rejections and interrupts
# - Claude's last reply before each of those, cut short
# - the tools Claude called in that turn, by name only
# - a tool call the user rejected or that failed, the error, and the call
#   that came right after the error
# Entries after the first $reviewed lines go under `=== NEW`; the last $context
# entries before them go under `=== EARLIER`. Prints nothing for a session
# nobody typed into (`claude -p` runs) or one with nothing new.

def clip(n): if length > n then .[0:n] + " [...]" else . end;

def result_text:
  if type == "array" then map(.text? // empty) | join("\n") else tostring end;

# One event per thing said or done, in transcript order, with its line index.
def events:
  to_entries[]
  | .key as $line
  | .value
  | select(.isSidechain != true and .isMeta != true)
  | if .type == "user" then
      if (.message.content | type) == "string" then
        select(.turnOrigin == "human") | {kind: "user", text: "=== USER\n\(.message.content)\n"}
      else
        .message.content[]
        | if .type == "text" then
            {kind: "user", text: "=== USER\n\(.text)\n"}
          elif .type == "tool_result" then
            (.content | result_text) as $text
            | if ($text | test("^The user doesn't want to proceed")) then
                {kind: "rejection", text: "=== USER (tool result)\n\($text)\n"}
              elif ($text | test("^(The user answered|Your questions have been answered)")) then
                {kind: "user", text: "=== USER (tool result)\n\($text)\n"}
              elif .is_error == true then
                {kind: "error", text: "=== TOOL ERROR\n\($text | clip(500))\n"}
              else empty end
          else empty end
      end
    elif .type == "assistant" then
      .message.content[]
      | if .type == "text" then
          {kind: "reply", text: "=== CLAUDE\n\(.text | clip(1000))\n"}
        elif .type == "tool_use" then
          {kind: "tool", name, text: "=== CLAUDE -> \(.name): \(.input | tostring | clip(60))\n"}
        else empty end
    else empty end
  | . + {line: $line};

# ["Bash", "Bash", "Read"] -> "Bash x2, Read"
def tool_run:
  reduce .[] as $name ([];
    if length > 0 and .[length - 1][0] == $name then .[length - 1][1] += 1 else . + [[$name, 1]] end)
  | map(if .[1] > 1 then "\(.[0]) x\(.[1])" else .[0] end)
  | join(", ");

# The entries to show, each placed at the line of the event that put it down.
def entries:
  reduce events as $e ({out: [], reply: null, tools: [], call: null, after_error: false};
    def put($texts): .out += [$texts[] | {line: $e.line, text: .}];
    if $e.kind == "reply" then
      .reply = $e.text
    elif $e.kind == "tool" then
      .tools += [$e.name]
      | if .after_error then put([$e.text]) | .after_error = false | .call = null else .call = $e.text end
    elif $e.kind == "error" then
      put([.call // empty, $e.text]) | .call = null | .after_error = true
    else
      # The user spoke: put down the turn's context, then what they said.
      put([
        (if (.tools | length) > 0 then "=== CLAUDE tools: \(.tools | tool_run)\n" else empty end),
        (.reply // empty),
        (if $e.kind == "rejection" then .call // empty else empty end),
        $e.text
      ])
      | .reply = null | .tools = [] | .call = null | .after_error = false
    end)
  | .out;

if any(.[]; .type == "user" and .turnOrigin == "human") then
  entries as $all
  | ($all | map(select(.line >= $reviewed))) as $new
  | ($all | map(select(.line < $reviewed)) | .[(- $context):]) as $earlier
  | select($new | length > 0)
  | (if ($earlier | length) > 0 then
       "=== EARLIER (reviewed by an earlier run; context only)\n\n" + ($earlier | map(.text) | join("\n")) + "\n"
     else "" end)
    + "=== NEW\n\n" + ($new | map(.text) | join("\n"))
else empty end

# xontrib
xontrib load bashisms coreutils prompt_ret_code

# env
$AUTO_CD = True
$AUTO_SUGGEST_IN_COMPLETIONS = False
$AUTO_PUSHD = True
$BASH_COMPLETIONS=('/opt/homebrew/share/bash-completion/bash_completion') # brew install bash-completion2
$BOTTOM_TOOLBAR = ""
$CASE_SENSITIVE_COMPLETIONS = False
$COMPLETIONS_BRACKETS = True
$COMPLETION_QUERY_LIMIT = 100
$COMPLETIONS_MENU_ROWS = 5
$COMPLETIONS_CONFIRM = False
$FUZZY_PATH_COMPLETION = True
$INDENT = "    "
$PROMPT = '{INTENSE_GREEN}┬─[{YELLOW}{user}{RESET}@{BLUE}{hostname}{RESET}:{cwd}{INTENSE_GREEN}]─[{localtime}]─[{RESET}G:{INTENSE_GREEN}{curr_branch}=]\n{INTENSE_GREEN}╰─>{INTENSE_RED}{prompt_end}{RESET} '
$SUBSEQUENCE_PATH_COMPLETION = True
$SUGGEST_COMMANDS = True
$SUPPRESS_BRANCH_TIMEOUT_MESSAGE = True
$UPDATE_COMPLETIONS_ON_KEYPRESS = False
$UPDATE_PROMPT_ON_KEYPRESS = True
$VI_MODE = False
$XONSH_AUTOPAIR = True
$XONSH_SHOW_TRACEBACK = False

# alias
aliases["ll"] = "ls -lart"
aliases["sudo"] = "sudo "
aliases["P"] = "python"
aliases["kscook"] = "bundle exec knife solo cook"
aliases["ksclean"] = "bundle exec knife solo clean"

# Load required modules
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz colors
autoload -Uz select-word-style

colors
select-word-style default

# Environment settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Path configuration
export PATH=/opt/homebrew/bin:$PATH

# Completion system configuration
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# Word handling configuration
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

# Version Control System (VCS) configuration
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

# Shell options
# General behavior
setopt no_beep            # Disable beep sound
setopt no_flow_control    # Disable flow control
setopt print_exit_value   # Print exit value if non-zero
setopt interactivecomments # Allow comments in interactive mode
setopt correct           # Command correction

# Directory handling
setopt auto_cd           # Change directory without cd command
setopt auto_pushd        # Push directory to stack automatically
setopt pushd_ignore_dups # Ignore duplicates in directory stack

# History configuration
setopt share_history      # Share history between sessions
setopt hist_reduce_blanks # Remove unnecessary blanks from history
setopt extended_glob      # Extended globbing
setopt magic_equal_subst  # Expand filenames after =
setopt hist_expire_dups_first    # Expire duplicate entries first
setopt hist_find_no_dups        # Do not display duplicates during searches
setopt hist_ignore_dups         # Do not record duplicate commands
setopt hist_ignore_space        # Do not record commands starting with space

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# Common aliases
alias ll='ls -lart'
alias P='python'
if type ccat &>/dev/null; then
    alias cat='ccat'
fi
alias imgcat='wezterm imgcat'

# OS-specific clipboard configuration
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi

# OS-specific ls configuration
case ${OSTYPE} in
    darwin*)
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac

# Prompt configuration
function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_} %D{%Y-%m-%d %H:%M:%S}"
}

add-zsh-hook precmd _update_vcs_info_msg
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

# Key bindings
bindkey '^R' history-incremental-pattern-search-backward
bindkey -e

# Editor configuration
export EDITOR=vim

# Load credentials if available
if [ -r ~/.cred ]; then 
  source ~/.cred
fi

# Initialize mise
eval "$(mise activate zsh)"

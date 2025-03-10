
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit -u
autoload -Uz colors
autoload -Uz select-word-style

colors
select-word-style default

zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified
zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_reduce_blanks
setopt extended_glob
setopt magic_equal_subst
setopt print_exit_value
setopt interactivecomments
setopt correct

alias ll='ls -lart'
alias sudo='sudo '
alias P='python'
alias cat='ccat'
alias imgcat='wezterm imgcat'

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

case ${OSTYPE} in
    darwin*)
        export CLICOLOR=1
        alias ls='ls -G -F'
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_} %D{%Y-%m-%d %H:%M:%S}"
}

add-zsh-hook precmd _update_vcs_info_msg
bindkey '^R' history-incremental-pattern-search-backward
bindkey -e
export EDITOR=vim
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "

export PATH=/opt/homebrew/bin:$PATH
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# credentials
if [ -r ~/.cred ]; then 
  source ~/.cred
fi
eval "$(mise activate zsh)"

#!/usr/bin/env bash

set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-${HOME}/.local/state}"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"

readonly DIRECTORIES=(
    "$XDG_CACHE_HOME/zsh"
    "$XDG_STATE_HOME/zsh"
    "$XDG_DATA_HOME/ansible"
    "$XDG_DATA_HOME/ansible/cp"
    "$XDG_CONFIG_HOME/aws"
    "$XDG_DATA_HOME/go"
    "$XDG_CONFIG_HOME/ipython"
    "$XDG_STATE_HOME/less"
    "$XDG_CACHE_HOME/vim"
    "$XDG_DATA_HOME/irb"
    "$XDG_CACHE_HOME/bundle"
    "$XDG_DATA_HOME/bundle"
    "$XDG_CONFIG_HOME/nvim"
)

for dir in "${DIRECTORIES[@]}"; do
    mkdir -p "$dir"
done

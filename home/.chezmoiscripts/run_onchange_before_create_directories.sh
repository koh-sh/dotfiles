#!/usr/bin/env bash

XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_DATA_HOME="${HOME}/.local/share"
XDG_STATE_HOME="${HOME}/.local/state"
XDG_RUNTIME_DIR="/run/user/$UID"

mkdir -p "$XDG_CACHE_HOME"/zsh
mkdir -p "$XDG_STATE_HOME"/zsh
mkdir -p "$XDG_DATA_HOME"/ansible
mkdir -p "$XDG_DATA_HOME"/ansible/cp
mkdir -p "$XDG_CONFIG_HOME"/aws/
mkdir -p "$XDG_DATA_HOME"/go
mkdir -p "$XDG_CONFIG_HOME/ipython"
mkdir -p "$XDG_STATE_HOME"/less/
mkdir -p "$XDG_CACHE_HOME"/vim

#!/usr/bin/env bash

XDG_CONFIG_HOME="${HOME}/.config"
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME"/hammerspoon/init.lua

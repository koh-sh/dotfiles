-- Setup
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()
config:set_strict_mode(true)

-- Visual Settings
config.color_scheme = 'Adventure'
config.font = wezterm.font('JetBrains Mono', { weight = 'ExtraBold', italic = false })
config.font_size = 12.2
config.window_background_opacity = 0.70
config.colors = {
    scrollbar_thumb = 'grey',
    selection_fg = 'black',
    selection_bg = 'silver',
    copy_mode_inactive_highlight_bg = { Color = 'Red' },
    copy_mode_inactive_highlight_fg = { Color = 'black' },
}

-- Miscellaneous Settings
config.notification_handling = "NeverShow"
config.enable_scroll_bar = true
config.scrollback_lines = 10000

-- Key Bindings
-- Initialize config.keys if it doesn't exist
config.keys = config.keys or {}

-- Define key bindings in a table
local key_bindings = {
    -- Input backslash instead of ¥ (Mac-specific)
    { key = "¥", mods = 'NONE',        action = act.SendKey { key = '\\' } },

    -- Close pane with cmd+w (default closes tab)
    { key = "w", mods = "SUPER",       action = act.CloseCurrentPane { confirm = true } },

    -- Split pane horizontally with cmd+d
    { key = "d", mods = "SUPER",       action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } } },

    -- Split pane vertically with cmd+shift+d
    { key = "d", mods = "SUPER|SHIFT", action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },

    -- Rotate panes with cmd+ctrl+o
    { key = "o", mods = "SUPER|CTRL",  action = act.RotatePanes 'Clockwise' },

    -- Navigate between panes with cmd+[ and cmd+]
    { key = '[', mods = 'SUPER',       action = act.ActivatePaneDirection 'Prev' },
    { key = ']', mods = 'SUPER',       action = act.ActivatePaneDirection 'Next' },

    -- Open Tab in Home dir
    { key = 't', mods = 'SUPER',       action = act { SpawnCommandInNewTab = { cwd = wezterm.home_dir } } },

    -- Open wezterm lua repl
    { key = 'R', mods = 'CTRL',        action = wezterm.action.ShowDebugOverlay },

    -- Ignore clipboard when searching
    {
        key = 'f',
        mods = 'SUPER',
        action = act.Multiple {
            act.ClearSelection,
            act.Search { CaseInSensitiveString = '' },
        }
    },
}

-- Helper function to check if a key binding already exists
local function has_binding(existing_bindings, new_binding)
    for _, binding in ipairs(existing_bindings) do
        if binding.key == new_binding.key and binding.mods == new_binding.mods then
            return true
        end
    end
    return false
end

-- Add key bindings to config, avoiding duplicates
for _, binding in ipairs(key_bindings) do
    if not has_binding(config.keys, binding) then
        table.insert(config.keys, binding)
    end
end

-- Key Bindings for Search Mode
-- To get default bindings, use: `wezterm show-keys --lua --key-table search_mode`
config.key_tables = {
    search_mode = {
        { key = 'Enter', mods = 'NONE',  action = act.CopyMode 'PriorMatch' },
        { key = 'Enter', mods = 'SHIFT', action = act.CopyMode 'NextMatch' },
        {
            key = 'Escape',
            mods = 'NONE',
            action = act.Multiple {
                act.CopyMode 'ClearPattern',
                act.CopyMode 'Close',
            }
        },
        { key = 'n',         mods = 'CTRL', action = act.CopyMode 'NextMatch' },
        { key = 'p',         mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
        { key = 'r',         mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
        { key = 'u',         mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
        { key = 'PageUp',    mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
        { key = 'PageDown',  mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
        { key = 'UpArrow',   mods = 'NONE', action = act.CopyMode 'PriorMatch' },
        { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    }
}

-- local theme_rotator = wezterm.plugin.require 'file:///Users/koh/github/wezterm-theme-rotator'
local theme_rotator = wezterm.plugin.require 'https://github.com/koh-sh/wezterm-theme-rotator'
theme_rotator.apply_to_config(config, {
    -- Customize "Next Theme" key
    default_theme_key = 'y',
    default_theme_mods = 'SUPER|SHIFT',
})

-- Return the configuration to wezterm
return config

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

-- Miscellaneous Settings
config.notification_handling = "NeverShow"

-- Key Bindings
config.keys = {
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
}

-- Key Bindings for Search Mode
-- To get default bindings, use: `wezterm show-keys --lua --key-table search_mode`
config.key_tables = {
    search_mode = {
        { key = 'Enter',     mods = 'NONE', action = act.CopyMode 'PriorMatch' },
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

-- Return the configuration to wezterm
return config

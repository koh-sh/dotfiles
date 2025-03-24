-- Setup
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config:set_strict_mode(true)

-----------------------------------------------------------
-- Visual Settings
-----------------------------------------------------------
local function setup_visuals(config)
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
end

-----------------------------------------------------------
-- General Settings
-----------------------------------------------------------
local function setup_general(config)
    config.notification_handling = "NeverShow"
    config.enable_scroll_bar = true
    config.scrollback_lines = 10000
end

-----------------------------------------------------------
-- Key Bindings
-----------------------------------------------------------
-- Helper function to check if a key binding already exists
local function has_binding(existing_bindings, new_binding)
    for _, binding in ipairs(existing_bindings) do
        if binding.key == new_binding.key and binding.mods == new_binding.mods then
            return true
        end
    end
    return false
end

-- Define key bindings by category
local key_bindings = {
    -- System operations
    {
        category = "System",
        bindings = {
            { key = "¥", mods = 'NONE', action = act.SendKey { key = '\\' } },
            { key = 'R', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
        }
    },
    -- Pane management
    {
        category = "Pane",
        bindings = {
            { key = "w", mods = "SUPER",       action = act.CloseCurrentPane { confirm = true } },
            { key = "d", mods = "SUPER",       action = act { SplitHorizontal = { domain = "CurrentPaneDomain" } } },
            { key = "d", mods = "SUPER|SHIFT", action = act { SplitVertical = { domain = "CurrentPaneDomain" } } },
            { key = "o", mods = "SUPER|CTRL",  action = act.RotatePanes 'Clockwise' },
            { key = '[', mods = 'SUPER',       action = act.ActivatePaneDirection 'Prev' },
            { key = ']', mods = 'SUPER',       action = act.ActivatePaneDirection 'Next' },
        }
    },
    -- Tab management
    {
        category = "Tab",
        bindings = {
            { key = 't', mods = 'SUPER', action = act { SpawnCommandInNewTab = { cwd = wezterm.home_dir } } },
        }
    },
    -- Search functionality
    {
        category = "Search",
        bindings = {
            {
                key = 'f',
                mods = 'SUPER',
                action = act.Multiple {
                    act.ClearSelection,
                    act.Search { CaseInSensitiveString = '' },
                }
            },
        }
    },
}

-- Setup key bindings
local function setup_key_bindings(config)
    -- Initialize config.keys if it doesn't exist
    config.keys = config.keys or {}

    -- Add key bindings by category, avoiding duplicates
    for _, category in ipairs(key_bindings) do
        for _, binding in ipairs(category.bindings) do
            if not has_binding(config.keys, binding) then
                table.insert(config.keys, binding)
            end
        end
    end
end

-----------------------------------------------------------
-- Search Mode Configuration
-----------------------------------------------------------
local function setup_search_mode(config)
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
end

-----------------------------------------------------------
-- Theme Rotator Plugin Configuration
-----------------------------------------------------------
local function setup_theme_rotator_plugin(config)
    -- local theme_rotator = wezterm.plugin.require 'file:///Users/koh/github/wezterm-theme-rotator'
    local theme_rotator = wezterm.plugin.require 'https://github.com/koh-sh/wezterm-theme-rotator'
    theme_rotator.apply_to_config(config, {
        default_theme_key = 'y',
        default_theme_mods = 'SUPER|SHIFT',
    })
end

-----------------------------------------------------------
-- Apply all configurations
-----------------------------------------------------------
local function apply_config(config)
    setup_visuals(config)
    setup_general(config)
    setup_key_bindings(config)
    setup_search_mode(config)
    setup_theme_rotator_plugin(config)
end

-- Apply all configurations and return
apply_config(config)
return config

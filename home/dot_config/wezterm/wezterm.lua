-- Setup
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config:set_strict_mode(true)

-- Background opacity; also the restore value for the Cmd+S opacity toggle
local default_opacity = 0.70

-----------------------------------------------------------
-- Visual Settings
-----------------------------------------------------------
local function setup_visuals(config)
    -- Render via Metal (wgpu) instead of the deprecated OpenGL path;
    -- avoids glium viewport panic on wake from sleep on macOS Tahoe
    config.front_end = 'WebGpu'
    -- Match ProMotion 120Hz displays (default is 60)
    config.max_fps = 120
    config.color_scheme = 'Adventure'
    config.font = wezterm.font('JetBrains Mono', { weight = 'ExtraBold', italic = false })
    config.font_size = 12.2
    config.window_background_opacity = default_opacity
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
    -- Let apps opt in to the kitty keyboard protocol (e.g. Shift+Enter newline in grok CLI)
    config.enable_kitty_keyboard = true
    config.enable_scroll_bar = true
    config.scrollback_lines = 10000000
end

-----------------------------------------------------------
-- Key Bindings
-----------------------------------------------------------
local function setup_key_bindings(config)
    config.keys = {
        -- System
        { key = "¥", mods = 'NONE', action = act.SendKey { key = '\\' } },
        { key = "Enter", mods = "SHIFT", action = act.SendString "\x1b\r" },
        { key = 'R', mods = 'CTRL', action = act.ShowDebugOverlay },
        {
            key = 's',
            mods = 'SUPER',
            action = wezterm.action_callback(function(window, pane)
                local overrides = window:get_config_overrides() or {}
                if overrides.window_background_opacity == 1.0 then
                    overrides.window_background_opacity = default_opacity
                else
                    overrides.window_background_opacity = 1.0
                end
                window:set_config_overrides(overrides)
            end),
        },
        -- Paste with LF→CR conversion for lazysql (tview doesn't handle LF in bracketed paste)
        {
            key = 'v',
            mods = 'SUPER',
            action = wezterm.action_callback(function(window, pane)
                local process = pane:get_foreground_process_name() or ""
                if process:match("lazysql$") then
                    local success, stdout = wezterm.run_child_process({ "pbpaste" })
                    if success then
                        local text = stdout:gsub("\n", "\r")
                        window:perform_action(
                            act.SendString("\x1b[200~" .. text .. "\x1b[201~"),
                            pane
                        )
                    end
                else
                    window:perform_action(act.PasteFrom "Clipboard", pane)
                end
            end),
        },
        -- Pane
        { key = "w", mods = "SUPER",       action = act.CloseCurrentPane { confirm = true } },
        { key = "d", mods = "SUPER",       action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
        { key = "d", mods = "SUPER|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
        { key = "o", mods = "SUPER|CTRL",  action = act.RotatePanes 'Clockwise' },
        { key = '[', mods = 'SUPER',       action = act.ActivatePaneDirection 'Prev' },
        { key = ']', mods = 'SUPER',       action = act.ActivatePaneDirection 'Next' },
        -- Tab
        { key = 't', mods = 'SUPER', action = act.SpawnCommandInNewTab { cwd = wezterm.home_dir } },
        -- Search
        {
            key = 'f',
            mods = 'SUPER',
            action = act.Multiple {
                act.ClearSelection,
                act.Search { CaseInSensitiveString = '' },
            }
        },
    }
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
-- Tab Bar Settings
-----------------------------------------------------------
local function setup_tab_bar(config)
    config.show_new_tab_button_in_tab_bar = false
    config.show_close_tab_button_in_tabs = false
    config.window_decorations = "RESIZE"

    wezterm.on('format-tab-title', function(tab)
        local pane = tab.active_pane
        local index = tab.tab_index + 1
        local process = pane.foreground_process_name
        local title = process and process:match("([^/]+)$") or pane.title
        return index .. ": " .. title
    end)
end

-----------------------------------------------------------
-- Pane Mover (move the focused pane into another tab)
-----------------------------------------------------------
local function setup_pane_mover(config)
    local wezterm_bin = wezterm.executable_dir .. '/wezterm'

    local function run_cli(args)
        local success, _, stderr = wezterm.run_child_process(args)
        if not success then
            wezterm.log_error('wezterm cli failed: ' .. stderr)
        end
        return success
    end

    local move_pane_action = wezterm.action_callback(function(window, pane)
        local moving_pane_id = pane:pane_id()
        local current_tab_id = pane:tab():tab_id()

        -- One row per tab x direction, so a single pick decides both
        local choices = {}
        for _, entry in ipairs(window:mux_window():tabs_with_info()) do
            local tab = entry.tab
            local panes = tab:panes()
            local only_moving_pane = #panes == 1 and panes[1]:pane_id() == moving_pane_id
            if not only_moving_pane then
                local title = tab:get_title()
                if title == nil or title == '' then
                    title = tab:active_pane():get_title()
                end
                local marker = ''
                if tab:tab_id() == current_tab_id then
                    marker = '  [current tab]'
                end

                -- Split target: the tab's active pane, but never the moving pane itself
                local target = tab:active_pane()
                if target:pane_id() == moving_pane_id then
                    for _, other in ipairs(panes) do
                        if other:pane_id() ~= moving_pane_id then
                            target = other
                            break
                        end
                    end
                end

                for _, dir in ipairs({
                    { flag = '--right', text = '\u{2192} right' },
                    { flag = '--bottom', text = '\u{2193} bottom' },
                    { flag = '--left', text = '\u{2190} left' },
                    { flag = '--top', text = '\u{2191} top' },
                }) do
                    table.insert(choices, {
                        -- id carries both the split target and the direction
                        id = string.format('%d %s', target:pane_id(), dir.flag),
                        label = string.format('%d: %s  %s%s',
                            entry.index + 1, title, dir.text, marker),
                    })
                end
            end
        end

        if #choices == 0 then
            window:toast_notification('wezterm', 'No tab to move the pane into', nil, 3000)
            return
        end

        window:perform_action(
            act.InputSelector {
                title = 'Move pane',
                description = 'Select destination tab and direction',
                fuzzy_description = 'Move pane to: ',
                fuzzy = true,
                choices = choices,
                action = wezterm.action_callback(function(_, _, id)
                    if not id then
                        return
                    end
                    local target_pane_id, direction = id:match('^(%d+) (%-%-%a+)$')
                    if not target_pane_id then
                        return
                    end
                    local ok = run_cli {
                        wezterm_bin, 'cli', 'split-pane',
                        '--top-level', direction,
                        '--pane-id', target_pane_id,
                        '--move-pane-id', tostring(moving_pane_id),
                    }
                    if ok then
                        -- follow the moved pane
                        run_cli { wezterm_bin, 'cli', 'activate-pane', '--pane-id', tostring(moving_pane_id) }
                    end
                end),
            },
            pane
        )
    end)

    -- Overrides the default SUPER+m Hide (minimize) assignment
    table.insert(config.keys, {
        key = 'm',
        mods = 'SUPER',
        action = move_pane_action,
    })
end

-----------------------------------------------------------
-- PR Review Launcher (clipboard PR URL -> checkout + claude)
-----------------------------------------------------------
local function setup_pr_review_launcher(config)
    local repos_root = wezterm.home_dir .. '/github/'

    -- Build a shell snippet that runs cmd only after a [y/N] confirmation
    local function confirm_then(question, cmd)
        return string.format('printf \'%s [y/N] \'; read ans; if [ "$ans" = "y" ]; then %s; fi', question, cmd)
    end

    local pr_review_action = wezterm.action_callback(function(window, pane)
        local success, clipboard = wezterm.run_child_process { 'pbpaste' }
        if not success then
            window:toast_notification('wezterm', 'Failed to read clipboard', nil, 3000)
            return
        end

        local owner, repo, number = clipboard:match('github%.com/([%w%.%-_]+)/([%w%.%-_]+)/pull/(%d+)')
        if not owner then
            window:toast_notification('wezterm', 'No GitHub PR URL in clipboard', nil, 3000)
            return
        end

        local repo_dir = repos_root .. repo
        -- Rebuild a canonical URL so extra path segments (/files etc.) are dropped
        local url = string.format('https://github.com/%s/%s/pull/%s', owner, repo, number)
        local checkout_cmd = string.format('gh pr checkout %s && claude', url)

        local dir_exists = wezterm.run_child_process { 'test', '-d', repo_dir }
        local spawn_cwd = repo_dir
        local cmd
        if not dir_exists then
            -- No local clone: ask in the new tab whether to clone first
            spawn_cwd = repos_root
            cmd = confirm_then(
                string.format('Clone %s/%s into %s?', owner, repo, repo_dir),
                string.format('gh repo clone %s/%s %s && cd %s && %s',
                    owner, repo, repo_dir, repo_dir, checkout_cmd)
            )
        else
            local _, status_out, _ = wezterm.run_child_process { 'git', '-C', repo_dir, 'status', '--porcelain' }
            if status_out and status_out ~= '' then
                -- Dirty tree: show git status in the new tab and ask before stashing
                cmd = 'git status; '
                    .. confirm_then('Stash and continue?', 'git stash push -u && ' .. checkout_cmd)
            else
                cmd = checkout_cmd
            end
        end

        local _, new_pane, _ = window:mux_window():spawn_tab { cwd = spawn_cwd }
        new_pane:send_text(cmd .. '\r')
    end)

    -- g for GitHub
    table.insert(config.keys, {
        key = 'g',
        mods = 'SUPER',
        action = pr_review_action,
    })
end

-----------------------------------------------------------
-- Apply all configurations
-----------------------------------------------------------
local function apply_config(config)
    setup_visuals(config)
    setup_general(config)
    setup_key_bindings(config)
    setup_pane_mover(config)
    setup_pr_review_launcher(config)
    setup_search_mode(config)
    setup_tab_bar(config)
    setup_theme_rotator_plugin(config)
end

-- Apply all configurations and return
apply_config(config)
return config

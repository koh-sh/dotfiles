-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- configのlua実行にエラーがあった場合に出力する
config:set_strict_mode(true)

-- テーマ
config.color_scheme = 'Adventure'

-- フォント
config.font = wezterm.font('JetBrains Mono', { weight = 'ExtraBold', italic = false })
config.font_size = 12.2

-- 背景の非透過率（1なら完全に透過させない）
config.window_background_opacity = 0.70

-- 通知を切る
config.notification_handling = "NeverShow"

-- キーバインド
config.keys = {
    -- ¥ではなく、バックスラッシュを入力する。おそらくMac固有
    { key = "¥", mods = 'NONE',        action = wezterm.action.SendKey { key = '\\' } },

    -- cmd w でペインを閉じる（デフォルトではタブが閉じる）
    { key = "w", mods = "SUPER",       action = wezterm.action.CloseCurrentPane { confirm = true } },

    -- cmd d で右方向にペイン分割
    { key = "d", mods = "SUPER",       action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } } },

    -- cmd Shift d で下方向にペイン分割
    { key = "d", mods = "SUPER|SHIFT", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } } },

    -- cmd Ctrl oでペインの中身を入れ替える
    { key = "o", mods = "SUPER|CTRL",  action = wezterm.action.RotatePanes 'Clockwise' },

    -- cmd []でペインの移動 (Prev/Next)
    { key = '[', mods = 'SUPER',       action = wezterm.action.ActivatePaneDirection 'Prev' },
    { key = ']', mods = 'SUPER',       action = wezterm.action.ActivatePaneDirection 'Next' },
}

-- searchのキーマッピング
-- デフォルトは `wezterm show-keys --lua --key-table search_mode` で出力
config.key_tables = {
    search_mode = {
        { key = 'Enter',     mods = 'NONE', action = wezterm.action.CopyMode 'PriorMatch' },
        {
            key = 'Escape',
            mods = 'NONE',
            action = wezterm.action.Multiple {
                wezterm.action.CopyMode 'ClearPattern',
                wezterm.action.CopyMode 'Close',
            }
        },
        { key = 'n',         mods = 'CTRL', action = wezterm.action.CopyMode 'NextMatch' },
        { key = 'p',         mods = 'CTRL', action = wezterm.action.CopyMode 'PriorMatch' },
        { key = 'r',         mods = 'CTRL', action = wezterm.action.CopyMode 'CycleMatchType' },
        { key = 'u',         mods = 'CTRL', action = wezterm.action.CopyMode 'ClearPattern' },
        { key = 'PageUp',    mods = 'NONE', action = wezterm.action.CopyMode 'PriorMatchPage' },
        { key = 'PageDown',  mods = 'NONE', action = wezterm.action.CopyMode 'NextMatchPage' },
        { key = 'UpArrow',   mods = 'NONE', action = wezterm.action.CopyMode 'PriorMatch' },
        { key = 'DownArrow', mods = 'NONE', action = wezterm.action.CopyMode 'NextMatch' },
    }
}

-- and finally, return the configuration to wezterm
return config

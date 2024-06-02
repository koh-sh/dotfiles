-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- テーマ
config.color_scheme = 'Adventure'

-- フォント
config.font_size = 12.2
config.font =
    wezterm.font('JetBrains Mono', { weight = 'ExtraBold', italic = false })
-- 背景の非透過率（1なら完全に透過させない）
config.window_background_opacity = 0.70

-- 通知を切る
config.notification_handling = "NeverShow"

-- キーバインド
config.keys = {
    -- ¥ではなく、バックスラッシュを入力する。おそらくMac固有
    {
        key = "¥",
        action = wezterm.action.SendKey { key = '\\' }
    },
    -- cmd w でペインを閉じる（デフォルトではタブが閉じる）
    {
        key = "w",
        mods = "CMD",
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    -- cmd d で右方向にペイン分割
    {
        key = "d",
        mods = "CMD",
        action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } },
    },
    -- cmd Shift d で下方向にペイン分割
    {
        key = "d",
        mods = "CMD|SHIFT",
        action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } },
    },
    -- cmd Ctrl oでペインの中身を入れ替える
    {
        key = "o",
        mods = "CMD|CTRL",
        action = wezterm.action.RotatePanes 'Clockwise'
    },
    -- cmd []でペインの移動 (Prev)
    {
        key = '[',
        mods = 'CMD',
        action = wezterm.action.ActivatePaneDirection 'Prev',
    },
    {
        key = ']',
        mods = 'CMD',
        action = wezterm.action.ActivatePaneDirection 'Next',
    },
}

-- and finally, return the configuration to wezterm
return config

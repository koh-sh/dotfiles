-- Constants for key codes
local KEY_CODES = {
    LEFT_COMMAND = 0x37,
    RIGHT_COMMAND = 0x36,
    EISUU = 0x66,
    KANA = 0x68
}

-- Load FnMate Spoon for function key handling
-- Download from: https://github.com/Hammerspoon/Spoons/raw/master/Spoons/FnMate.spoon.zip
hs.loadSpoon("FnMate")

-- Helper function to create a key press function
local function createKeyPressFunction(key, modifiers)
    modifiers = modifiers or {}
    return function()
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), true):post()
        hs.timer.usleep(1000)
        hs.eventtap.event.newKeyEvent(modifiers, string.lower(key), false):post()
    end
end

-- Helper function to bind a key combination to a specific action
local function bindKeyRemap(modifiers, key, keyCode)
    hs.hotkey.bind(modifiers, key, keyCode, nil, keyCode)
end

-- Configure Vim-style arrow key mappings
local function setupVimStyleNavigation()
    -- Basic navigation
    bindKeyRemap({ 'ctrl' }, 'h', createKeyPressFunction('left'))
    bindKeyRemap({ 'ctrl' }, 'j', createKeyPressFunction('down'))
    bindKeyRemap({ 'ctrl' }, 'k', createKeyPressFunction('up'))
    bindKeyRemap({ 'ctrl' }, 'l', createKeyPressFunction('right'))

    -- With Shift (for selection)
    bindKeyRemap({ 'ctrl', 'shift' }, 'h', createKeyPressFunction('left', { 'shift' }))
    bindKeyRemap({ 'ctrl', 'shift' }, 'j', createKeyPressFunction('down', { 'shift' }))
    bindKeyRemap({ 'ctrl', 'shift' }, 'k', createKeyPressFunction('up', { 'shift' }))
    bindKeyRemap({ 'ctrl', 'shift' }, 'l', createKeyPressFunction('right', { 'shift' }))

    -- With Command (for word-level movement)
    bindKeyRemap({ 'ctrl', 'cmd' }, 'h', createKeyPressFunction('left', { 'cmd' }))
    bindKeyRemap({ 'ctrl', 'cmd' }, 'j', createKeyPressFunction('down', { 'cmd' }))
    bindKeyRemap({ 'ctrl', 'cmd' }, 'k', createKeyPressFunction('up', { 'cmd' }))
    bindKeyRemap({ 'ctrl', 'cmd' }, 'l', createKeyPressFunction('right', { 'cmd' }))

    -- With Command + Shift (for word-level selection)
    bindKeyRemap({ 'ctrl', 'shift', 'cmd' }, 'h', createKeyPressFunction('left', { 'shift', 'cmd' }))
    bindKeyRemap({ 'ctrl', 'shift', 'cmd' }, 'j', createKeyPressFunction('down', { 'shift', 'cmd' }))
    bindKeyRemap({ 'ctrl', 'shift', 'cmd' }, 'k', createKeyPressFunction('up', { 'shift', 'cmd' }))
    bindKeyRemap({ 'ctrl', 'shift', 'cmd' }, 'l', createKeyPressFunction('right', { 'shift', 'cmd' }))

    -- Additional mappings
    bindKeyRemap({ "ctrl" }, "f", createKeyPressFunction("delete"))

    -- Defeating paste blocking
    hs.hotkey.bind({ "cmd", "alt" }, "V", function() hs.eventtap.keyStrokes(hs.pasteboard.getContents()) end)
end

-- Global variable to store the event tap (prevent GC)
CommandKeyEventTap = nil

-- IME switching functionality
local function setupIMESwitching()
    local prevKeyCode = nil
    local lastFlags = nil

    local function keyStroke(modifiers, character)
        hs.eventtap.keyStroke(modifiers, character, 0) -- Add delay parameter
    end

    local function handleIMEEvent(e)
        local keyCode = e:getKeyCode()
        local flags = e:getFlags()
        local eventType = e:getType()

        -- Only handle on key up of command key
        if eventType == hs.eventtap.event.types.flagsChanged then
            -- Command key was released
            if lastFlags and lastFlags.cmd and not flags.cmd then
                if prevKeyCode == KEY_CODES.LEFT_COMMAND then
                    keyStroke({}, KEY_CODES.EISUU)
                elseif prevKeyCode == KEY_CODES.RIGHT_COMMAND then
                    keyStroke({}, KEY_CODES.KANA)
                end
            end
            prevKeyCode = keyCode
            lastFlags = flags
        end
    end

    -- Store in global variable to prevent GC
    CommandKeyEventTap = hs.eventtap.new(
        { hs.eventtap.event.types.flagsChanged },
        handleIMEEvent
    )
    CommandKeyEventTap:start()
end

-- Initialize all configurations
setupVimStyleNavigation()
setupIMESwitching()

local env = require("env")
local M = {}

function M.new(group, x, y)
    local function getIcon()
        return env.MUTE and "assets/buttons/mute.png" or "assets/buttons/unmute.png"
    end
    local btn = display.newImageRect(getIcon(), 70, 70)
    btn.x, btn.y = x or (display.contentWidth - 110), y or 150
    group:insert(btn)

    local function updateIcon()
        btn.fill = { type="image", filename=getIcon() }
    end

    local function updateAllVolumes()
        audio.setVolume(env.MUTE and 0 or env.MUSIC_VOLUME, {channel=1})
        audio.setVolume(env.MUTE and 0 or env.MUSIC_VOLUME, {channel=2})
    end

    local function toggleMute()
        env.MUTE = not env.MUTE
        updateAllVolumes()
        updateIcon()
    end

    btn:addEventListener("tap", toggleMute)
    updateIcon()
    updateAllVolumes()
    return btn
end

return M

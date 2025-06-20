local env = require("env")

local ui = {}

function ui.createMuteButton(group, x, y)
    local function getIcon()
        return env.MUTE and "assets/buttons/mute.png" or "assets/buttons/unmute.png"
    end
    local btn = display.newImageRect(getIcon(), 70, 70)
    btn.x, btn.y = x, y
    group:insert(btn)

    local function updateIcon()
        btn.fill = { type="image", filename=getIcon() }
    end

    local function updateAllVolumes()
        audio.setVolume(env.MUTE and 0 or env.MUSIC_VOLUME, {channel=1})
        audio.setVolume(env.MUTE and 0 or env.MUSIC_VOLUME, {channel=2})
        -- adicione mais canais se usar mais
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

function ui.createStartButton(group, x, y, onTap)
    local btn = display.newImageRect("assets/buttons/start.png", 120, 70)
    btn.x, btn.y = x, y
    group:insert(btn)
    if onTap then
        btn:addEventListener("tap", onTap)
    end
    return btn
end

function ui.createRateButton(group, x, y, onTap)
    local btn = display.newImageRect("assets/buttons/rate.png", 50, 50)
    btn.x, btn.y = x, y
    group:insert(btn)
    if onTap then
        btn:addEventListener("tap", onTap)
    end
    return btn
end

function ui.createPauseButton(group, x, y, onTap)
    local btn = display.newImageRect("assets/buttons/pause.png", 70, 70)
    btn.x, btn.y = x, y
    group:insert(btn)
    if onTap then
        btn:addEventListener("tap", onTap)
    end
    return btn
end

function ui.createPlayButton(group, x, y, onTap)
    local btn = display.newImageRect("assets/buttons/start.png", 70, 70)
    btn.x, btn.y = x, y
    btn.isVisible = false
    group:insert(btn)
    if onTap then
        btn:addEventListener("tap", onTap)
    end
    return btn
end

return ui

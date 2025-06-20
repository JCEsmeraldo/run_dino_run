local M = {}

function M.new(group, x, y, onPress, onRelease)
    local btn = display.newImageRect("assets/buttons/move.png", 80, 80)
    btn.x, btn.y = x, y
    group:insert(btn)
    btn:addEventListener("touch", function(event)
        if event.phase == "began" then
            if onPress then onPress() end
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if onRelease then onRelease() end
        end
        return true
    end)
    return btn
end

return M

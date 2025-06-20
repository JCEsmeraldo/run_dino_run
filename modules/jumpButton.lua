local M = {}

function M.new(group, x, y, onTap)
    local btn = display.newImageRect("assets/buttons/jump.png", 80, 80)
    btn.x, btn.y = x, y
    group:insert(btn)
    btn:addEventListener("tap", function()
        if onTap then onTap() end
        return true
    end)
    return btn
end

return M

local DevMode = require("modules.devmode")
local M = {}

local FIREBALL_HITBOX_RADIUS = 28
local DEBUG_OFFSET_X = -20
local DEBUG_OFFSET_Y = 20

function M.createFireball(group, fireBallImageSheet, fireBallSequenceData, fireBallTable, minSpeed, maxSpeed)
    local fireball = display.newSprite(fireBallImageSheet, fireBallSequenceData)
    fireball:scale(-4, 4)
    fireball.rotation = -50
    fireball:play()
    table.insert(fireBallTable, fireball)
    physics.addBody(fireball, "kinematic", { radius=FIREBALL_HITBOX_RADIUS, bounce=0.8 })
    fireball.myName = "fireball"
    fireball.x = math.random(display.contentWidth, (display.contentWidth + 80))
    fireball.y = -60
    minSpeed = minSpeed or 40
    maxSpeed = maxSpeed or 120
    fireball:setLinearVelocity(math.random(-140, -10), math.random(minSpeed, maxSpeed))
    group:insert(fireball)

    -- DEBUG VISUAL DO HITBOX (apenas no modo dev com debugPrint)
    if DevMode.isEnabled("debugPrint") then
        local debugCircle = display.newCircle(fireball.x + DEBUG_OFFSET_X, fireball.y + DEBUG_OFFSET_Y, FIREBALL_HITBOX_RADIUS)
        debugCircle:setFillColor(1,0,0,0.18)
        debugCircle.strokeWidth = 2
        debugCircle:setStrokeColor(1,0,0,0.45)
        group:insert(debugCircle)
        local function followFireball()
            if fireball and debugCircle and fireball.x and fireball.y then
                debugCircle.x = fireball.x + DEBUG_OFFSET_X
                debugCircle.y = fireball.y + DEBUG_OFFSET_Y
            else
                Runtime:removeEventListener("enterFrame", followFireball)
                if debugCircle then display.remove(debugCircle) end
            end
        end
        Runtime:addEventListener("enterFrame", followFireball)
    end
end

return M

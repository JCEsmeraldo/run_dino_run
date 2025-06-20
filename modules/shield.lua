local physics = require("physics")
local DevMode = require("modules.devmode")

local M = {}

M.active = false
M.sprite = nil
M.visual = nil

function M.init(params)
    M.group = params.group
    M.dino = params.dino
    M.spriteSheet = graphics.newImageSheet("assets/sprites/shield.png", {
        width = 48, height = 48, numFrames = 1,
        sheetContentWidth = 48, sheetContentHeight = 48
    })
end

function M.spawn()
    if not M.group or not M.dino then return end
    if M.sprite and M.sprite.parent then return end
    local powerup = display.newImageRect(M.spriteSheet, 1, 48, 48)
    powerup.x = math.random(60, display.contentWidth - 60)
    powerup.y = -60
    powerup.myName = "shieldPowerup"
    physics.addBody(powerup, "kinematic", { radius=20, isSensor=true })
    M.group:insert(powerup)
    M.sprite = powerup
    powerup:setLinearVelocity(0, math.random(80, 140))
    if DevMode.isEnabled("debugPrint") then
        print("[DEV] Shield power-up spawnado")
    end
end

-- Força o escudo parado na tela, fácil de pegar (para testes)
function M.forceSpawn()
    if not M.group or not M.dino then return end
    if M.sprite and M.sprite.parent then return end
    local powerup = display.newImageRect(M.spriteSheet, 1, 48, 48)
    powerup.x = display.contentCenterX
    powerup.y = 120
    powerup.myName = "shieldPowerup"
    physics.addBody(powerup, "kinematic", { radius=20, isSensor=true })
    M.group:insert(powerup)
    M.sprite = powerup
    -- Para cair normal como no spawn padrão:
    powerup:setLinearVelocity(0, math.random(80, 140))
    if DevMode.isEnabled("debugPrint") then
        print("[DEV] Shield power-up SPAWN FORÇADO")
    end
end

function M.trySpawn()
    -- Em dev: sempre spawna se noDeath está ativo (ou crie outra flag como 'forceShield')
    if DevMode.isEnabled("forceShield") or DevMode.isEnabled("noDeath") then
        M.forceSpawn()
        return
    end
    if not M.active and math.random() < 0.10 then
        M.spawn()
    end
end

function M.collect()
    M.active = true
    if M.sprite then display.remove(M.sprite) end
    M.sprite = nil
    if DevMode.isEnabled("debugPrint") then
        print("[DEV] Shield coletado")
    end
end

function M.consume()
    M.active = false
    if DevMode.isEnabled("debugPrint") then
        print("[DEV] Shield consumido")
    end
end

function M.updateVisual()
    if M.active and M.dino then
        if not M.visual then
            M.visual = display.newCircle(M.dino.x, M.dino.y, 60)
            M.visual.strokeWidth = 6
            M.visual:setStrokeColor(0,0.7,1,0.7)
            M.visual:setFillColor(0,0,0,0)
            M.group:insert(M.visual)
        end
        M.visual.x, M.visual.y = M.dino.x, M.dino.y
    elseif M.visual then
        display.remove(M.visual)
        M.visual = nil
    end
end

function M.cleanup()
    if M.sprite then display.remove(M.sprite); M.sprite = nil end
    if M.visual then display.remove(M.visual); M.visual = nil end
    M.active = false
end

return M

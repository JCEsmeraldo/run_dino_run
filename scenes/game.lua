---@diagnostic disable: undefined-global

local composer = require("composer")
local groupGame = display.newGroup()
local scene = composer.newScene()

local Timers = require("modules.timers")
local DevMode = require("modules.devmode")
local Dino = require("modules.dino")
local Fireball = require("modules.fireball")
local Shield = require("modules.shield")
local ui = require("modules.ui")
local env = require("env")
local MuteButton = require("modules.muteButton")

local pauseButton, playButton, muteButton
local collisionSound
local died, paused, blue
local fireBallTable, countDownTimer, createFireballTimer
local pastTime = 0
local fireBalls = 0
local timeText
local shieldSpawnTimer
local invincible = false

function scene:create(event)
    local sceneGroup = self.view
    sceneGroup:insert(groupGame)

    -- Remove botões se existiam
    if muteButton then display.remove(muteButton); muteButton = nil end
    if pauseButton then display.remove(pauseButton); pauseButton = nil end
    if playButton then display.remove(playButton); playButton = nil end

    if DevMode and DevMode.isEnabled and DevMode.isEnabled("devShortcuts") then
        local function devShieldShortcut(event)
            if event.phase == "down" and event.keyName == "s" then
                Shield.forceSpawn()
            end
            return false
        end
        Runtime:addEventListener("key", devShieldShortcut)
    end

    local widget = require("widget")
    local physics = require("physics")
    physics.start()
    physics.setGravity(0, 0)

    collisionSound = audio.loadStream("assets/audios/collisionSound.mp3")

    leftWall = display.newRect(0, display.contentHeight / 2, 1, display.contentHeight)
    physics.addBody(leftWall, "static", { density = 3.0, friction = 0.5, bounce = 0 })
    leftWall.myName = "leftWall"
    groupGame:insert(leftWall)
    rightWall = display.newRect(display.contentWidth, display.contentHeight / 2, 1, display.contentHeight)
    physics.addBody(rightWall, "static", { density = 3.0, friction = 0.5, bounce = 0 })
    rightWall.myName = "leftWall"
    groupGame:insert(rightWall)

    local ground = display.newRect(display.contentWidth / 2, 640, display.contentWidth, 110)
    physics.addBody(ground, "static", { friction = 0.3, bounce = 0 })
    ground.myName = "ground"
    ground.objType = "ground"
    groupGame:insert(ground)

    died = false
    paused = false

    local baseline = 400
    local bg1 = display.newImage("assets/background.png")
    groupGame:insert(bg1)
    bg1.x = 0
    bg1.y = baseline - 115
    bg1.yScale = 1.3
    local bg2 = display.newImage("assets/background.png")
    groupGame:insert(bg2)
    bg2.x = 1280
    bg2.y = baseline - 115
    bg2.yScale = 1.3

    local tPrevious = system.getTimer()
    local function move(event)
        if not died then
            local tDelta = event.time - tPrevious
            tPrevious = event.time
            local xOffset = (0.2 * tDelta)
            bg1.x = bg1.x - xOffset
            bg2.x = bg2.x - xOffset
            if (bg1.x + bg1.contentWidth - 400) < 0 then
                bg1:translate(1280 * 2, 0)
            end
            if (bg2.x + bg2.contentWidth - 400) < 0 then
                bg2:translate(1280 * 2, 0)
            end
        end
    end
    Runtime:addEventListener("enterFrame", move)

    local uiGroup = display.newGroup()
    groupGame:insert(uiGroup)

    timeText = display.newText(uiGroup, "Time: 00:00", display.contentWidth / 8, 150, native.systemFont, 36)
    timeText:setFillColor(0, 0, 0)
    groupGame:insert(timeText)

    local fireBallOptions = {
        width = 48,
        height = 48,
        numFrames = 6,
        sheetContentWidth = 288,
        sheetContentHeight = 48
    }
    local fireBallImageSheet = graphics.newImageSheet("assets/sprites/fireball.png", fireBallOptions)
    local fireBallSequenceData = {
        name = "falling",
        time = 800,
        loopCount = 0,
        start = 1,
        count = 6
    }
    fireBallTable = {}

    local function createFireball()
        if not DevMode.isEnabled("noFireball") then
            Fireball.createFireball(groupGame, fireBallImageSheet, fireBallSequenceData, fireBallTable)
            if DevMode.isEnabled("debugPrint") then
                print("[DEV] Fireball criado!")
            end
        end
    end

    local function updateTime(event)
        if not died then
            pastTime = pastTime + 1
            local minutes = math.floor(pastTime / 60)
            local seconds = pastTime % 60
            local timeDisplay = string.format("%02d:%02d", minutes, seconds)
            timeText.text = "Time: " .. timeDisplay
            for i = #fireBallTable, 1, -1 do
                local thisFireBall = fireBallTable[i]
                if (thisFireBall.x < -100 or
                        thisFireBall.x > display.contentWidth + 100 or
                        thisFireBall.y < -100 or
                        thisFireBall.y > display.contentHeight + 100)
                then
                    display.remove(thisFireBall)
                    table.remove(fireBallTable, i)
                    if not died then
                        fireBalls = fireBalls + 1
                    end
                end
            end
        end
    end
    countDownTimer = Timers.performWithDelay(1000, updateTime, pastTime)

    -- Dino
    blue = Dino.new(groupGame)

    createFireball()
    createFireballTimer = Timers.performWithDelay(900, createFireball, 0)

    -- Inicializa o módulo shield!
    Shield.init { group = groupGame, dino = blue }

    -- Timer para tentar spawnar shield
    shieldSpawnTimer = Timers.performWithDelay(1000, Shield.trySpawn, 0)

    local function touchListener(event)
        if not died then
            blue:setLinearVelocity(80, 0)
            if (event.phase == "began") then
                blue:setSequence("running")
            elseif (event.phase == "moved") then
                blue:setLinearVelocity(80, 0)
            else
                blue:setSequence("walking")
                blue:setLinearVelocity(-80, 0)
            end
            blue:play()
            return true
        end
    end
    Runtime:addEventListener("touch", touchListener)

    local function onCollision(event)
        if DevMode.isEnabled("noCollision") then
            if DevMode.isEnabled("debugPrint") then
                print("[DEV] Colisão ignorada!")
            end
            return
        end

        -- COLETOU ESCUDO
        if ((event.object1.myName == "blue" and event.object2.myName == "shieldPowerup") or
                (event.object2.myName == "blue" and event.object1.myName == "shieldPowerup")) then
            Shield.collect()
            print("ESCUDO ATIVADO!")
            return
        end

        -- ESCUDO ATIVO BLOQUEIA MORTE
        if ((event.object1.myName == "blue" and event.object2.myName == "fireball") or
                (event.object1.myName == "fireball" and event.object2.myName == "blue")) then
            if invincible then
                return true         -- Ignora se estiver invencível
            end

            if Shield.active then
                Shield.consume()
                print("ESCUDO SALVOU O DINO!")
                invincible = true
                timer.performWithDelay(600, function() invincible = false end)
                timer.performWithDelay(1, function()
                    blue.x = blue.x - 80
                end)
                return true
            end
            if not DevMode.isEnabled("noDeath") then
                died = true
                audio.play(collisionSound, { channel = 1 })
                display.remove(event.object1)
                display.remove(event.object2)
                for i = #fireBallTable, 1, -1 do
                    if (fireBallTable[i] == event.object1 or fireBallTable[i] == event.object2) then
                        table.remove(fireBallTable, i)
                        break
                    end
                end
                composer.setVariable("finalScore", pastTime)
                composer.gotoScene("scenes.gameover")
            else
                if DevMode.isEnabled("debugPrint") then
                    print("[DEV] Colisão com fireball ignorada! Modo noDeath ativo.")
                end
            end
        elseif ((event.object1.myName == "leftWall" and event.object2.myName == "blue") or
                (event.object1.myName == "blue" and event.object2.myName == "leftWall") or
                (event.object1.myName == "blue" and event.object2.myName == "rightWall") or
                (event.object1.myName == "rightWall" and event.object2.myName == "blue")) then
            blue:setSequence("walking")
            blue:play()
            blue:setLinearVelocity(0, 0)
        end
    end
    Runtime:addEventListener("collision", onCollision)

    -- Função de pause/play
    local function pauseGame()
        if not paused then
            physics.pause()
            if pauseButton then pauseButton.isVisible = false end
            transition.pause()
            Timers.pauseAll()
            if playButton then playButton.isVisible = true end
            paused = true
        else
            if playButton then playButton.isVisible = false end
            if pauseButton then pauseButton.isVisible = true end
            physics.start()
            transition.resume()
            Timers.resumeAll()
            blue:play()
            paused = false
        end
    end

    -- Botões centralizados do módulo ui (só cria 1 vez)
    pauseButton = ui.createPauseButton(groupGame, display.contentWidth - 40, 150, pauseGame)
    playButton  = ui.createPlayButton(groupGame, display.contentWidth - 40, 150, pauseGame)
    muteButton  = MuteButton.new(groupGame, display.contentWidth - 110, 150)

    -- Clamp do dino na tela
    local function clampDino()
        if died or not blue then return end
        local minX = blue.width * blue.xScale * 0.5
        local maxX = display.contentWidth - blue.width * blue.xScale * 0.5
        if blue.x < minX then
            blue.x = minX
            blue:setLinearVelocity(0, 0)
        elseif blue.x > maxX then
            blue.x = maxX
            blue:setLinearVelocity(0, 0)
        end
    end
    Runtime:addEventListener("enterFrame", clampDino)

    -- Visual do escudo ativo
    Runtime:addEventListener("enterFrame", Shield.updateVisual)
end

function scene:hide(event)
    local phase = event.phase
    if (phase == "will") then
        Timers.cancelAll()
    elseif (phase == "did") then
        Runtime:removeEventListener("collision", onCollision)
        display.remove(groupGame)
        if muteButton then display.remove(muteButton); muteButton = nil end
        if pauseButton then display.remove(pauseButton); pauseButton = nil end
        if playButton then display.remove(playButton); playButton = nil end
        Shield.cleanup()
    end
end

function scene:show(event)
    local phase = event.phase
    if (phase == "will") then
        composer.removeScene("menu")
        composer.removeScene("gameover")
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
return scene

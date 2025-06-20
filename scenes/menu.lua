local composer = require("composer")
local ui = require("modules.ui")
local env = require("env")

local scene = composer.newScene()
local groupMenu = display.newGroup()
local contador = 0
local music

function gotoGame()
    audio.pause({channel = 1})
    composer.gotoScene("scenes.game")
end

function gotoRate()
    composer.gotoScene("scenes.rate")
end

function scene:create(event)
    -- Música de fundo do menu, respeitando env.MUTE
    music = audio.loadSound("assets/audios/backmusic.mp3")
    audio.setVolume(env.MUSIC_VOLUME, {channel=2})
    if not env.MUTE then
        audio.play(music, {channel = 2, loops = -1})
    end

    local background = display.newImageRect("assets/background.png", 1280, 720)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    groupMenu:insert(background)

    local logo = display.newImageRect("assets/logo.png", 800, 300)
    logo.x = display.contentCenterX + 10
    logo.y = display.contentCenterY - 100
    groupMenu:insert(logo)

    -- Botões do menu
    local start = ui.createStartButton(groupMenu, display.contentCenterX - 80, display.contentCenterY + 90, gotoGame)
    local rate = ui.createRateButton(groupMenu, display.contentCenterX + 40, display.contentCenterY + 90, gotoRate)
    ui.createMuteButton(groupMenu, display.contentWidth - 40, 150)

    -- Animação dos botões
    function buttonAnimation()
        if(contador >= 0 and contador < 5) then
            start.xScale = 1.1
            start.yScale = 1.1
            rate.xScale = 1.1
            rate.yScale = 1.1
            contador = contador + 1
        elseif(contador >= 5) then
            start.xScale = 1
            start.yScale = 1
            rate.xScale = 1
            rate.yScale = 1
            contador = contador + 1
            if(contador >= 10) then
                contador = 0
            end
        end
    end
    buttonAnimationLoop = timer.performWithDelay(100, buttonAnimation, -1)
end

function scene:hide(event)
    local phase = event.phase
    if (phase == "will") then
        audio.stop(2)
        display.remove(groupMenu)
    end
end

function scene:show(event)
    local phase = event.phase
    if (phase == "will") then
        composer.removeScene("scenes.gameover")
        composer.removeScene("scenes.game")
        composer.removeScene("scenes.rate")
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
return scene

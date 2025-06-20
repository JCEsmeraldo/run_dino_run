---@diagnostic disable: undefined-global
display.setStatusBar(display.HiddenStatusBar)

local composer = require("composer")
audio.setVolume(0.8)  -- volume padrão global

composer.gotoScene("scenes.menu")

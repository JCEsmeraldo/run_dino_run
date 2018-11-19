local composer = require( "composer" )
 
local scene = composer.newScene()
local groupMenu = display.newGroup()
local contador = 0 

function gotoGame() 
	audio.pause( {channel = 1} )
	composer.gotoScene( "scenes.game" )
end

function gotoRate() 
	composer.gotoScene( "scenes.rate" )
end

function scene:create( event )

	-- local menuMusica = audio.loadStream( "menu-musica.wav")
	-- audio.play(menuMusica, {channel = 1, loops = -1})

	local background = display.newImageRect( "assets/background.png", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	groupMenu:insert( background )

	local logo = display.newImageRect( "assets/logo.png", 800, 300 )
	logo.x = display.contentCenterX + 10
	logo.y = display.contentCenterY - 100
	groupMenu:insert( logo )

	local start = display.newImageRect( "assets/buttons/start.png", 120, 70 )
	start.x = display.contentCenterX - 80
	start.y = display.contentCenterY + 90
    groupMenu:insert( start )
    
    local rate = display.newImageRect( "assets/buttons/rate.png", 120, 70 )
	rate.x = display.contentCenterX + 80
	rate.y = display.contentCenterY + 90
	groupMenu:insert( rate )

	start:addEventListener( "tap", gotoGame )

	rate:addEventListener( "tap", gotoRate )

	function buttonAnimation()
		if(contador >= 0 and contador < 5) then
			start.xScale = 1.1
			start.yScale = 1.1
			rate.xScale = 1.1
			rate.xScale = 1.1
            contador = contador + 1
		else if(contador >= 5) then
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
	end
	buttonAnimationLoop = timer.performWithDelay( "100", buttonAnimation, -1 )
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		audio.stop(1)
		display.remove(groupMenu)

	elseif ( phase == "did" ) then
		
	end
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("scenes.gameover")
		composer.removeScene("scenes.game")
		composer.removeScene("scenes.rate")
		-- Code here runs when the scene is still off screen (but is about to come on screen)
 
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
 
	end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
 
return scene
local composer = require( "composer" )
local MuteButton = require("modules.muteButton")
local muteBtn

-- Initialize variables
local json = require( "json" )
 
local scoresTable = {}
 
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local function loadScores()

    local file = io.open( filePath, "r" )
 
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
 
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0, 0, 0, 0, 0 }
    end
end

local function saveScores()
 
    for i = #scoresTable, 6, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end


 
local scene = composer.newScene()
 
function gotoGame() 
	composer.gotoScene( "scenes.game" )
end

function gotoMenu() 
	composer.gotoScene( "scenes.menu" )	
end

function scene:create( event )
	local sceneGroup = self.view


	local background = display.newImageRect( "assets/background.png", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	sceneGroup:insert(background)

	local GameOverText = display.newText(sceneGroup, "GAME OVER", display.contentCenterX - 350, display.contentHeight/2 - 90 , native.systemFont, 50 )
    GameOverText:setFillColor( 0 )
    local ScoreText = display.newText(sceneGroup, (composer.getVariable("finalScore") or 0) .. " Seconds", display.contentCenterX - 350, display.contentHeight/2 - 10, native.systemFont, 36 )
    ScoreText:setFillColor( 0 )

	local jogarNovamente = display.newImageRect( "assets/buttons/restart.png", 120, 120 )
	jogarNovamente.x = 80
	jogarNovamente.y = display.contentCenterY + 90
	sceneGroup:insert(jogarNovamente)

	local inicio = display.newImageRect( "assets/buttons/menu.png", 130, 130 )
	inicio.x = 240
	inicio.y = display.contentCenterY + 90
	sceneGroup:insert(inicio)
	
	jogarNovamente:addEventListener( "tap", gotoGame )
	inicio:addEventListener( "tap", gotoMenu )

	local contador = 0 
	function buttonAnimation()
		if(contador >= 0 and contador < 5) then
			jogarNovamente.xScale = 1.1
			jogarNovamente.yScale = 1.1
			inicio.xScale = 1.1
			inicio.xScale = 1.1
            contador = contador + 1
		else if(contador >= 5) then
			jogarNovamente.xScale = 1
            jogarNovamente.yScale = 1
            inicio.xScale = 1
			inicio.yScale = 1
			contador = contador + 1
			if(contador >= 10) then
				contador = 0
			end
		end
		end
	end
	buttonAnimationLoop = timer.performWithDelay( "100", buttonAnimation, -1 )

	loadScores()
	-- Insert the saved score from the last game into the table, then reset it
	table.insert( scoresTable, composer.getVariable( "finalScore" ) )
	composer.setVariable( "finalScore", 0 )
	
	-- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
	table.sort( scoresTable, compare )
	-- Save the scores
	saveScores()
	
	local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 180, native.systemFont, 44 )
	highScoresHeader:setFillColor( black )
	for i = 1, 5 do
        if ( scoresTable[i] ) then
            local yPos = 210 + ( i * 56 )
			local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, 36 )
            rankNum:setFillColor( 0.6 )
            rankNum.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, scoresTable[i] .. " Seconds", display.contentCenterX-30, yPos, native.systemFont, 36 )
			thisScore:setFillColor( 0 )
			thisScore.anchorX = 0
        end
    end
	muteBtn = MuteButton.new(sceneGroup)

end

function scene:hide( event )
    if muteBtn then display.remove(muteBtn); muteBtn = nil end
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		-- audio.stop(1)
		composer.removeScene( "scenes.gameover" )
	end
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("scenes.menu")
		composer.removeScene("scenes.game")
		
	elseif ( phase == "did" ) then
		
	end
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
--scene:addEventListener( "destroy", scene )
 
return scene
local composer = require( "composer" )

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
	audio.pause( {channel = 1} )
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

	GameOverText = display.newText( uiGroup, "GAME OVER", 160 , display.contentHeight/2 - 50 , native.systemFont, 50 )
	GameOverText:setFillColor( black )
	sceneGroup:insert(GameOverText)
	
	ScoreText = display.newText( uiGroup, pastTime .. " Seconds", 160 , display.contentHeight/2, native.systemFont, 36 )
	ScoreText:setFillColor( black )
	sceneGroup:insert(ScoreText)

	local jogarNovamente = display.newImageRect( "assets/buttons/restart.png", 120, 70 )
	jogarNovamente.x = 80
	jogarNovamente.y = display.contentCenterY + 90
	sceneGroup:insert(jogarNovamente)

	local inicio = display.newImageRect( "assets/buttons/menu.png", 120, 70 )
	inicio.x = 240
	inicio.y = display.contentCenterY + 90
	sceneGroup:insert(inicio)
	
	jogarNovamente:addEventListener( "tap", gotoGame )
	inicio:addEventListener( "tap", gotoMenu )

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

end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		audio.stop(1)
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
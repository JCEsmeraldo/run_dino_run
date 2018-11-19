
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

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
		scoresTable = { 0, 0, 0, 0, 0}
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


function gotoMenu() 
	composer.gotoScene( "scenes.menu" )	
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Load the previous scores
    loadScores()

    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    composer.setVariable( "finalScore", 0 )

    -- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
    table.sort( scoresTable, compare )

    
    local background = display.newImageRect( sceneGroup, "assets/background.png", 1280, 720 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 190, native.systemFont, 44 )
	highScoresHeader:setFillColor( black )
    for i = 1, 5 do
        if ( scoresTable[i] ) then
            local yPos = 210 + ( i * 56 )

            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-85, yPos, native.systemFont, 36 )
            rankNum:setFillColor( 0.6 )
            rankNum.anchorX = 1

            local thisScore = display.newText( sceneGroup, scoresTable[i] .. " Seconds", display.contentCenterX-65, yPos, native.systemFont, 36 )
			thisScore:setFillColor( 0 )
			thisScore.anchorX = 0
        end
    end

    local inicio = display.newImageRect( "assets/buttons/menu.png", 120, 70 )
	inicio.x = display.contentCenterX
	inicio.y = display.contentCenterY + 190
	sceneGroup:insert(inicio)
	inicio:addEventListener( "tap", gotoMenu )
end


function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("scenes.menu")
		composer.removeScene("scenes.game")
		composer.removeScene("scenes.gameover")
		
	elseif ( phase == "did" ) then
		
	end
end


function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then

	elseif ( phase == "did" ) then
		audio.stop(1)
		composer.removeScene( "scenes.rate" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene

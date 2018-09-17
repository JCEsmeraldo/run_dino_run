local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local background = display.newImageRect( "assets/background.png", 1280, 720 )

local dinoOptions =
{
	--required parameters
	width = 24,
	height = 50,
	numFrames = 24,

	--optional parameters; used for scaled content support
	sheetContentWidth = 576,  -- width of original 1x size of entire sheet
	sheetContentHeight = 50   -- height of original 1x size of entire sheet
}
local dinoImageSheet = graphics.newImageSheet( "assets/sprites/blue.png", dinoOptions )


background.anchorX = 0
background.anchorY = 0
background.x = 0
background.y = 0

local function reset_landscape( bg )
	background.x = 0
	transition.to( background, {x=0-1280+480, time=30000, onComplete=reset_landscape} )
end

reset_landscape( background )

-- consecutive frames
local dinoSequenceData =
{
	name="running",
	time = 800,
	loopCount = 0,        -- Optional ; default is 0
	frames = { 4,5,6,7,8,9,10 }
--	loopDirection = "bounce"
}


local blue = display.newSprite( dinoImageSheet, dinoSequenceData )





local fireBallOptions =
{
	--required parameters
	width = 48,
	height = 48,
	numFrames = 6,

	--optional parameters; used for scaled content support
	sheetContentWidth = 288,  -- width of original 1x size of entire sheet
	sheetContentHeight = 48 -- height of original 1x size of entire sheet
}
local fireBallImageSheet = graphics.newImageSheet( "assets/sprites/fireball.png", fireBallOptions )

-- consecutive frames
local fireBallSequenceData =
{
	name="falling",
	time = 800,
	loopCount = 0,        -- Optional ; default is 0
	start = 1,
	count = 6
}





local fireBallTable = {}
local function createFireball()
	local fireball = display.newSprite( fireBallImageSheet, fireBallSequenceData )
	fireball:scale(-1, -1)
	fireball:scale(4, 4)
	fireball.rotation = -85
--	fireball.x = 600
--	fireball.y = 280
	fireball:play()
--	local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 102, 85 )
	table.insert( fireBallTable, fireball )
	physics.addBody( fireball, "dynamic", { radius=40, bounce=0.8 } )
	fireball.myName = "fireball"
	-- From the top
	fireball.x = math.random( display.contentWidth )
	fireball.y = -60
	fireball:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )

--	fireball:applyTorque( math.random( -6,6 ) )
end

local function gameLoop()

	-- Create new asteroid
	createFireball()

	-- Remove asteroids which have drifted off screen
	for i = #fireBallTable, 1, -1 do
		local thisFireBall = fireBallTable[i]

		if ( thisFireBall.x < -100 or
				thisFireBall.x > display.contentWidth + 100 or
				thisFireBall.y < -100 or
				thisFireBall.y > display.contentHeight + 100 )
		then
			display.remove( thisFireBall )
			table.remove( fireBallTable, i )
		end
	end
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )




blue:scale(3, 1.5)
blue.x = 50
blue.y = 558
physics.addBody( blue, { radius=30, isSensor=true } )
blue.myName = "blue"
blue:play()

-- Touch event listener
local function touchListener( event )
	print( "Phase: " .. event.phase )
	print( "Location: " .. tostring(event.x) .. "," .. tostring(event.y) )
	print( "Unique touch ID: " .. tostring(event.id) )
	print( "----------" )
	return true
end
background:addEventListener( "touch", touchListener )

local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "blue" and obj2.myName == "fireball" ) or
				( obj1.myName == "fireball" and obj2.myName == "blue" ) )
		then
			print("Collision")
--			if ( died == false ) then
--				died = true
--
--				-- Update lives
--				lives = lives - 1
--				livesText.text = "Lives: " .. lives
--
--				if ( lives == 0 ) then
--					display.remove( blue )
--				else
--					blue.alpha = 0
-- --					timer.performWithDelay( 1000, restoreShip )
--				end
--			end
		end
	end
end
Runtime:addEventListener( "collision", onCollision )

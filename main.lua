local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")


leftWall = display.newRect(0, display.contentHeight/2, 1, display.contentHeight )
physics.addBody(leftWall, "static", ({density=3.0, friction=0.5, bounce=0}))
leftWall.myName = "leftWall"
rightWall = display.newRect(display.contentWidth, display.contentHeight/2, 1, display.contentHeight )
physics.addBody(rightWall, "static", ({density=3.0, friction=0.5, bounce=0}))
rightWall.myName = "leftWall"

local ground = display.newRect(display.contentWidth/2, 640, display.contentWidth, 90 )
physics.addBody(ground, "static", {density=3.0, friction=0.5, bounce=0})
ground.myName = "ground"

local background = display.newImageRect( "assets/background.png", 1280, 720 )


background.anchorX = 0
background.anchorY = 0
background.x = 0
background.y = 0

local function reset_landscape( bg )
	background.x = 0
	transition.to( background, {x=0-1280+480, time=30000, onComplete=reset_landscape} )
end

reset_landscape( background )

local dinoOptions =
{
	width = 24,
	height = 50,
	numFrames = 24,
	sheetContentWidth = 576,
	sheetContentHeight = 50
}
local dinoImageSheet = graphics.newImageSheet( "assets/sprites/blue.png", dinoOptions )
local dinoSequenceData =
{
	{
		name="walking",
		time = 800,
		loopCount = 0,        -- Optional ; default is 0
		frames = { 4,5,6,7,8,9,10 }
		--	loopDirection = "bounce"
	},
	{
	name="running",
	time = 800,
	loopCount = 0,
	frames = { 18,19,20,21,22,23 }
	}
}

local blue = display.newSprite( dinoImageSheet, dinoSequenceData )
blue:scale(3, 1.5)
blue.x = 50
blue.y = 558
physics.addBody( blue, "dynamic", { radius=30, isSensor=true } )
blue.myName = "blue"
blue:play()

local fireBallOptions =
{
	width = 48,
	height = 48,
	numFrames = 6,
	sheetContentWidth = 288,
	sheetContentHeight = 48
}
local fireBallImageSheet = graphics.newImageSheet( "assets/sprites/fireball.png", fireBallOptions )
local fireBallSequenceData =
{
	name="falling",
	time = 800,
	loopCount = 0,
	start = 1,
	count = 6
}
local fireBallTable = {}
local function createFireball()
	local fireball = display.newSprite( fireBallImageSheet, fireBallSequenceData )
	fireball:scale(-1, -1)
	fireball:scale(4, 4)
	fireball.rotation = -50
	fireball:play()
	table.insert( fireBallTable, fireball )
	physics.addBody( fireball, "kinematic", { radius=40, bounce=0.8 } )
	fireball.myName = "fireball"
	-- From the top
	fireball.x = math.random( display.contentWidth, (display.contentWidth + 80) )
	fireball.y = -60
	fireball:setLinearVelocity( math.random( -140,-10 ), math.random( 40,120 ) )
end

local function gameLoop()
	createFireball()
	-- Remove fireball which have drifted off screen
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
createFireball()



gameLoopTimer = timer.performWithDelay( 900, gameLoop, 0 )
local function touchListener( event )
	if(event.phase == "began" or event.phase == "moved") then
		blue:setSequence("running")
		blue:play()
		blue:setLinearVelocity( 80, 0 )
	else
		blue:setSequence("walking")
		blue:play()
		blue:setLinearVelocity( -80, 0 )
	end
	return true
end
Runtime:addEventListener( "touch", touchListener )

local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "blue" and obj2.myName == "fireball" ) or
				( obj1.myName == "fireball" and obj2.myName == "blue" ) )
		then
			print("Collision")

		elseif ((obj1.myName == "leftWall" and obj2.myName == "blue") or
				(obj1.myName == "blue" and obj2myName == "leftWall") or
				(obj1.myName == "blue" and obj2myName == "rightWall") or
				(obj1.myName == "rightWall" and obj2myName == "blue") )
		then
			blue:setSequence("walking")
			blue:play()
			blue:setLinearVelocity( 0, 0 )
		else

		end
	end
end
Runtime:addEventListener( "collision", onCollision )

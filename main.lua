local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")

local music
music = audio.loadSound( "assets/audios/backmusic.mp3" )
--Faster Does It de Kevin MacLeod está licenciada sob uma licença Creative Commons Attribution (https://creativecommons.org/licenses/by/4.0/)
--Origem: http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100794
--Artista: http://incompetech.com/
audio.play( music )

leftWall = display.newRect(0, display.contentHeight/2, 1, display.contentHeight )
physics.addBody(leftWall, "static", ({density=3.0, friction=0.5, bounce=0}))
leftWall.myName = "leftWall"
rightWall = display.newRect(display.contentWidth, display.contentHeight/2, 1, display.contentHeight )
physics.addBody(rightWall, "static", ({density=3.0, friction=0.5, bounce=0}))
rightWall.myName = "leftWall"

local ground = display.newRect(display.contentWidth/2, 640, display.contentWidth, 110 )
physics.addBody(ground, "static", {density=3.0, friction=0.5, bounce=0})
ground.myName = "ground"

local baseline = 400
local bg1 = display.newImage( "assets/background.png" )
bg1.x = 0
bg1.y = baseline-115
bg1.yScale = 1.3
local bg2 = display.newImage( "assets/background.png" )
bg2.x = 1280
bg2.y = baseline-115
bg2.yScale = 1.3
local tPrevious = system.getTimer()
local function move(event)
	local tDelta = event.time - tPrevious
	tPrevious = event.time

	local xOffset = ( 0.2 * tDelta )
	bg1.x = bg1.x - xOffset
	bg2.x = bg2.x - xOffset

	if (bg1.x + bg1.contentWidth -400) < 0 then
		bg1:translate( 1280 * 2, 0)
	end
	if (bg2.x + bg2.contentWidth -400) < 0 then
		bg2:translate( 1280 * 2, 0)
	end
--	print(display.contentWidth/8)
end
Runtime:addEventListener( "enterFrame", move );

local fireBalls = 0
local time = "00:00"
local died = false
local fireBallsText
local uiGroup = display.newGroup()    -- Display group for UI objects like the fireBalls

local widget = require( "widget" )
 


-- Display lives and fireBalls
fireBallsText = display.newText( uiGroup, "Fire Balls: " .. fireBalls, display.contentWidth - (display.contentWidth/6), 150, native.systemFont, 36 )
fireBallsText:setFillColor( black )
timeText = display.newText( uiGroup, "Time: " .. time, display.contentWidth/8, 150, native.systemFont, 36 )
timeText:setFillColor( black )

local pastTime = 000
 
local function updateTime( event )
	if (died == false) then
		pastTime = pastTime + 1
		local minutes = math.floor( pastTime / 60 )
		local seconds = pastTime % 60
		local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
		timeText.text = "Time: " .. timeDisplay
	end	
end
local countDownTimer = timer.performWithDelay( 1000, updateTime, pastTime )

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
	},
	{
	name="jumping",
	time = 800,
	loopCount = 0,
	frames = { 11,12,13,14 }
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
			if(died == false) then
				fireBalls = fireBalls + 1
				fireBallsText.text = "Fire Balls: " .. fireBalls
			end
		end
	end
end
createFireball()



gameLoopTimer = timer.performWithDelay( 900, gameLoop, 0 )
local function touchListener( event )
	if(died == false) then
		blue:setLinearVelocity( 80, 0 )
		if(event.phase == "began") then
			blue:setSequence("running")
		elseif(event.phase == "moved") then
			blue:setLinearVelocity( 80, 0 )
		else
			blue:setSequence("walking")
			blue:setLinearVelocity( -80, 0 )
		end
		blue:play()
		return true
	end
	
end
Runtime:addEventListener( "touch", touchListener )

jumpingnow = false
-- Function to handle button events
local function jumpButtonEvent( event )
	y = blue.y
	x = blue.x
	if(died == false) then
		
		if(event.phase == "began") then
			jumpingnow = true
			blue:setLinearVelocity( 0, -200 )
			blue:setSequence("jumping")
			
			--blue:applyLinearImpulse(0, -1, blue.x, blue.y)
		else
			jumpingnow = false
			blue:setSequence("walking")
			blue:setLinearVelocity( 80, 200 )
			blue:applyLinearImpulse(0, 0, x, y)
			blue.y = y
			blue.x = x
		end
		blue:play()
		return true
	end
end
 
-- Create the widget
local button1 = widget.newButton(
    {
        left = -40,
        top = 600,
        id = "button1",
        label = "Jump",
        onEvent = jumpButtonEvent
    }
)

local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "blue" and obj2.myName == "fireball" ) or
				( obj1.myName == "fireball" and obj2.myName == "blue" ) )
		then
			died = true
			print("Collision at " .. pastTime)
			local collisionSound
			collisionSound = audio.loadSound( "assets/audios/collisionSound.mp3" )
			audio.play( collisionSound )
--			fireBalls = fireBalls + 100
--			fireBallsText.text = "fireBalls: " .. fireBalls
			display.remove( obj1 )
			display.remove( obj2 )

			for i = #fireBallTable, 1, -1 do
				if ( fireBallTable[i] == obj1 or fireBallTable[i] == obj2 ) then
					table.remove( fireBallTable, i )
					break
				end
			end

			ScoreText = display.newText( uiGroup, "GAME OVER", display.contentWidth/ 2 , display.contentHeight/2 - 50 , native.systemFont, 70 )
			ScoreText:setFillColor( black )
			
			ScoreText = display.newText( uiGroup, pastTime .. " Seconds and " .. fireBalls .. " Fireballs", display.contentWidth/ 2 , display.contentHeight/2, native.systemFont, 36 )
			ScoreText:setFillColor( black )
			
				



		elseif ((obj1.myName == "leftWall" and obj2.myName == "blue") or
				(obj1.myName == "blue" and obj2myName == "leftWall") or
				(obj1.myName == "blue" and obj2myName == "rightWall") or
				(obj1.myName == "rightWall" and obj2myName == "blue") )
		then
			blue:setSequence("walking")
			blue:play()
			blue:setLinearVelocity( 0, 0 )
		elseif ((obj1.myName == "ground" and obj2.myName == "blue") or
		(obj1.myName == "blue" and obj2myName == "ground") )
		then
			blue:setSequence("walking")
			blue:play()
			blue:setLinearVelocity( 0, 0 )	
		else

		end
	end
end
Runtime:addEventListener( "collision", onCollision )

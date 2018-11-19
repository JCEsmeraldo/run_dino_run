local composer = require( "composer" )
local groupGame = display.newGroup()
local scene = composer.newScene()

local background

function scene:create( event )
	local sceneGroup = self.view
	sceneGroup:insert(groupGame)
	
	local widget = require( "widget" )
	local physics = require( "physics" )
	physics.start()
	physics.setGravity( 0, 0 )
	--physics.setDrawMode("hybrid")

	local music
	music = audio.loadSound( "assets/audios/backmusic.mp3" )
	audio.play( music, {channel = 2, loops = -1} )

	leftWall = display.newRect(0, display.contentHeight/2, 1, display.contentHeight )
	physics.addBody(leftWall, "static", ({density=3.0, friction=0.5, bounce=0}))
	leftWall.myName = "leftWall"
	groupGame:insert(leftWall) 
	rightWall = display.newRect(display.contentWidth, display.contentHeight/2, 1, display.contentHeight )
	physics.addBody(rightWall, "static", ({density=3.0, friction=0.5, bounce=0}))
	rightWall.myName = "leftWall"
	groupGame:insert(rightWall)

	local ground = display.newRect(display.contentWidth/2, 640, display.contentWidth, 110 )
	physics.addBody(ground, "static", {density=3.0, friction=0.5, bounce=0})
	ground.myName = "ground"
	groupGame:insert(ground)

	-- local fireBalls = 0
	pastTime = 000
	fireBalls = 0 
	local time = "00:00"
	local died = false

	local baseline = 400
	local bg1 = display.newImage( "assets/background.png" )
	groupGame:insert(bg1)
	bg1.x = 0
	bg1.y = baseline-115
	bg1.yScale = 1.3
	local bg2 = display.newImage( "assets/background.png" )
	groupGame:insert(bg2)
	bg2.x = 1280
	bg2.y = baseline-115
	bg2.yScale = 1.3
	local tPrevious = system.getTimer()
	local function move(event)
		if(died == false) then
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
		end
	end
	Runtime:addEventListener( "enterFrame", move );

	timeText = display.newText( uiGroup, "Time: " .. time, display.contentWidth/8, 150, native.systemFont, 36 )
	timeText:setFillColor( black )
	groupGame:insert(timeText)

	
	
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
		groupGame:insert(fireball)
	end

	local function updateTime( event )
		if (died == false) then
			pastTime = pastTime + 1
			local minutes = math.floor( pastTime / 60 )
			local seconds = pastTime % 60
			local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
			timeText.text = "Time: " .. timeDisplay
			
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
					end
				end
			end
		end	
	end
	countDownTimer = timer.performWithDelay( 1000, updateTime, pastTime )

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

	blue = display.newSprite( dinoImageSheet, dinoSequenceData )
	groupGame:insert(blue)
	blue:scale(3, 1.5)
	blue.x = 50
	blue.y = 558
	physics.addBody( blue, "dynamic", { radius=30, isSensor=true } )
	blue.myName = "blue"
	blue:play()

	createFireball()
	createFireballTimer = timer.performWithDelay( 900, createFireball, 0 )



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

	
	local function onCollision( event )

		if ( event.phase == "began" ) then

			local obj1 = event.object1
			local obj2 = event.object2

			if ( ( obj1.myName == "blue" and obj2.myName == "fireball" ) or
					( obj1.myName == "fireball" and obj2.myName == "blue" ) )
			then
				died = true
				local collisionSound
				collisionSound = audio.loadSound( "assets/audios/collisionSound.mp3" )
				audio.play( collisionSound, {channel = 2} )
				display.remove( obj1 )
				display.remove( obj2 )

				for i = #fireBallTable, 1, -1 do
					if ( fireBallTable[i] == obj1 or fireBallTable[i] == obj2 ) then
						table.remove( fireBallTable, i )
						break
					end
				end
				composer.setVariable( "finalScore", pastTime )
				
				composer.gotoScene("scenes.gameover")

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
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		timer.cancel(createFireballTimer)
		timer.cancel(countDownTimer)
		audio.stop(2)
	elseif ( phase == "did" ) then
		Runtime:removeEventListener( "collision", onCollision )
		Runtime:removeEventListener( "enterFrame", move );
		-- background:addEventListener( "touch", touchListener )
		
		display.remove(groupGame)
	end
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
 
	if ( phase == "will" ) then
		composer.removeScene("menu")
		composer.removeScene("gameover")
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
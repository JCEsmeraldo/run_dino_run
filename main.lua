local composer = require( "composer" ) 


local group = {}

-- Create timer and add it to the table
function timer:createTimer(delay, listener, iterations)

	local id = null

	id = timer.performWithDelay( delay, listener, iterations )

	table.insert(group,id)

	-- Garbage Collection
	if iterations ~= nil and iterations ~= 0 then
		timer.performWithDelay( delay*iterations+100, function(self)
			timer:destroyTimer(id)
		end, 1 )
	end

	return id

end

-- Find ID of timer in table and destroy it
function timer:destroyTimer(id)

	for i=1, table.maxn(group), 1 do
		if group[i] == id then
			timer.cancel(id)
			table.remove(group,i)
			return true
		end
	end

	return false

end

function timer:flushAllTimers()
	
	for i=table.maxn(group), 1, -1 do
		timer.cancel(group[i])
		table.remove(group,i)
	end

end

function timer:pauseAllTimers()

	for i=1, table.maxn(group), 1 do
		timer.pause(group[i])
	end

end

function timer:resumeAllTimers()

	for i=1, table.maxn(group), 1 do
		timer.resume(group[i])
	end

end

---- Uncomment this to see the total number of timer objects in the table
--timer.performWithDelay( 1000, function(self)
-- 		print(table.maxn(group))
-- 	end, 0 )
-- mute = false
audio.setVolume( 0.8 )
function muteGame()
    if (mute == true) then
        audio.setVolume( 0.8 )
        mute = false
        unmuteButton.isVisible = false
        muteButton.isVisible = true
    else
        audio.setVolume( 0 )
        mute = true
        muteButton.isVisible = false
        unmuteButton.isVisible = true
    end
end

muteButton = display.newImageRect( "assets/buttons/mute.png", 70, 70 )
muteButton.x = display.contentWidth - 120
muteButton.y = 150
unmuteButton = display.newImageRect( "assets/buttons/unmute.png", 70, 70 )
unmuteButton.x = display.contentWidth - 120
unmuteButton.y = 150
unmuteButton.isVisible = false
muteButton:addEventListener( "tap", muteGame )
unmuteButton:addEventListener( "tap", muteGame )
-- groupGame:insert( muteButton )

pastTime = 000
fireBalls = 0
time = "00:00"
died = false
uiGroup = display.newGroup()
composer.gotoScene("scenes.menu")
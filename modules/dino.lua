local M = {}

function M.new(group)
    local dinoOptions = {
        width = 24, height = 50, numFrames = 24,
        sheetContentWidth = 576, sheetContentHeight = 50
    }
    local dinoImageSheet = graphics.newImageSheet("assets/sprites/blue.png", dinoOptions)
    local dinoSequenceData = {
        {name="walking", time=800, loopCount=0, frames={4,5,6,7,8,9,10}},
        {name="running", time=800, loopCount=0, frames={18,19,20,21,22,23}},
        {name="jumping", time=800, loopCount=0, frames={11,12,13,14}}
    }

    local dino = display.newSprite(dinoImageSheet, dinoSequenceData)
    dino:scale(3, 1.5)
    dino.x = 50
    dino.y = 558
    physics.addBody(dino, "dynamic", { radius=30, isSensor=true, density=1.0, bounce=0.0 },
        { box={ halfWidth=30, halfHeight=10, x=0, y=60 }, isSensor=true })
    dino.myName = "blue"
    dino:play()
    group:insert(dino)
    return dino
end

return M

GameScene = Object:extend()

function GameScene:new()
    labyrinth = Labyrinth()
    pacman = Pacman(13, 23)
    clyde  = Clyde(12, 14)
    blinky = Blinky(13, 14)
    inky   = Inky(14, 14)
    pinky  = Pinky(15, 14)
end

function GameScene:update(dt)
    timer:update(dt)
    labyrinth:update(dt)
    pacman:update(dt)
    clyde:update(dt)
    blinky:update(dt)
    inky:update(dt)
    pinky:update(dt)
end

function GameScene:draw()
    labyrinth:draw()
    pacman:draw()
    clyde:draw()
    blinky:draw()
    inky:draw()
    pinky:draw()
end
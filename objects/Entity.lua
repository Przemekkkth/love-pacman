Entity = Object:extend()

function Entity:new(tileX, tileY)
    self.tileX = tileX
    self.tileY = tileY + 3
    self.screenPosX  = self.tileX * 16
    self.screenPosY  = self.tileY * 16
    self.direction = "none"
    self.speed = 2
    self.grid = anim8.newGrid( THINGS_IMG_SIZE, THINGS_IMG_SIZE, THINGS_IMG:getWidth(), THINGS_IMG:getHeight() )
    self.alive = true
    self.offset = 7 -- 30px - pacman size 16px - tile size (30px-16px)/2
end

function Entity:posX() 
    return self.screenPosX
end

function Entity:posY() 
    return self.screenPosY
end

function Entity:getTileX()
    return self.tileX
end

function Entity:getTileY()
    return self.tileY
end

function Entity:setTile(x, y)
    self.tileX = x
    self.tileY = y + 3
    self.screenPosX  = self.tileX * 16
    self.screenPosY  = self.tileY * 16
end

function Entity:move(x, y)
    self.screenPosX = self.screenPosX + x
    self.screenPosY = self.screenPosY + y
    local offset = 0

    self:calculateTiles()
end

function Entity:calculateTiles()
    local offset = 0
    if (math.floor(self.screenPosX + offset) % labyrinth.tileSize == 0 and math.floor(self.screenPosY + offset) % labyrinth.tileSize == 0) then
        self.tileX = math.floor((self.screenPosX) / labyrinth.tileSize)
        self.tileY = math.floor((self.screenPosY) / labyrinth.tileSize)
    end
end

function Entity:checkTeleport()
    --convert to Lua coord (0, 0) => (1, 1)
    self:calculateTiles()
    local tempX = self.tileX + 1
    local tempY = self.tileY - 2

    if tempY == 15 and tempX == 0 then
        self:setTile(26, 14)
    elseif tempY == 15 and tempX == 28 then
        self:setTile(1, 14)
    end
end

function Entity:round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function Entity:setAlive(val)
    self.alive = val
end

function Entity:isAlive()
    return self.alive
end

function Entity:setDirection(direction)
    self.direction = direction
end

function Entity:getDirection()
    return self.direction
end

function Entity:isPosYAlignedToGrid()
    return math.floor(self.screenPosY) % labyrinth.tileSize == 0
end

function Entity:isPosXAlignedToGrid()
    return math.floor(self.screenPosX) % labyrinth.tileSize == 0
end
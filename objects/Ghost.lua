Ghost = Object:extend()

function Ghost:new(tileX, tileY)
    self.m_tileX = tileX
    self.m_tileY = tileY + 3
    self.m_screenPosX  = self.m_tileX * 16
    self.m_screenPosY  = self.m_tileY * 16
    self.m_direction = "none"
    self.m_nextMove = nil
    self.m_speed = 2
    self.m_destinationTileX = self.m_tileX
    self.m_destinationTileY = self.m_tileY
    self.m_scattering = false
    self.m_outOfCage = false
    self.m_decision = false
    self.m_frightened = 1000 -- time
    self.m_isAnimated = true

    self.m_grid = anim8.newGrid( THINGS_IMG_SIZE, THINGS_IMG_SIZE, THINGS_IMG:getWidth(), THINGS_IMG:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.m_grid('3-4', 2), 0.02 )
    self.animations.left = anim8.newAnimation( self.m_grid('5-6', 2), 0.02 )
    self.animations.right = anim8.newAnimation( self.m_grid('7-8', 2), 0.02 )
    self.animations.up = anim8.newAnimation( self.m_grid('1-2', 2), 0.02 )

    self.m_anim = self.animations.up
    self.offset = 7 -- 30px - pacman size 16px - tile size (30px-16px)/2

    timer:after(1, function()
         self.m_outOfCage = true
         self.m_direction = 'left'
         self:setTile(12, 11)  
        end)
end

function Ghost:update(dt)
    timer:update(dt)
    self:setDestinationTile(entity:getTileX(), entity:getTileY())
    self:handleMovement()
    self:updateAnim(dt)
end

function Ghost:setDirection(direction)
    self.direction = direction
end

function Ghost:posX() 
    return self.m_screenPosX
end

function Ghost:posX() 
    return self.m_screenPosY
end

function Ghost:getTileX()
    return self.m_tileX
end

function Ghost:getTileY()
    return self.m_tileY
end

function Ghost:getDestX()
    return self.m_destinationTileX
end

function Ghost:getDestY()
    return self.m_destinationTileY
end

function Ghost:setTile(x, y)
    self.m_tileX = x
    self.m_tileY = y + 3
    self.m_screenPosX  = self.m_tileX * 16
    self.m_screenPosY  = self.m_tileY * 16
end

function Ghost:move(x, y)
    self.m_screenPosX = self.m_screenPosX + x
    self.m_screenPosY = self.m_screenPosY + y
    local offset = 0

    self:calculateTiles()
end

function Ghost:calculateTiles()
    local offset = 0
    if (math.floor(self.m_screenPosX + offset) % labyrinth.m_tileSize == 0 and math.floor(self.m_screenPosY + offset) % labyrinth.m_tileSize == 0) then
        self.m_tileX = math.floor((self.m_screenPosX) / labyrinth.m_tileSize)
        self.m_tileY = math.floor((self.m_screenPosY) / labyrinth.m_tileSize)
    end
end

function Ghost:chectTeleport()
    --convert to Lua coord (0, 0) => (1, 1)
    self:calculateTiles()
    local tempX = self.m_tileX + 1
    local tempY = self.m_tileY - 2

    if tempY == 15 and tempX == 0 then
        self:setTile(26, 14)
    elseif tempY == 15 and tempX == 28 then
        self:setTile(1, 14)
    end
end

function Ghost:draw()
    self.m_anim:draw(THINGS_IMG, self.m_screenPosX - self.offset, self.m_screenPosY - self.offset)
end

function Ghost:round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function Ghost:updateAnim(dt)
    if self.m_direction == "none" then
        self.m_anim:gotoFrame(1)
    elseif self.m_direction == "left" then
        self.m_anim = self.animations.left
    elseif self.m_direction == "right" then
        self.m_anim = self.animations.right
    elseif self.m_direction == "up" then
        self.m_anim = self.animations.up
    elseif self.m_direction == "down" then
        self.m_anim = self.animations.down
    end

    self.m_anim:update(dt)
end

function Ghost:setDestinationTile(x, y)
    self.m_destinationTileX = x
    self.m_destinationTileY = y
end

function Ghost:getDestinationTile()
    return self.m_destinationTileX, self.m_destinationTileY
end

function Ghost:setScattering(val)
    self.m_scattering = val
end

function Ghost:isScattering()
    return self.m_scattering
end

function Ghost:setTakeDecision(val)
    self.m_decision = val
end

function Ghost:shouldTakeDecision()
    return self.m_decision
end

function Ghost:handleMovement() 
    if self:isScattering() then
        if self:getTileX() == self:getDestinationTile()[1] and self:getTileY() == self:getDestinationTile()[2] then
            self:setScattering(false)
        end
    end

    local tempX = self.m_tileX + 1
    local tempY = self.m_tileY - 2
    if labyrinth:isMovePoint(tempX, tempY) then
        if self:shouldTakeDecision() then
            local dRight = self:calculateDistance(1, 0)
            local dLeft = self:calculateDistance(-1, 0)
            local dUp = self:calculateDistance(0, -1)
            local dDown = self:calculateDistance(0, 1)
            
            if dRight < dLeft and dRight < dUp and dRight < dDown then
                self:setDirection('right')
                self.m_direction = 'right'
            elseif dLeft < dRight and dLeft < dUp and dLeft < dDown then
                self:setDirection('left')
                self.m_direction = 'left'
            elseif dUp < dLeft and dUp < dRight and dUp < dDown then
                self:setDirection('up')
                self.m_direction = 'up'
            elseif dDown < dLeft and dDown < dUp and dDown < dRight then
                self.m_direction = 'down'
                self:setDirection('down')
            end
       
            self:setTakeDecision(false)
        end
    else
        self:setTakeDecision(true)
    end

    if self:canMove() and self.m_outOfCage then
        if self.m_direction == 'up' then
            self:move(0, -self.m_speed)
        elseif self.m_direction == 'down' then
            self:move(0, self.m_speed)
        elseif self.m_direction == 'right' then
            self:move(self.m_speed, 0)
        elseif self.m_direction == 'left' then
            self:move(-self.m_speed, 0)
        end
    else
        print("cannot move ")
        self:setTakeDecision(true)
    end
end


function Ghost:canMove()
    local tempX = self.m_tileX + 1
    local tempY = self.m_tileY - 2
    print('canMove ', self.m_direction)
    if self.m_direction == 'up' then
        return not labyrinth:isBlockedElement(tempY - 1, tempX)
    elseif self.m_direction == 'down' then
        return not labyrinth:isBlockedElement(tempY + 1, tempX)
    elseif self.m_direction == 'right' then
        return not labyrinth:isBlockedElement(tempY, tempX + 1)
    elseif self.m_direction == 'left' then
        return not labyrinth:isBlockedElement(tempY, tempX - 1)
    end
    return false
end

function Ghost:calculateTiles()
    local offset = 0
    if (math.floor(self.m_screenPosX + offset) % labyrinth.m_tileSize == 0 and math.floor(self.m_screenPosY + offset) % labyrinth.m_tileSize == 0) then
        self.m_tileX = math.floor((self.m_screenPosX) / labyrinth.m_tileSize)
        self.m_tileY = math.floor((self.m_screenPosY) / labyrinth.m_tileSize)
    end
end

function Ghost:calculateDistance(addX, addY)
    local distance = 1000000.0
    local tempX = self.m_tileX + 1
    local tempY = self.m_tileY - 2
    
    if not labyrinth:isBlockedElement(tempY + addY, tempX + addX) then
        distance = math.sqrt(math.pow((self:getDestX() - (self:getTileX() + addX)), 2) + math.pow((self:getDestY() - (self:getTileY() + addY)), 2))
    end

    return distance
end

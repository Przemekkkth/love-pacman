Clyde = Ghost:extend()

function Clyde:new(tileX, tileY)
    Clyde.super.new(self, tileX, tileY)

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('3-4', 2), 0.2 )
    self.animations.left = anim8.newAnimation( self.grid('5-6', 2), 0.2 )
    self.animations.right = anim8.newAnimation( self.grid('7-8', 2), 0.2 )
    self.animations.up = anim8.newAnimation( self.grid('1-2', 2), 0.2 )

    self.anim = self.animations.up

    timer:after(1, function()
        self:setOutOfCage(true)
        self:setTile(12, 11)  
       end)
end

function Clyde:update(dt)
    if not self:isFrightened() then
        self:setDestinationTile(pacman:getTileX(), pacman:getTileY())
    else
        self:setDestinationTile(1, 1) -- avoid pacman
    end
    self:handleMovement()
    self:checkTeleport()
    self:updateAnim(dt)
end

function Clyde:draw()
    self.anim:draw(THINGS_IMG, self.screenPosX - self.offset, self.screenPosY - self.offset)
end

function Clyde:updateAnim(dt)
    if not self:isFrightened() then
        if self:getDirection() == 'none' then
            self.anim:gotoFrame(1)
        elseif self:getDirection() == 'left' then
            self.anim = self.animations.left
        elseif self:getDirection() == 'right' then
            self.anim = self.animations.right
        elseif self:getDirection() == 'up' then
            self.anim = self.animations.up
        elseif self:getDirection() == 'down' then
            self.anim = self.animations.down
        end
    else
        self.anim = self:getFrightenedAnim()
    end

    self.anim:update(dt)
end

function Clyde:calculateDistance(addX, addY)
    local distance = 1000000.0
    local tempX = self.tileX + 1
    local tempY = self.tileY - 2
    
    if not labyrinth:isBlockedElement(tempY + addY, tempX + addX) then
        distance = math.sqrt(math.pow((self:getDestX() - (self:getTileX() + addX)), 2) + math.pow((self:getDestY() - (self:getTileY() + addY)), 2))
    end

    return distance
end

function Clyde:canMove()
    local tempX = self.tileX + 1
    local tempY = self.tileY - 2
    
    if self:getDirection() == 'up' then
        return not labyrinth:isBlockedElement(tempY - 1, tempX)
    elseif self:getDirection() == 'down' then
        return not labyrinth:isBlockedElement(tempY + 1, tempX)
    elseif self:getDirection() == 'right' then
        return not labyrinth:isBlockedElement(tempY, tempX + 1)
    elseif self:getDirection() == 'left' then
        return not labyrinth:isBlockedElement(tempY, tempX - 1)
    end
    return false
end

function Clyde:handleMovement() 
    if not self:isOutOfCage() then
        return
    end

    if self:isScattering() then
        if self:getTileX() == self:getDestX() and self:getTileY() == self:getDestY() then
            self:setScattering(false)
        end
    end

    local tempX = self.tileX + 1
    local tempY = self.tileY - 2
    if labyrinth:isMovePoint(tempX, tempY) then
        if self:shouldTakeDecision() then
            local dRight = self:calculateDistance(1, 0)
            local dLeft  = self:calculateDistance(-1, 0)
            local dUp    = self:calculateDistance(0, -1)
            local dDown  = self:calculateDistance(0, 1)
            
            if dRight < dLeft and dRight < dUp and dRight < dDown then
                self:setDirection('right')
            elseif dLeft < dRight and dLeft < dUp and dLeft < dDown then
                self:setDirection('left')
            elseif dUp < dLeft and dUp < dRight and dUp < dDown then
                self:setDirection('up')
            elseif dDown < dLeft and dDown < dUp and dDown < dRight then
                self:setDirection('down')
            end
       
            self:setTakeDecision(false)
        end
    else
        self:setTakeDecision(true)
    end

    if self:canMove() and self:isOutOfCage() then
        if self:getDirection() == 'up' then
            self:move(0, -self.speed)
        elseif self:getDirection() == 'down' then
            self:move(0, self.speed)
        elseif self:getDirection() == 'right' then
            self:move(self.speed, 0)
        elseif self:getDirection() == 'left' then
            self:move(-self.speed, 0)
        end
    else
        self:setTakeDecision(true)
    end
end

function Clyde:moveToCage()
    self:setOutOfCage(false)
    self:setTile(12, 14)
    timer:after(4, function()
        self:setOutOfCage(true)
        self:setTile(12, 11)  
       end)
end
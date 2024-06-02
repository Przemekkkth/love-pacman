Inky = Ghost:extend()

function Inky:new(tileX, tileY)
    Inky.super.new(self, tileX, tileY)
    self.speed = 1
    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('3-4', 4), 0.2 )
    self.animations.left = anim8.newAnimation( self.grid('5-6', 4), 0.2 )
    self.animations.right = anim8.newAnimation( self.grid('7-8', 4), 0.2 )
    self.animations.up = anim8.newAnimation( self.grid('1-2', 4), 0.2 )

    self.anim = self.animations.up

    timer:after(1.5, function()
        self:setOutOfCage(true)
        self:setTile(15, 11)  
       end)
end

function Inky:update(dt)
    if not self:isFrightened() then
        self:setDestinationTile(pacman:getTileX() + (blinky:getTileX() - pacman:getTileX()), pacman:getTileY() + (blinky:getTileY() - pacman:getTileY())  )
    else
        self:setDestinationTile(1, 1) -- avoid pacman
    end
    self:handleMovement()
    self:checkTeleport()
    self:updateAnim(dt)
end

function Inky:draw()
    self.anim:draw(THINGS_IMG, self.screenPosX - self.offset, self.screenPosY - self.offset)
end

function Inky:updateAnim(dt)
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

function Inky:calculateDistance(addX, addY)
    local distance = 1000000.0
    local tempX = self.tileX + 1
    local tempY = self.tileY - 2
    
    if not labyrinth:isBlockedElement(tempY + addY, tempX + addX) then
        distance = math.sqrt(math.pow((self:getDestX() - (self:getTileX() + addX)), 2) + math.pow((self:getDestY() - (self:getTileY() + addY)), 2))
    end

    return distance
end

function Inky:canMove()
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

function Inky:handleMovement() 
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

function Inky:moveToCage()
    self:setOutOfCage(false)
    self:setTile(14, 14)
    timer:after(4.5, function()
        self:setOutOfCage(true)
        self:setTile(15, 11) 
       end)
end
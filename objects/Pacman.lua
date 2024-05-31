Pacman = Entity:extend()

function Pacman:new(tileX, tileY)
    Pacman.super.new(self, tileX, tileY)

    self.speed = 2.0
    self.nextMove = nil
    self.pickUpSFX = love.audio.newSource('assets/sfx/pacman_chomp.wav', 'static')
    self.pickUpSFX:setVolume(0.5)
    self.animations = {}
    self.animations.down  = anim8.newAnimation( self.grid('4-6', 1), 0.2 )
    self.animations.left  = anim8.newAnimation( self.grid('7-9', 1), 0.2 )
    self.animations.right = anim8.newAnimation( self.grid('10-12', 1), 0.2 )
    self.animations.up    = anim8.newAnimation( self.grid('1-3', 1), 0.2 )
    self.anim = self.animations.down
end

function Pacman:update(dt)
    self:handleMovement()
    local tempX = self.tileX + 1
    local tempY = self.tileY - 2
    if labyrinth:isCollidedWithCoin(tempY, tempX, true) then
        self.pickUpSFX:play()
    elseif labyrinth:isCollidedWithEnergizer(tempY, tempX, true) then
        self.pickUpSFX:play()
    end

    self:checkTeleport()
    self:updateAnim(dt)
end

function Pacman:draw()
    self.anim:draw(THINGS_IMG, self.screenPosX - self.offset, self.screenPosY - self.offset)
end

function Pacman:updateAnim(dt)
    if self:getDirection() == "none" then
        self.anim:gotoFrame(1)
    elseif self:getDirection() == "left" then
        self.anim = self.animations.left
    elseif self:getDirection() == "right" then
        self.anim = self.animations.right
    elseif self:getDirection() == "up" then
        self.anim = self.animations.up
    elseif self:getDirection() == "down" then
        self.anim = self.animations.down
    end

    self.anim:update(dt)
end

function Pacman:handleMovement()
    if self:getDirection() == 'none' then
        self.nextMove = nil
        if input:down('left_arrow') then
            self:setDirection('left')
        elseif input:down('right_arrow') then
            self:setDirection('right')
        elseif input:down('up_arrow') then 
            self:setDirection('up')
        elseif input:down('down_arrow') then 
            self:setDirection('down')
        end
    elseif self:getDirection() == 'left' then
        if input:down('right_arrow') then
            self:setDirection('right')
        elseif input:down('up_arrow') and self:isPosXAlignedToGrid() then
            self.nextMove = 'up'
        elseif input:down('down_arrow') and self:isPosXAlignedToGrid() then
            self.nextMove = 'down'
        end
    elseif self:getDirection() == 'right' then
        if input:down('left_arrow') then
            self:setDirection('left')
        elseif input:down('up_arrow') and self:isPosXAlignedToGrid() then
            self.nextMove = 'up'
        elseif input:down('down_arrow') and self:isPosXAlignedToGrid() then
            self.nextMove = 'down'
        end
    elseif self:getDirection() == 'up' then
        if input:down('down_arrow') then
            self.direction = 'down'
            self:setDirection('down')
        elseif input:down('left_arrow') and self:isPosYAlignedToGrid() then
            self.nextMove = 'left'
        elseif input:down('right_arrow') and self:isPosYAlignedToGrid() then
            self.nextMove = 'right'
        end 
    elseif self:getDirection() == 'down' then
        if input:down('up_arrow') then
            self:setDirection('up')
        elseif input:down('left_arrow') and self:isPosYAlignedToGrid() then
            self.nextMove = 'left'
        elseif input:down('right_arrow') and self:isPosYAlignedToGrid() then
            self.nextMove = 'right'
        end   
    end

    --convert to Lua coord (0, 0) => (1, 1)
    self:calculateTiles()
    local tempX = self.tileX + 1
    local tempY = self.tileY - 2
    if self:getDirection() == 'left' then
        if not labyrinth:isBlockedElement(tempY, tempX - 1) then
            if labyrinth:checkMovePoint(tempX, tempY, self.nextMove) then
                self:setDirection(self.nextMove)
                self.nextMove = nil
            else
                self:move(-self.speed, 0)
            end
        else
            self:setDirection('none')
        end
    elseif self:getDirection() == 'right' then
        if not labyrinth:isBlockedElement(tempY, tempX + 1) then
            if labyrinth:checkMovePoint(tempX, tempY, self.nextMove) then
                self:setDirection(self.nextMove)
                self.nextMove = nil
            else
                self:move(self.speed, 0)
            end
        else
            self:setDirection('none')
        end
    elseif self:getDirection() == 'up' then   
        if not labyrinth:isBlockedElement(tempY - 1, tempX) then
            if labyrinth:checkMovePoint(tempX, tempY, self.nextMove) then
                self:setDirection(self.nextMove)
                self.nextMove = nil
            else
                self:move(0, -self.speed)
            end
        else
            self:setDirection('none')
        end
    elseif self:getDirection() == 'down' then 
        if not labyrinth:isBlockedElement(tempY + 1, tempX) then
            if labyrinth:checkMovePoint(tempX, tempY, self.nextMove) then
                self:setDirection(self.nextMove)
                self.nextMove = nil
            else
                self:move(0, self.speed)
            end
        else
            self:setDirection('none')
        end
    end
end
Entity = Object:extend()

function Entity:new(tileX, tileY)
    self.m_tileX = tileX
    self.m_tileY = tileY + 3
    self.m_screenPosX  = self.m_tileX * 16
    self.m_screenPosY  = self.m_tileY * 16
    self.m_direction = "none"
    self.m_nextMove = nil
    self.m_speed = 2
    self.m_pickUpSFX = love.audio.newSource('assets/sfx/pacman_chomp.wav', 'static')
    self.m_pickUpSFX:setVolume(0.5)
    self.m_grid = anim8.newGrid( THINGS_IMG_SIZE, THINGS_IMG_SIZE, THINGS_IMG:getWidth(), THINGS_IMG:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.m_grid('4-6', 1), 0.2 )
    self.animations.left = anim8.newAnimation( self.m_grid('7-9', 1), 0.2 )
    self.animations.right = anim8.newAnimation( self.m_grid('10-12', 1), 0.2 )
    self.animations.up = anim8.newAnimation( self.m_grid('1-3', 1), 0.2 )

    self.m_anim = self.animations.down
    self.offset = 7 -- 30px - pacman size 16px - tile size (30px-16px)/2
end

function Entity:update(dt)
    if self.m_direction == "none" then
        self.m_nextMove = nil
        if input:down('left_arrow') then
            self.m_direction = "left"
            self.m_screenPosY = self:round(self.m_tileY * labyrinth.m_tileSize)
        elseif input:down('right_arrow') then
            self.m_direction = "right"
            self.m_screenPosY = self:round(self.m_tileY * labyrinth.m_tileSize)
        elseif input:down('up_arrow') then 
            self.m_direction = "up"
            self.m_screenPosX = self:round(self.m_tileX * labyrinth.m_tileSize)
        elseif input:down('down_arrow') then 
            self.m_direction = "down"
            self.m_screenPosX = self:round(self.m_tileX * labyrinth.m_tileSize)
        end
    elseif self.m_direction == "left" then
        if input:down('right_arrow') then
            self.m_direction = 'right'
            self.m_screenPosY = self:round(self.m_tileY * labyrinth.m_tileSize)
        elseif input:down('up_arrow') and math.floor(self.m_screenPosX) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'up'
        elseif input:down('down_arrow') and math.floor(self.m_screenPosX) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'down'
        end
    elseif self.m_direction == "right" then
        if input:down('left_arrow') then
            self.m_direction = 'left'
            self.m_screenPosY = self:round(self.m_tileY * labyrinth.m_tileSize)
        elseif input:down('up_arrow') and math.floor(self.m_screenPosX) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'up'
        elseif input:down('down_arrow') and math.floor(self.m_screenPosX) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'down'
        end
    elseif self.m_direction == "up" then
        if input:down('down_arrow') then
            self.m_direction = 'down'
            self.m_screenPosX = self:round(self.m_tileX * labyrinth.m_tileSize)
        elseif input:down('left_arrow') and math.floor(self.m_screenPosY) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'left'
        elseif input:down('right_arrow') and math.floor(self.m_screenPosY) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'right'
        end 
    elseif self.m_direction == "down" then
        if input:down('up_arrow') then
            self.m_screenPosX = self:round(self.m_tileX * labyrinth.m_tileSize)
            self.m_direction = 'up'
        elseif input:down('left_arrow') and math.floor(self.m_screenPosY) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'left'
        elseif input:down('right_arrow') and math.floor(self.m_screenPosY) % labyrinth.m_tileSize == 0 then
            self.m_nextMove = 'right'
        end   
    end

    --convert to Lua coord (0, 0) => (1, 1)
    self:calculateTiles()
    local tempX = self.m_tileX + 1
    local tempY = self.m_tileY - 2
    if self.m_direction == "left" then
        if not labyrinth:isBlockedElement(tempY, tempX - 1) then
            if labyrinth:checkMovePoint(tempX, tempY, self.m_nextMove) then
                self.m_screenPosY = self:round(self.m_tileY * labyrinth.m_tileSize)
                self.m_direction = self.m_nextMove
                self.m_nextMove = nil
            else
                self:move(-self.m_speed, 0)
            end
        else
            self.m_direction = "none"
        end
    elseif self.m_direction == "right" then
        if not labyrinth:isBlockedElement(tempY, tempX + 1) then
            if labyrinth:checkMovePoint(tempX, tempY, self.m_nextMove) then
                self.m_screenPosY = self:round(self.m_tileY * labyrinth.m_tileSize)
                self.m_direction = self.m_nextMove
                self.m_nextMove = nil
            else
                self:move(self.m_speed, 0)
            end
        else
            self.m_direction = "none"
        end
    elseif self.m_direction == "up" then   
        if not labyrinth:isBlockedElement(tempY - 1, tempX) then
            if labyrinth:checkMovePoint(tempX, tempY, self.m_nextMove) then
                self.m_screenPosX = self:round(self.m_tileX * labyrinth.m_tileSize)
                self.m_direction = self.m_nextMove
                self.m_nextMove = nil
            else
                self:move(0, -self.m_speed)
            end
        else
            self.m_direction = "none"
        end
    elseif self.m_direction == "down" then 
        if not labyrinth:isBlockedElement(tempY + 1, tempX) then
            if labyrinth:checkMovePoint(tempX, tempY, self.m_nextMove) then
                self.m_screenPosX = self:round(self.m_tileX * labyrinth.m_tileSize)
                self.m_direction = self.m_nextMove
                self.m_nextMove = nil
            else
                self:move(0, self.m_speed)
            end
        else
            self.m_direction = "none"
        end
    end

    if labyrinth:isCollidedWithCoin(tempY, tempX, true) then
        self.m_pickUpSFX:play()
    elseif labyrinth:isCollidedWithEnergizer(tempY, tempX, true) then
        self.m_pickUpSFX:play()
    end
    
    self:chectTeleport()
    self:updateAnim(dt)
end

function Entity:posX() 
    return self.m_screenPosX
end

function Entity:posX() 
    return self.m_screenPosY
end

function Entity:getTileX()
    return self.m_tileX
end

function Entity:getTileY()
    return self.m_tileY
end

function Entity:setTile(x, y)
    self.m_tileX = x
    self.m_tileY = y + 3
    self.m_screenPosX  = self.m_tileX * 16
    self.m_screenPosY  = self.m_tileY * 16
end

function Entity:move(x, y)
    self.m_screenPosX = self.m_screenPosX + x
    self.m_screenPosY = self.m_screenPosY + y
    local offset = 0

    self:calculateTiles()
end

function Entity:calculateTiles()
    local offset = 0
    if (math.floor(self.m_screenPosX + offset) % labyrinth.m_tileSize == 0 and math.floor(self.m_screenPosY + offset) % labyrinth.m_tileSize == 0) then
        self.m_tileX = math.floor((self.m_screenPosX) / labyrinth.m_tileSize)
        self.m_tileY = math.floor((self.m_screenPosY) / labyrinth.m_tileSize)
    end
end

function Entity:chectTeleport()
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

function Entity:draw()
    self.m_anim:draw(THINGS_IMG, self.m_screenPosX - self.offset, self.m_screenPosY - self.offset)
end

function Entity:round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end

function Entity:updateAnim(dt)
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
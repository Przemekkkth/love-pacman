Entity = Object:extend()

function Entity:new(tileX, tileY)
    self.m_tileX = tileX
    self.m_tileY = tileY + 3
    self.m_screenPosX  = self.m_tileX * 16
    self.m_screenPosY  = self.m_tileY * 16
    self.m_direction = "none"
    self.m_nextMove = nil
    self.m_speed = 1
    self.m_pickUpSFX = love.audio.newSource('assets/sfx/pacman_chomp.wav', 'static')
    self.m_pickUpSFX:setVolume(0.5)
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
    end
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

function Entity:teleport(x, y)

end

function Entity:draw()
    love.graphics.rectangle('fill', self.m_screenPosX, self.m_screenPosY, 16, 16)
end

function Entity:round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
    end
end
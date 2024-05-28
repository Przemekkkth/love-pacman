Entity = Object:extend()

function Entity:new(tileX, tileY)
    self.m_tileX = tileX
    self.m_tileY = tileY + 3
    self.m_screenPosX  = self.m_tileX * 16
    self.m_screenPosY  = self.m_tileY * 16
    self.m_direction = "none"
end

function Entity:update(dt)
    if input:down('left_arrow') then
        self.m_direction = "left"
        self.m_screenPosY = self:round(self.m_tileY * 16)
    elseif input:down('right_arrow') then
        self.m_direction = "right"
        self.m_screenPosY = self:round(self.m_tileY * 16)
    elseif input:down('up_arrow') then 
        self.m_direction = "up"
        self.m_screenPosX = self:round(self.m_tileX * 16)
    elseif input:down('down_arrow') then 
        self.m_direction = "down"
        self.m_screenPosX = self:round(self.m_tileX * 16)
    end

    --convert to Lua coord (0, 0) => (1, 1)
    self:calculateTiles()
    local tempX = self.m_tileX + 1
    local tempY = self.m_tileY - 2
    if self.m_direction == "left" then
        if not labyrinth:isBlockedElement(tempY, tempX - 1) then
            self:move(-1, 0)
        else
            self.m_direction = "none"
        end
    elseif self.m_direction == "right" then
        self.m_direction = "right"
        if not labyrinth:isBlockedElement(tempY, tempX + 1) then
            self:move(1, 0)
        else
            self.m_direction = "none"
        end
    elseif self.m_direction == "up" then   
        if not labyrinth:isBlockedElement(tempY - 1, tempX) then
            self:move(0, -1)
        else
            self.m_direction = "none"
        end
    elseif self.m_direction == "down" then 
        if not labyrinth:isBlockedElement(tempY + 1, tempX) then
            self:move(0, 1)
        else
            self.m_direction = "none"
        end
    end
end

function Entity:draw()

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
    if (math.floor(self.m_screenPosX + offset) % 16 == 0 and math.floor(self.m_screenPosY + offset) % 16 == 0) then
        self.m_tileX = math.floor((self.m_screenPosX) / 16)
        self.m_tileY = math.floor((self.m_screenPosY) / 16)
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
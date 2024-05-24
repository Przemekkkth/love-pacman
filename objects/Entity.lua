Entity = Object:extend()

function Entity:new(tileX, tileY)
    self.m_tileX = tileX
    self.m_tileY = tileY
    self.m_posX  = 0
    self.m_posY  = 0
    -- m_screenPosX = tilePosX * Resources::LABYRINTH_TILE_SIZE + 8.0f + 8.0f - Resources::THINGS_TILE_SIZE/2;
    -- m_screenPosY = tilePosY * Resources::LABYRINTH_TILE_SIZE + 8.0f - Resources::THINGS_TILE_SIZE/2;
end

function Entity:update(dt)

end

function Entity:draw()

end

function Entity:posX() 
    return self.m_posX
end

function Entity:posX() 
    return self.m_posY
end

function Entity:getTileX()
    return self.m_tileX
end

function Entity:getTileY()
    return self.m_tileY
end

function Entity:move(x, y)
    self.m_posX = self.m_posX + x
    self.m_posY = self.m_posY + y
    --[[
    if ((int)(m_screenPosX + 8 + Resources::THINGS_TILE_SIZE/2) % 16 == 0 && (int)(m_screenPosY + 8 + Resources::THINGS_TILE_SIZE/2) % 16 == 0)
    {
        m_tileX = (int) round((m_screenPosX - 8 + Resources::THINGS_TILE_SIZE/2) / 16);
        m_tileY = (int) round((m_screenPosY - 8 + Resources::THINGS_TILE_SIZE/2) / 16);
    }

    ]]
end

function Entity:teleport(x, y)
--[[
    m_tileX = x;
    m_tileY = y;
    m_screenPosX = x * 16.0f + 8.0f - Resources::THINGS_TILE_SIZE/2;
    m_screenPosY = y * 16.0f + 8.0f - Resources::THINGS_TILE_SIZE/2;
]]
end

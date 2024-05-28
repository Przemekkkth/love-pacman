Pacman = Object:extend()

function Pacman:new()
    self.m_posX  = 1
    self.m_posY  = 1
    self.m_speed = 0.1
    self.m_size = 30
    self.m_direction = "none"
    
    -- m_screenPosX = tilePosX * Resources::LABYRINTH_TILE_SIZE + 8.0f + 8.0f - Resources::THINGS_TILE_SIZE/2;
    -- m_screenPosY = tilePosY * Resources::LABYRINTH_TILE_SIZE + 8.0f - Resources::THINGS_TILE_SIZE/2;
    self.m_grid = anim8.newGrid( self.m_size, self.m_size, THINGS_IMG:getWidth(), THINGS_IMG:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.m_grid('4-6', 1), 0.2 )
    self.animations.left = anim8.newAnimation( self.m_grid('7-9', 1), 0.2 )
    self.animations.right = anim8.newAnimation( self.m_grid('10-12', 1), 0.2 )
    self.animations.up = anim8.newAnimation( self.m_grid('1-3', 1), 0.2 )

    self.m_anim = self.animations.down
end

function Pacman:update(dt)
    local vx = 0
    local vy = 0
    if input:down('left_arrow') then
        self.m_direction = "left"
        self.m_anim = self.animations.left
    elseif input:down('right_arrow') then 
        vx = self.m_speed
        self.m_anim = self.animations.right
        self.m_direction = "right"
    elseif input:down('up_arrow') then 
        vy = self.m_speed * -1
        self.m_direction = "up"
        self.m_anim = self.animations.up
    elseif input:down('down_arrow') then 
        vy = self.m_speed 
        self.m_direction = "down"
        self.m_anim = self.animations.down
    end
    if input:released('p') then
    end

    if self.m_direction == "left" then
        vx = self.m_speed * -1
    elseif self.m_direction == "right" then 
        vx = self.m_speed
    elseif self.m_direction == "up" then 
        vy = self.m_speed * -1
    elseif self.m_direction == "down" then 
        vy = self.m_speed
    end

    if self:checkCollisionWithStaticBlock() == false then
        self.m_posX = self.m_posX + vx 
        self.m_posY = self.m_posY + vy 
        
    end


    if input:released('p') then 
        print("x ", self.m_posX, ' ',self.m_posY)
    end

    self.m_anim:update(dt)
end

function Pacman:checkCollisionWithStaticBlock()

end

function Pacman:draw()
    self.m_anim:draw(THINGS_IMG, self:convertTilesToScreenPos()[1], self:convertTilesToScreenPos()[2])
end

function Pacman:convertTilesToScreenPos()
    return {(labyrinth.OFFSET_X + (self.m_posX  * 16) - self.m_size / 4), labyrinth.OFFSET_Y + (self.m_posY  * 16) - self.m_size / 4}
end

function Pacman:convertScreenPosToTiles()
    --return {labyrinth.OFFSET_X + self.m_posX + self.m_size / 4, labyrinth.OFFSET_Y + self.m_posY + self.m_size / 4}
    return {math.floor(self.m_posX + 1), math.floor(self.m_posY + 1) }
end

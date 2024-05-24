Pacman = Object:extend()

function Pacman:new()
    self.m_posX  = 0
    self.m_posY  = 0
    self.m_speed = 2.5
    -- m_screenPosX = tilePosX * Resources::LABYRINTH_TILE_SIZE + 8.0f + 8.0f - Resources::THINGS_TILE_SIZE/2;
    -- m_screenPosY = tilePosY * Resources::LABYRINTH_TILE_SIZE + 8.0f - Resources::THINGS_TILE_SIZE/2;
    self.m_grid = anim8.newGrid( 30, 30, THINGS_IMG:getWidth(), THINGS_IMG:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.m_grid('4-6', 1), 0.2 )
    self.animations.left = anim8.newAnimation( self.m_grid('7-9', 1), 0.2 )
    self.animations.right = anim8.newAnimation( self.m_grid('10-12', 1), 0.2 )
    self.animations.up = anim8.newAnimation( self.m_grid('1-3', 1), 0.2 )

    self.m_anim = self.animations.down

end

function Pacman:update(dt)
    if input:down('left_arrow') then 
        self.m_posX = self.m_posX - self.m_speed
        self.m_anim = self.animations.left
    elseif input:down('right_arrow') then 
        self.m_posX = self.m_posX + self.m_speed
        self.m_anim = self.animations.right
    elseif input:down('up_arrow') then 
        self.m_posY = self.m_posY - self.m_speed
        self.m_anim = self.animations.up
    elseif input:down('down_arrow') then 
        self.m_posY = self.m_posY + self.m_speed
        self.m_anim = self.animations.down
    end
    self.m_anim:update(dt)
end

function Pacman:draw()
    self.m_anim:draw(THINGS_IMG, self.m_posX, self.m_posY)
end


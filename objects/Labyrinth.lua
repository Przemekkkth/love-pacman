Labyrinth = Object:extend()

function Labyrinth:new()
    self.m_width = 28
    self.m_height = 5
    self.m_tileWidth = 16
    self.m_tileHeight = 16
    self.m_tileSize = 16

    self.m_spritesheet = love.graphics.newImage('assets/sprite/labyrinth.png')
    self.m_tileSprites = generateQuads(self.m_spritesheet, self.m_tileSize, self.m_tileSize)

    self.m_gameMap = sti('assets/maps/map.lua')
end

function Labyrinth:update(dt)

end

function Labyrinth:draw()
    --self.m_gameMap:draw()
    self.m_gameMap:drawLayer(self.m_gameMap.layers["pipes"])
    --gameMap:drawLayer(gameMap.layers["Ground"])
end

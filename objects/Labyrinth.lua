Labyrinth = Object:extend()

function Labyrinth:new()
    self.m_width = 28
    self.m_height = 5
    self.m_tileSize = 16

    self.m_spritesheet = love.graphics.newImage('assets/sprite/labyrinth.png')
    self.m_tileSprites = generateQuads(self.m_spritesheet, self.m_tileSize, self.m_tileSize)

    self.m_gameMap = sti('assets/maps/map.lua')
    self.m_mapCollider = {
        {'############################'},
		{'#............##............#'},
		{'#.####.#####.##.#####.####.#'},
		{'#.####.#####.##.#####.####.#'},
        {'#.####.#####.##.#####.####.#'},
        {'#..........................#'},
        {'#.####.##.########.##.####.#'},
        {'#.####.##.########.##.####.#'},
        {'#......##....##....##......#'},
        {'######.#####.##.#####.######'},
        {'######.#####.##.#####.######'},
        {'######.##..........##.######'},
        {'######.##.########.##.######'},
        {'######.##.########.##.######'},
        {'..........########..........'},
        {'######.##.########.##.######'},
        {'######.##.########.##.######'},
        {'######.##..........##.######'},
        {'######.##.########.##.######'},
        {'######.##.########.##.######'},
        {'#............##............#'},
        {'#.####.#####.##.#####.####.#'},
        {'#.####.#####.##.#####.####.#'},
        {'#...##................##...#'},
        {'###.##.##.########.##.##.###'},
        {'###.##.##.########.##.##.###'},
        {'#......##....##....##......#'},
        {'#.##########.##.##########.#'},
        {'#.##########.##.##########.#'},
        {'#..........................#'},
        {'############################'}
    }
    
    self.OFFSET_X = 0
    self.OFFSET_Y = 3 * 16
end

function Labyrinth:update(dt)

end

function Labyrinth:draw()
    self.m_gameMap:draw()
    love.graphics.setColor(0,1,0)
    for x = 1, Settings.screenWidth / 16 do
        love.graphics.line( x * 16, 0, x * 16, Settings.screenHeight)
    end

    for y = 1, Settings.screenHeight / 16 do
        love.graphics.line( 0, y * 16, Settings.screenWidth, y * 16)
    end

    love.graphics.setColor(1,1,1)
end

function Labyrinth:isBlockedElement(row, col)
    row = math.floor(row)
    col = math.floor(col)
    if row < 1 or row > #self.m_mapCollider then
        return true 
    end

    local line = self.m_mapCollider[row][1]
    if col < 1 or col > #line then
        return true 
    end

    if line:sub(col, col) == '#' then
        return true
    else
        return false
    end
end
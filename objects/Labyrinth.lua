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
		{'#o#  #.#   #.##.#   #.#  #o#'},
        {'#.####.#####.##.#####.####.#'},
        {'#..........................#'},
        {'#.####.##.########.##.####.#'},
        {'#.####.##.###  ###.##.####.#'},
        {'#......##....##....##......#'},
        {'######.#####.##.#####.######'},
        {'     #.##### ## #####.#    #'},
        {'     #.##          ##.#    #'},
        {'     #.## ######## ##.#    #'},
        {'######.## #      # ##.######'},
        {'      .   #      #   .      '},
        {'######.## #      # ##.######'},
        {'#    #.## ######## ##.#    #'},
        {'#    #.##          ##.#    #'},
        {'#    #.##.########.##.#    #'},
        {'######.##.###  ###.##.######'},
        {'#............##............#'},
        {'#.####.#####.##.#####.####.#'},
        {'#.####.#####.##.#####.####.#'},
        {'#o..##................##..o#'},
        {'###.##.##.########.##.##.###'},
        {'###.##.##.###  ###.##.##.###'},
        {'#......##....##....##......#'},
        {'#.#####  ###.##.###  #####.#'},
        {'#.##########.##.##########.#'},
        {'#..........................#'},
        {'############################'}
    }

    self.m_movePoints = {
        {x = 2, y = 2,  movements = {'right', 'down'} },
        {x = 7, y = 2,  movements = {'left', 'right', 'down'} },
        {x = 13, y = 2, movements = {'left', 'down'} },
        {x = 16, y = 2, movements = {'right', 'down'} },
        {x = 22, y = 2, movements = {'left', 'right', 'down'} },
        {x = 27, y = 2, movements = {'left', 'down'} },

        {x = 2,  y = 6, movements = {'right', 'up', 'down'} },
        {x = 7,  y = 6, movements = {'left', 'right', 'up', 'down'} },
        {x = 10, y = 6, movements = {'left', 'right', 'down'} },
        {x = 13, y = 6, movements = {'left', 'right', 'up'} },
        {x = 16, y = 6, movements = {'left', 'right', 'up'} },
        {x = 19, y = 6, movements = {'left', 'right', 'down'} },
        {x = 22, y = 6, movements = {'left', 'right', 'up', 'down'} },
        {x = 27, y = 6, movements = {'left', 'up', 'down'} },

        {x = 2,  y = 9, movements = {'right', 'up'} },
        {x = 7,  y = 9, movements = {'left', 'down'} },
        {x = 10, y = 9, movements = {'right', 'up'} },
        {x = 13, y = 9, movements = {'left', 'down'} },
        {x = 16, y = 9, movements = {'right', 'down'} },
        {x = 19, y = 9, movements = {'left', 'up'} },
        {x = 22, y = 9, movements = {'right', 'up', 'down'} },
        {x = 27, y = 9, movements = {'left', 'up'} },

        {x = 10, y = 12, movements = {'right', 'down'} },
        {x = 13, y = 12, movements = {'left', 'right', 'up'} },
        {x = 16, y = 12, movements = {'left', 'right', 'up'} },
        {x = 19, y = 12, movements = {'left', 'down'} },

        {x = 7,  y = 15, movements = {'left', 'right', 'up', 'down'} },
        {x = 10, y = 15, movements = {'left', 'up', 'down'} },
        {x = 19, y = 15, movements = {'right', 'up', 'down'} },
        {x = 22, y = 15, movements = {'left', 'right', 'up', 'down'} },

        {x = 10, y = 18, movements = {'right', 'up', 'down'} },
        {x = 19, y = 18, movements = {'left', 'up', 'down'} },

        {x = 2, y = 21, movements = {'right', 'down'} },
        {x = 7, y = 21, movements = {'left', 'right', 'up', 'down'} },
        {x = 10, y = 21, movements = {'left', 'right', 'up'} },
        {x = 13, y = 21, movements = {'left', 'down'} },
        {x = 16, y = 21, movements = {'right', 'down'} },
        {x = 19, y = 21, movements = {'left', 'right', 'up'} },
        {x = 22, y = 21, movements = {'left', 'right', 'up', 'down'} },
        {x = 27, y = 21, movements = {'left', 'down'} },

        {x = 2, y = 24, movements = {'right', 'top'} },
        {x = 4, y = 24, movements = {'left', 'down'} },
        {x = 7, y = 24, movements = {'right', 'up', 'down'} },
        {x = 10, y = 24, movements = {'left', 'right', 'down'} },
        {x = 13, y = 24, movements = {'left', 'right', 'up'} },
        {x = 16, y = 24, movements = {'left', 'right', 'up'} },
        {x = 19, y = 24, movements = {'left', 'right', 'down'} },
        {x = 22, y = 24, movements = {'left', 'up', 'down'} },
        {x = 25, y = 24, movements = {'left', 'down'} },
        {x = 27, y = 24, movements = {'left', 'up'} },

        {x = 2, y = 27, movements = {'right', 'down'} },
        {x = 4, y = 27, movements = {'left', 'right', 'up'} },
        {x = 7, y = 27, movements = {'left', 'up'} },
        {x = 10, y = 27, movements = {'right', 'up'} },
        {x = 13, y = 27, movements = {'left', 'down'} },
        {x = 16, y = 27, movements = {'right', 'down'} },
        {x = 19, y = 27, movements = {'right', 'up'} },
        {x = 22, y = 27, movements = {'right', 'up'} },
        {x = 27, y = 27, movements = {'left', 'right', 'up'} },
        {x = 27, y = 27, movements = {'left', 'down'} },

        {x = 2, y = 30, movements = {'right', 'down'} },
        {x = 13, y = 30, movements = {'left', 'right', 'up'} },
        {x = 16, y = 30, movements = {'left', 'right', 'up'} },
        {x = 27, y = 30, movements = {'left', 'up'} }
    }
    
    self.OFFSET_X = 0
    self.OFFSET_Y = 3 * self.m_tileSize
    self.m_debugMode = false
end

function Labyrinth:update(dt)

end

function Labyrinth:draw()
    self.m_gameMap:draw()
    self:drawCoins()
    self:drawEnergizer()

    if self.m_debugMode then
        love.graphics.setColor(0,1,0)
        for x = 1, Settings.screenWidth / self.m_tileSize do
            love.graphics.line( x * self.m_tileSize, 0, x * self.m_tileSize, Settings.screenHeight)
        end

        for y = 1, Settings.screenHeight / self.m_tileSize do
            love.graphics.line( 0, y * self.m_tileSize, Settings.screenWidth, y * self.m_tileSize)
        end
        love.graphics.setColor(1,1,1)
    end
end

function Labyrinth:isBlockedElement(row, col)
    row = math.floor(row)
    col = math.floor(col)
    --telepor areas
    if row == 15 and col == 0 then
        return false
    elseif row == 15 and col == 29 then
        return false
    end

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

function Labyrinth:checkMovePoint(objX, objY, direction)
    for _, point in ipairs(self.m_movePoints) do
        -- Access the x and y coordinates
        local x = point.x
        local y = point.y
        
        if objX == x and objY == y then
            for _, movement in ipairs(point.movements) do
                if direction == movement then
                    return true
                end
            end
        end
    end
    return false
end

function Labyrinth:isCollidedWithCoin(row, col, removeDot)
    if row >= 1 and row <= #self.m_mapCollider and col >= 1 and col <= #self.m_mapCollider[row][1] then
        local line = self.m_mapCollider[row][1]
        if not removeDot and line:sub(col, col) == '.' then
            return true
        end
        
        if line:sub(col, col) == '.' then
            self.m_mapCollider[row][1] = line:sub(1, col - 1) .. ' ' .. line:sub(col + 1)
            return true
        end
    end

    return false
end

function Labyrinth:isCollidedWithEnergizer(row, col, removeEnergizer)
    if row >= 1 and row <= #self.m_mapCollider and col >= 1 and col <= #self.m_mapCollider[row][1] then
        local line = self.m_mapCollider[row][1]
        if not removeEnergizer and line:sub(col, col) == 'o' then
            return true
        end
        
        if line:sub(col, col) == 'o' then
            self.m_mapCollider[row][1] = line:sub(1, col - 1) .. ' ' .. line:sub(col + 1)
            return true
        end
    end

    return false
end

function Labyrinth:drawCoins() 
    for y = 1, #self.m_mapCollider do
        for x = 1, #self.m_mapCollider[y][1] do 
            if self:isCollidedWithCoin(y, x, false) then
                love.graphics.draw(self.m_spritesheet, self.m_tileSprites[23], (x - 1)* self.m_tileSize, (y - 1)* self.m_tileSize + self.OFFSET_Y)
            end
        end
    end
end 

function Labyrinth:drawEnergizer()
    for y = 1, #self.m_mapCollider do
        for x = 1, #self.m_mapCollider[y][1] do 
            if self:isCollidedWithEnergizer(y, x, false) then
                love.graphics.draw(self.m_spritesheet, self.m_tileSprites[31], (x - 1)* self.m_tileSize, (y - 1)* self.m_tileSize + self.OFFSET_Y)
            end
        end
    end
end
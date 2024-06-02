Labyrinth = Object:extend()

function Labyrinth:new()
    self.width = 28
    self.height = 5
    self.tileSize = 16

    self.spritesheet = love.graphics.newImage('assets/sprite/labyrinth.png')
    self.tileSprites = generateQuads(self.spritesheet, self.tileSize, self.tileSize)

    self.gameMap = sti('assets/maps/map.lua')
    self.mapCollider = {
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
        {'#o..##.......  .......##..o#'},
        {'###.##.##.########.##.##.###'},
        {'###.##.##.###  ###.##.##.###'},
        {'#......##....##....##......#'},
        {'#.#####  ###.##.###  #####.#'},
        {'#.##########.##.##########.#'},
        {'#..........................#'},
        {'############################'}
    }

    self.movePoints = {
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
        {x = 25, y = 27, movements = {'left', 'right', 'up'} },
        {x = 27, y = 27, movements = {'left', 'down'} },

        {x = 2, y = 30, movements = {'right', 'down'} },
        {x = 13, y = 30, movements = {'left', 'right', 'up'} },
        {x = 16, y = 30, movements = {'left', 'right', 'up'} },
        {x = 27, y = 30, movements = {'left', 'up'} }
    }
    
    self.OFFSET_X = 0
    self.OFFSET_Y = 3 * self.tileSize
    self.debugMode = false
    self.score = 0
    self.prizes = {'strawberry', 'cherry', 'key', 'bell'}
    self.prize = nil
    self.prizeTable = {}
    self.showPrize = true
    self.lifeImg = love.graphics.newQuad(300, 0, 30, 30, THINGS_IMG)
    self.strawberryImg = love.graphics.newQuad(240, 60, 30, 30, THINGS_IMG)
    self.cherryImg = love.graphics.newQuad(240, 90, 30, 30, THINGS_IMG)
    self.bellImg = love.graphics.newQuad(240, 120, 30, 30, THINGS_IMG)
    self.keyImg = love.graphics.newQuad(270, 60, 30, 30, THINGS_IMG)
    self.prizeName = nil
    self.prizeSFX = love.audio.newSource('assets/sfx/pacman_eatfruit.wav', 'static')
    self.prizeSFX:setVolume(0.5)
    self.lifes = 5
    love.graphics.setFont(FONT)
end

function Labyrinth:update(dt)
    self:collidePacmanWithPrize()
end

function Labyrinth:draw()
    self.gameMap:draw()
    self:drawCoins()
    self:drawEnergizer()
    self:drawScore()
    self:drawPrize()
    self:drawTrophies()
    self:drawLifes()
    if self.debugMode then
        love.graphics.setColor(0,1,0)
        for x = 1, Settings.screenWidth / self.tileSize do
            love.graphics.line( x * self.tileSize, 0, x * self.tileSize, Settings.screenHeight)
        end

        for y = 1, Settings.screenHeight / self.m_tileSize do
            love.graphics.line( 0, y * self.tileSize, Settings.screenWidth, y * self.tileSize)
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

    if row < 1 or row > #self.mapCollider then
        return true 
    end
    local line = self.mapCollider[row][1]
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
    for _, point in ipairs(self.movePoints) do
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

function Labyrinth:isMovePoint(objX, objY)
    for _, point in ipairs(self.movePoints) do
        -- Access the x and y coordinates
        local x = point.x
        local y = point.y
        
        if objX == x and objY == y then
            return true
        end
    end
    return false
end

function Labyrinth:isCollidedWithCoin(row, col, removeDot)
    if row >= 1 and row <= #self.mapCollider and col >= 1 and col <= #self.mapCollider[row][1] then
        local line = self.mapCollider[row][1]
        if not removeDot and line:sub(col, col) == '.' then
            return true
        end
        
        if line:sub(col, col) == '.' then
            self.mapCollider[row][1] = line:sub(1, col - 1) .. ' ' .. line:sub(col + 1)
            return true
        end
    end

    return false
end

function Labyrinth:isCollidedWithEnergizer(row, col, removeEnergizer)
    if row >= 1 and row <= #self.mapCollider and col >= 1 and col <= #self.mapCollider[row][1] then
        local line = self.mapCollider[row][1]
        if not removeEnergizer and line:sub(col, col) == 'o' then
            return true
        end
        
        if line:sub(col, col) == 'o' then
            self.mapCollider[row][1] = line:sub(1, col - 1) .. ' ' .. line:sub(col + 1)
            return true
        end
    end

    return false
end

function Labyrinth:drawCoins() 
    for y = 1, #self.mapCollider do
        for x = 1, #self.mapCollider[y][1] do 
            if self:isCollidedWithCoin(y, x, false) then
                love.graphics.draw(self.spritesheet, self.tileSprites[23], (x - 1)* self.tileSize, (y - 1)* self.tileSize + self.OFFSET_Y)
            end
        end
    end
end 

function Labyrinth:drawEnergizer()
    for y = 1, #self.mapCollider do
        for x = 1, #self.mapCollider[y][1] do 
            if self:isCollidedWithEnergizer(y, x, false) then
                love.graphics.draw(self.spritesheet, self.tileSprites[31], (x - 1)* self.tileSize, (y - 1)* self.tileSize + self.OFFSET_Y)
            end
        end
    end
end

function Labyrinth:drawScore()
    love.graphics.print("Score: "..self.score, 0, 0)
end

function Labyrinth:addScore(val)
    self.score = self.score + val
    if self.score % 105 == 0 and self.score < 106 then
        self:generatePrize()
    elseif self.score % 205 == 0 and self.score < 206 then
        self:generatePrize()
    elseif self.score % 305 == 0 and self.score < 306 then
        self:generatePrize()
    elseif self.score % 405 == 0 and self.score < 406 then
        self:generatePrize()
    elseif self.score % 505 == 0 and self.score < 506 then
        self:generatePrize()
    end
end

function Labyrinth:generatePrize()
    local idx = math.random(1, 4)
    self.showPrize = true
    if idx == 1 then
        self.prize = self.strawberryImg
        self.prizeName = 'strawberry'
    elseif idx == 2 then
        self.prize = self.cherryImg
        self.prizeName = 'cherry'
    elseif idx == 3 then
        self.prize = self.bellImg
        self.prizeName = 'bell'
    elseif idx == 4 then
        self.prize = self.keyImg
        self.prizeName = 'key'
    end
end

function Labyrinth:drawPrize()
    if self.showPrize then
        if self.prize then
            love.graphics.draw(THINGS_IMG, self.prize, 13.5 * self.tileSize - 7, 20 * self.tileSize - 7)
        end
    end
end

function Labyrinth:drawTrophies()
    for i = 1, #self.prizeTable do
       love.graphics.draw(THINGS_IMG, self.prizeTable[i], Settings.screenWidth - (i * 30), Settings.screenHeight - 30)
    end
end

function Labyrinth:drawLifes()
    for i = 0, self.lifes do
        love.graphics.draw(THINGS_IMG, self.lifeImg, (i * 30), Settings.screenHeight - 30)
    end
end

function Labyrinth:decreaseLifes()
    self.lifes = self.lifes - 1
end

function Labyrinth:collidePacmanWithPrize()
    local size = THINGS_IMG_SIZE
    local prizeX = 13.5 * self.tileSize - 7
    local prizeY = 20 * self.tileSize - 7

    if pacman:posX() < prizeX + size and
    pacman:posX() + size         > prizeX and
    pacman:posY() < prizeY + size and
    pacman:posY() + size > prizeY and pacman:isAlive() and self.showPrize then
        if self.prizeName == 'strawberry' then
            table.insert(self.prizeTable, self.strawberryImg)
            self.prizeSFX:play()
        elseif self.prizeName == 'cherry' then
            table.insert(self.prizeTable, self.cherryImg)
            self.prizeSFX:play()
        elseif self.prizeName == 'bell' then
            table.insert(self.prizeTable, self.bellImg)
            self.prizeSFX:play()
        elseif self.prizeName == 'key' then
            table.insert(self.prizeTable, self.keyImg)
            self.prizeSFX:play()
        end
        
        self.showPrize = false
        self.prize = nil
    end
end
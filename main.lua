Object = require 'libraries/classic'
sti = require 'libraries/sti'
anim8 = require 'libraries/anim8'
Input = require 'libraries/boipushy/Input'
Timer = require 'libraries/hump/timer'
require 'utils/Settings'
require 'utils/Utils'


THINGS_IMG = love.graphics.newImage('assets/sprite/things.png')
THINGS_IMG_SIZE = 30
function love.load()
    input = Input()
    timer = Timer()

    input:bind('left', 'left_arrow')
    input:bind('right', 'right_arrow')
    input:bind('up', 'up_arrow')
    input:bind('down', 'down_arrow')
    input:bind('mouse1', 'leftButton')
    input:bind('p', 'p')

    love.window.setTitle(Settings.title)
    love.window.setMode(Settings.screenWidth, Settings.screenHeight)


    --there are base components so its are required first
    require 'objects/Entity'
    require 'objects/Ghost'
    local object_files = {}
    recursiveEnumerate('objects', object_files)
    requireFiles(object_files)

    labyrinth = Labyrinth()
    pacman = Pacman(1, 4)
    clyde  = Clyde(12, 14)
end

function love.update(dt)
    pacman:update(dt)
    clyde:update(dt)
end

function love.draw()
    labyrinth:draw()
    pacman:draw()
    clyde:draw()
end

-- Room --
function gotoRoom(room_type, ...)
    current_room = _G[room_type](...)
end

-- Load --
function recursiveEnumerate(folder, file_list)
    local items = love.filesystem.getDirectoryItems(folder)
    for _, item in ipairs(items) do
        local file = folder .. '/' .. item
        local fileInfo = love.filesystem.getInfo(file)
        if fileInfo.type == "file" then
            table.insert(file_list, file)
        elseif fileInfo.type == "directory" then
            recursiveEnumerate(file, file_list)
        end
    end
end

function requireFiles(files)
    for _, file in ipairs(files) do
        local file = file:sub(1, -5)
        print("File ",file)
        require(file)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
       love.event.quit()
    end
 end

function love.run()
    if love.math then love.math.setRandomSeed(os.time()) end
    if love.load then love.load(arg) end
    if love.timer then love.timer.step() end

    local dt = 0
    local fixed_dt = 1/60
    local accumulator = 0

    while true do
        if love.event then
            love.event.pump()
            for name, a, b, c, d, e, f in love.event.poll() do
                if name == 'quit' then
                    if not love.quit or not love.quit() then
                        return a
                    end
                end
                love.handlers[name](a, b, c, d, e, f)
            end
        end

        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        accumulator = accumulator + dt
        while accumulator >= fixed_dt do
            if love.update then love.update(fixed_dt) end
            accumulator = accumulator - fixed_dt
        end

        if love.graphics and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()
            if love.draw then love.draw() end
            love.graphics.present()
        end

        if love.timer then love.timer.sleep(0.001) end
    end
end
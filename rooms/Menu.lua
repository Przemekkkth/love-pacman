Menu = Object:extend()

function Menu:new()
    self.avatar = love.graphics.newImage('assets/sprite/avatar.png')
    love.graphics.setFont(FONT)
end

function Menu:update(dt)

end

function Menu:draw()
    --love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
    love.graphics.draw(self.avatar, Settings.screenWidth / 2, Settings.screenHeight / 2, 0, 1, 1, self.avatar:getWidth() / 2, self.avatar:getHeight() / 2)
    love.graphics.print("Press 'n' to start", 50, 420)
    love.graphics.print("Press 'bspace' \nto return", 100, 470)
end
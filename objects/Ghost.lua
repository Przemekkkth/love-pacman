Ghost = Entity:extend()

function Ghost:new(tileX, tileY)
    Ghost.super.new(self, tileX, tileY)

    self.destinationTileX = self.tileX
    self.destinationTileY = self.tileY
    self.scattering = false
    self.outOfCage = false
    self.decision = false
    self.frightened = false
    self.frightenedTime = 3
    self.frightenedAnim = anim8.newAnimation( self.grid('9-10', 2), 0.2 )
end

function Ghost:setDestinationTile(x, y)
    self.destinationTileX = x
    self.destinationTileY = y
end

function Ghost:getDestX()
    return self.destinationTileX
end

function Ghost:getDestY()
    return self.destinationTileY
end

function Ghost:setScattering(val)
    self.scattering = val
end 

function Ghost:isScattering()
    return self.scattering
end

function Ghost:setOutOfCage(val)
    self.outOfCage = val
end

function Ghost:isOutOfCage() 
    return self.outOfCage
end

function Ghost:setTakeDecision(val)
    self.decision = val
end

function Ghost:shouldTakeDecision()
    return self.decision
end

function Ghost:isFrightened()
    return self.frightened
end

function Ghost:setFrightened(val)
    self.frightened = val
end

function Ghost:setFrightenedMode()
    if self.outOfCage then
        self.frightened = true
        timer:after(self.frightenedTime, function()
            self.frightened = false
           end)
    end
end

function Ghost:getFrightenedAnim()
    return self.frightenedAnim
end
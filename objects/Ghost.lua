Ghost = Entity:extend()

function Ghost:new(tileX, tileY)
    Pacman.super.new(self, tileX, tileY)

    self.destinationTileX = self.tileX
    self.destinationTileY = self.tileY
    self.scattering = false
    self.outOfCage = false
    self.decision = false
    self.frightened = 1.0 -- time

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
    return self.isOutOfCage
end

function Ghost:setTakeDecision(val)
    self.decision = val
end

function Ghost:shouldTakeDecision()
    return self.decision
end

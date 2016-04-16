Tile = class()

function Tile:cunstruct()
    self.tileType = nil
end

function Tile:SetType(tileType)
    self.tileType = tileType
end

function Tile:GetType()
    return self.tileType
end

function Tile:draw()
    if self.tileType then
        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("fill", 0, 0, 5)
    end
end
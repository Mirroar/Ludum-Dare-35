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
    if self.tileType == 'floor' then
        love.graphics.setColor(64, 64, 64)
        love.graphics.circle("fill", 0, 0, 5)
    elseif self.tileType == 'wall' then
        love.graphics.setColor(192, 192, 192)
        love.graphics.circle("fill", 0, 0, 15)
    end
end
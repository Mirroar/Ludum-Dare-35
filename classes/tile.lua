Tile = class()

function Tile:cunstruct()
    self.tileType = nil
end

function Tile:SetType(tileType)
    self.tileType = tileType

    if tileType == 'food' then
        self.rotation = love.math.random(360)
        self:rotate()
    end
end

function Tile:rotate()
    self.rotation = angle(self.rotation)
    tweens:Tween(self, {rotation = self.rotation + 360}, {duration = 5}, self.rotate)
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
    elseif self.tileType == 'food' then
        love.graphics.setColor(128, 255, 192)
        love.graphics.rotate(angle(self.rotation) * math.pi / 180)
        love.graphics.polygon("fill", 0, -5, 5, 4, -5, 4)
    elseif self.tileType == 'bigfood' then
        love.graphics.setColor(255, 64, 64)
        love.graphics.polygon("fill", 0, -5, 5, 4, -5, 4)
    end
end
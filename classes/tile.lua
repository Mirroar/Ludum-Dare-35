Tile = class()

function Tile:cunstruct()
    self.tileType = nil
end

function Tile:SetType(tileType)
    self.tileType = tileType

    if tileType == 'food' then
        self.rotationSpeed = 5
        self.rotation = love.math.random(360)
        self:rotate()
    elseif tileType == 'exit' then
        self.rotationSpeed = 5
        self.rotation = love.math.random(360)
        self:rotate()
    end
end

function Tile:rotate()
    self.rotation = angle(self.rotation)
    tweens:Tween(
        self,
        {
            rotation = self.rotation + 360
        },
        {
            duration = self.rotationSpeed
        },
        self.rotate
    )
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

    elseif self.tileType == 'exit' then
        love.graphics.rotate(angle(self.rotation) * math.pi / 180)
        love.graphics.setLineWidth(3)
        for i = 1, 8 do
            love.graphics.setColor(HSLToRGB(angle(self.rotation + i * 30) / 360, 1, 0.8))
            --love.graphics.circle("fill", 0, 2, 13)
            love.graphics.arc('line', 0, 10, 10, math.pi, math.pi * 3 / 2)
            love.graphics.rotate(math.pi / 4)
        end
    end
end
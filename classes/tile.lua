Tile = class()

function Tile:cunstruct()
    self.tileType = nil
end

function Tile:SetType(tileType, extra)
    self.tileType = tileType

    if tileType == 'food' then
        self.rotationSpeed = 5
        self.rotation = love.math.random(360)
        self:rotate()
    elseif tileType == 'exit' then
        self.rotationSpeed = 5
        self.rotation = love.math.random(360)
        self:rotate()
    elseif tileType == 'smalldoor' then
        self.exits = extra or {}
    elseif tileType == 'button' then
        self.callbacks = extra or {}
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
    love.graphics.setLineWidth(2)
    if self.tileType == 'floor' then
        love.graphics.setColor(64, 64, 64)
        love.graphics.circle("fill", 0, 0, 4)
        love.graphics.circle("line", 0, 0, 4)

    elseif self.tileType == 'wall' then
        love.graphics.setColor(192, 192, 192)
        love.graphics.circle("fill", 0, 0, 17)
        love.graphics.circle("line", 0, 0, 17)

    elseif self.tileType == 'food' then
        love.graphics.setColor(128, 255, 192)
        love.graphics.rotate(angle(self.rotation) * math.pi / 180)
        love.graphics.polygon("fill", 0, -5, 5, 4, -5, 4)
        love.graphics.polygon("line", 0, -5, 5, 4, -5, 4)

    elseif self.tileType == 'bigfood' then
        love.graphics.setColor(255, 64, 64)
        love.graphics.polygon("fill", 0, -5, 5, 4, -5, 4)
        love.graphics.polygon("line", 0, -5, 5, 4, -5, 4)

    elseif self.tileType == 'smalldoor' then
        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("fill", 0, 0, 15)
        love.graphics.circle("line", 0, 0, 15)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("fill", 0, 0, 6)
        love.graphics.circle("line", 0, 0, 6)
        love.graphics.setLineWidth(14)
        if self.exits.nw then
            love.graphics.line(0, 0, -9, -14)
        end
        if self.exits.ne then
            love.graphics.line(0, 0, 9, -14)
        end
        if self.exits.w then
            love.graphics.line(0, 0, -16, 0)
        end
        if self.exits.e then
            love.graphics.line(0, 0, 16, 0)
        end
        if self.exits.sw then
            love.graphics.line(0, 0, -9, 14)
        end
        if self.exits.se then
            love.graphics.line(0, 0, 9, 14)
        end

        -- Add 'floor' graphic.
        love.graphics.setColor(64, 64, 64)
        love.graphics.setLineWidth(2)
        love.graphics.circle("line", 0, 0, 5)

    elseif self.tileType == 'button' then
        love.graphics.setColor(192, 192, 255)
        love.graphics.circle("fill", 0, 0, 9)
        love.graphics.circle("line", 0, 0, 9)

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
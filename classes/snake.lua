Snake = class()

function Snake:construct(map, coordinates)
    self.map = map
    self.parts = {}

    for i, part in ipairs(coordinates) do
        local type = 'normal'
        if i == 1 or i == #coordinates then
            type = 'head'
        end
        table.insert(self.parts, {
            type = type,
            x = part[1],
            y = part[2],
        })
    end
end

function Snake:draw()
    local previousX, previousY

    for i, part in ipairs(self.parts) do
        local x, y = self.map:GetScreenPosition(part.x, part.y)

        local dx, dy = 0, 0
        if previousX then
            dx = previousX - x
            dy = previousY - y
        end

        love.graphics.push()
        love.graphics.translate(x, y)

        love.graphics.setColor(255, 255, 255)
        love.graphics.setLineWidth(5)
        love.graphics.line(0, 0, dx, dy)

        if part.type == 'normal' then
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', 0, 0, 7)
        elseif part.type == 'head' then
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', 0, 0, 10)
        end

        love.graphics.pop()

        -- Remember coordinates for connecting to next part.
        previousX = x
        previousY = y
    end
end

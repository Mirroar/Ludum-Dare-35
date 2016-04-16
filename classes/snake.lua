Snake = class()

function Snake:construct(map, coordinates)
    self.map = map
    self.parts = {}
    self.mouseRadius = 16
    self.mouseOverPart = nil

    for i, part in ipairs(coordinates) do
        local type = 'normal'
        local size = 7
        if i == 1 or i == #coordinates then
            type = 'head'
            size = 10
        end
        table.insert(self.parts, {
            type = type,
            x = part[1],
            y = part[2],
            size = size,
        })
    end
end

function Snake:update(delta)
    -- Detect if the mouse is over a head part.
    local mouseX, mouseY = love.mouse.getPosition()
    local found = false
    for i, part in ipairs(self.parts) do
        local x, y = self.map:GetScreenPosition(part.x, part.y)
        local dx = x + mapOffset.x - mouseX
        local dy = y + mapOffset.y - mouseY

        if dx * dx + dy * dy < self.mouseRadius * self.mouseRadius then
            self:SetMouseOver(part)
            found = true
            break
        end
    end

    if not found then
        self:SetMouseOver(nil)
    end
end

function Snake:SetMouseOver(part)
    if part ~= self.mouseOverPart then
        if self.mouseOverPart then
            if self.mouseOverPart.type == 'head' then
                tweens:Tween(self.mouseOverPart, {size = 10}, {type = 'square', direction = 'out', duration = 0.5})
            end
        end

        self.mouseOverPart = part

        if part then
            if part.type == 'head' then
                tweens:Tween(part, {size = 12}, {type = 'square', direction = 'out', duration = 0.5})
            end
        end
    end
end

function Snake:IsMouseOverPart(part)
    return part == self.mouseOverPart
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
        love.graphics.setLineWidth(14)
        love.graphics.line(0, 0, dx, dy)

        if part.type == 'normal' then
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', 0, 0, part.size)
        elseif part.type == 'head' then
            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', 0, 0, part.size)
        end

        love.graphics.pop()

        -- Remember coordinates for connecting to next part.
        previousX = x
        previousY = y
    end
end

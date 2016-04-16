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
        if self.map:HitsTile(mouseX, mouseY, part.x, part.y) then
            self:SetMouseOver(part)
            found = true
            break
        end
    end

    if not found then
        self:SetMouseOver(nil)

        -- Check if we moved to an adjacent tile while dragging.
        if self:IsDragging() then
            local part = self.dragging
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if (dx ~= 0 or dy ~= 0) and math.abs(dx + dy) < 2 then
                        if self.map:HitsTile(mouseX, mouseY, part.x + dx, part.y + dy) and self.map:GetTile(part.x + dx, part.y + dy):GetType() ~= 'wall' then
                            print ('dragging to adjacent tile '..(part.x + dx)..', '..(part.y + dy))
                            self:MoveTo(part.x + dx, part.y + dy)
                        end
                    end
                end
            end
        end
    end
end

function Snake:MoveTo(x, y)
    local firstPart = 1
    local lastPart = #self.parts
    local direction = 1
    if self.dragging ~= self.parts[1] then
        -- We're probably dragging the tail end.
        firstPart = lastPart
        lastPart = 1
        direction = -1
    end

    local previousX
    local previousY
    for i = firstPart, lastPart, direction do
        local part = self.parts[i]
        previousX = part.x
        previousY = part.y

        part.x = x
        part.y = y

        x = previousX
        y = previousY
    end
end

function Snake:SetMouseOver(part)
    if part ~= self.mouseOverPart then
        if self.mouseOverPart and not self:IsDragging() then
            if self.mouseOverPart.type == 'head' then
                tweens:Tween(self.mouseOverPart, {size = 10}, {type = 'square', direction = 'out', duration = 0.5})
            end
        end

        self.mouseOverPart = part

        if part and not self:IsDragging() then
            if part.type == 'head' then
                tweens:Tween(part, {size = 12}, {type = 'square', direction = 'out', duration = 0.5})
            end
        end
    end
end

function Snake:IsMouseOverPart(part)
    return part == self.mouseOverPart
end

function Snake:StartDragging(dragging)
    if self.dragging ~= dragging then
        if self.dragging then
            if self.dragging == self.mouseOverPart then
                tweens:Tween(self.dragging, {size = 12}, {type = 'square', direction = 'out', duration = 0.5})
            else
                tweens:Tween(self.dragging, {size = 10}, {type = 'square', direction = 'out', duration = 0.5})
            end
        end

        self.dragging = dragging

        if dragging then
            tweens:Tween(dragging, {size = 15}, {type = 'square', direction = 'out', duration = 0.5})
        end

    end
end

function Snake:IsDragging()
    return self.dragging
end

function Snake:mousepressed(x, y, button, istouch)
    if button == 1 and self.mouseOverPart and self.mouseOverPart.type == 'head' then
        self:StartDragging(self.mouseOverPart)
    end
end

function Snake:mousereleased(x, y, button, istouch)
    if button == 1 and self:IsDragging() then
        self:StartDragging(nil)
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

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
            offsetX = 0,
            offsetY = 0,
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
                    -- Check only adjacent tiles.
                    if (dx ~= 0 or dy ~= 0) and math.abs(dx + dy) < 2 then
                        -- Make sure tile is in bounds.
                        if part.x + dx > 0 and part.y + dy > 0 and part.x + dx <= level.mapWidth and part.y + dy <= level.mapHeight then
                            if self.map:HitsTile(mouseX, mouseY, part.x + dx, part.y + dy) then
                                if self:CanMoveTo(part.x + dx, part.y + dy) then
                                    self:MoveTo(part.x + dx, part.y + dy)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function Snake:CanMoveTo(x, y)
    local firstPart = 1
    local lastPart = #self.parts
    local direction = 1
    if self.dragging ~= self.parts[1] then
        -- We're probably dragging the tail end.
        firstPart = lastPart
        lastPart = 1
        direction = -1
    end

    for i = firstPart, lastPart, direction do
        local part = self.parts[i]

        if not self:CanPartMoveTo(part, x, y) then
            return false
        end

        x = part.x
        y = part.y
    end

    return true
end

function Snake:CanPartMoveTo(part, x, y)
    if self.map:GetTile(x, y):GetType() ~= 'floor' then
        return false
    end

    local dx = part.x - x
    local dy = part.y - y
    local entity = entities:GetTile(x, y)
    if entity and entity:GetType() == 'smalldoor' then
        if part.type == 'fat' then
            return false
        end

        -- Make sure we can only enter from opened directions.
        local direction = self:ParseDirection(dx, dy)

        if direction and not entity.exits[direction] then
            return false
        end
    end

    local entity = entities:GetTile(part.x, part.y)
    if entity and entity:GetType() == 'smalldoor' then
        -- Make sure we can only exit towards opened directions.
        local direction = self:ParseDirection(-dx, -dy)

        if direction and not entity.exits[direction] then
            return false
        end
    end

    return true
end

-- Determines direction name from given coordinate difference.
function Snake:ParseDirection(dx, dy)
    local direction = nil
    if dy == -1 then
        if dx == 0 then
            direction = 'nw'
        elseif dx == 1 then
            direction = 'ne'
        end
    elseif dy == 0 then
        if dx == -1 then
            direction = 'w'
        elseif dx == 1 then
            direction = 'e'
        end
    elseif dy == 1 then
        if dx == -1 then
            direction = 'sw'
        elseif dx == 0 then
            direction = 'se'
        end
    end

    return direction
end

-- Moves the currently dragged head to a new position, dragging the rest
-- of the snake behind it.
function Snake:MoveTo(x, y)
    local add = nil
    local size = 7
    if entities:GetTile(x, y):GetType() == 'food' then
        add = 'normal'
        entities:GetTile(x, y):SetType(nil)
        level:EntityEaten('food', x, y)
    elseif entities:GetTile(x, y):GetType() == 'bigfood' then
        add = 'fat'
        size = 12
        entities:GetTile(x, y):SetType(nil)
        level:EntityEaten('bigfood', x, y)
    elseif entities:GetTile(x, y):GetType() == 'exit' then
        level:OnExit()
    end

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

        if add and i ~= firstPart then
            if direction == -1 then
                i = i + 1
            end
            table.insert(self.parts, i, {
                type = add,
                x = x,
                y = y,
                size = size,
                offsetX = 0,
                offsetY = 0,
            })

            -- We added a new part, so all other parts do not need to be moved.
            break
        end

        previousX = part.x
        previousY = part.y

        local oldScreenX, oldScreenY = self.map:GetScreenPosition(previousX, previousY)
        local screenX, screenY = self.map:GetScreenPosition(x, y)
        part.offsetX = oldScreenX - screenX + part.offsetX
        part.offsetY = oldScreenY - screenY + part.offsetY
        tweens:Tween(
            part,
            {
                offsetX = 0,
                offsetY = 0,
            },
            {
                duration = 0.3,
                type = 'square',
                direction = 'out',
            }
        )

        part.x = x
        part.y = y

        x = previousX
        y = previousY
    end
end

function Snake:IsOn(x, y)
    for i = 1, #self.parts do
        local part = self.parts[i]
        if part.x == x and part.y == y then
            return true
        end
    end

    return false
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

    local hue = -5 * #self.parts + 180
    for i, part in ipairs(self.parts) do
        local x, y = self.map:GetScreenPosition(part.x, part.y)

        local dx, dy = 0, 0
        if previousX then
            dx = previousX - x
            dy = previousY - y
        end

        love.graphics.push()
        love.graphics.translate(x + part.offsetX, y + part.offsetY)

        if i > 1 then
            love.graphics.setColor(HSLToRGB(angle(hue) / 360, 1, 0.8))
            love.graphics.setLineWidth(14)
            love.graphics.line(0, 0, dx - part.offsetX, dy - part.offsetY)
        end

        hue = hue + 10
        local r, g, b = HSLToRGB(angle(hue) / 360, 1, 0.8)
        if part.type == 'normal' then
            love.graphics.setColor(r, g, b)
            love.graphics.circle('fill', 0, 0, part.size)
        elseif part.type == 'fat' then
            love.graphics.setColor(r, g, b)
            love.graphics.circle('fill', 0, 0, part.size)
        elseif part.type == 'head' then
            love.graphics.setColor(r, g, b)
            love.graphics.circle('fill', 0, 0, part.size)
        end

        love.graphics.pop()

        -- Remember coordinates for connecting to next part.
        previousX = x + part.offsetX
        previousY = y + part.offsetY
    end
end

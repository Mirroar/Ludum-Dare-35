Log = class()

-- Constructs a new message log object.
function Log:construct(numLines)
    self.numLines = numLines or 5
    self.lines = {}
end

-- Adds a message to this log.
function Log:insert(text, prefix, tileIcon, padding)
    padding = padding or ''
    table.insert(self.lines, {
        text = text and padding..text..padding,
        prefix = prefix,
        tileIcon = tileIcon,
    })
end

-- Removes all messages from this log.
function Log:clear()
    self.lines = {}
end

function Log:draw()
    love.graphics.setColor(255, 255, 255, 255)
    local count = math.max(0, self.numLines - #self.lines)
    for i = math.max(1, #self.lines - self.numLines + 1), #self.lines do
        local line = self.lines[i]
        if line.prefix then
            love.graphics.print(line.prefix, 20, count * 20)
        end
        if line.text then
            love.graphics.print(line.text, 60, count * 20)
        end
        if line.tileIcon then
            textures:DrawSprite(line.tileIcon, 0, count * 20)
        end

        count = count + 1
    end
end
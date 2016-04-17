StickLevel = class(Level)
levels.stick = StickLevel

local mapStrings = {
    map = {
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '.................',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
    },
    entities = {
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '                x',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
    },
}

function StickLevel:construct()
    Level.construct(self, 17, 11)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a snake.
    snake = Snake(map, {{1, 6}, {2, 6}, {3, 6}})
end

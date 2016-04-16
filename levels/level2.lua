Level2 = class(Level)
levels.level2 = Level2

local mapStrings = {
    map = {
        '   ....',
        '  .....',
        ' ....##',
        '.......',
        '....## ',
        '.....  ',
        '....   ',
    },
    entities = {
        '       ',
        '       ',
        '  oOO  ',
        '      x',
        ' oOO   ',
        '       ',
        '       ',
    },
}

function Level2:construct()
    Level.construct(self, 7, 7)

    self.mapOffset.x = -15
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a small door.
    entities:GetTile(5, 4):SetType('smalldoor', {
        nw = true,
        ne = false,
        w = true,
        e = true,
        sw = true,
        se = false,
    })

    -- Add a snake.
    snake = Snake(map, {{4, 1}, {5, 1}, {6, 1}})
end

function Level2:OnExit()
    Level.OnExit(self)
    LoadLevel('sandbox')
end

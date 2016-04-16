Level1 = class(Level)
levels.level1 = Level1

local mapStrings = {
    map = {
        '  ...',
        ' ###.',
        '#..#.',
        '.##. ',
        '...  ',
    },
    entities = {
        '     ',
        '    o',
        '  x  ',
        '     ',
        ' o   ',
    },
}

function Level1:construct()
    Level.construct(self, 5, 5)

    self.mapOffset.x = -15
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    entities:GetTile(3, 3):SetType('exit')

    -- Add a snake.
    snake = Snake(map, {{3, 1}, {4, 1}})
end

function Level1:OnExit()
    Level.OnExit(self)
    LoadLevel('level2')
end

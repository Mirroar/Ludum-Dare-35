Level2 = class(Level)
levels.level2 = Level2

local mapStrings = {
    '   ....',
    '  .....',
    ' ......',
    '.......',
    '...... ',
    '.....  ',
    '....   ',
}

function Level2:construct()
    Level.construct(self, 7, 7)

    self.mapOffset.x = -15
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    entities:GetTile(3, 3):SetType('exit')

    -- Add a snake.
    snake = Snake(map, {{3, 1}, {4, 1}})
end

function Level2:OnExit()
    Level.OnExit(self)
    LoadLevel('sandbox')
end

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

    self.mapOffset.x = 0
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    entities:GetTile(3, 3):SetType('exit')

    -- Add a snake.
    snake = Snake(map, {{3, 1}, {4, 1}})

    self.sentText = false
end

-- Gets called when an entity is eaten, for the level to respond.
function Level1:EntityEaten(entityType, x, y)
    if entityType == 'food' and not self.sentText then
        log:insert("Eating green pellets will make you longer.")
        self.sentText = true
    end
end

-- Gets called when the player reaches the exit.
function Level1:OnExit()
    Level.OnExit(self)

    snake:ExitLevel(function ()
        LoadLevel('level2')
    end)
end

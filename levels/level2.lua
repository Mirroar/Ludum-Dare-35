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
        '   OO  ',
        '      x',
        '  OO   ',
        '       ',
        '       ',
    },
}

function Level2:construct()
    Level.construct(self, 7, 7)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a small door.
    entities:GetTile(5, 4):SetType('smalldoor', {
        w = true,
        e = true,
    })
    entities:GetTile(6, 4):SetType('smalldoor', {
        w = true,
        e = true,
    })

    -- Add a snake.
    snake = Snake(map, {{4, 1}, {5, 1}, {6, 1}})
end

-- Gets called when an entity is eaten, for the level to respond.
function Level2:EntityEaten(entityType, x, y)
    if entityType == 'bigfood' and not self.sentText then
        log:insert("Eating red pellets will also make you fat. You will not fit through tight spaces this way.")
        log:insert("You may press 'R' to retry the current level.")
        self.sentText = true
    end
end

-- Gets called when the player reaches the exit.
function Level2:OnExit()
    Level.OnExit(self)
    LoadLevel('sandbox')
end

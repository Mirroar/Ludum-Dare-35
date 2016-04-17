Level2 = class(Level)
levels.level2 = Level2

local mapStrings = {
    map = {
        '      ###',
        '     #..#',
        '    #...#',
        '    #.## ',
        '  ##...##',
        ' #.#.....',
        '#.#..#...',
        '#..##... ',
        '### #..  ',
    },
    entities = {
        '         ',
        '         ',
        '         ',
        '     +   ',
        '         ',
        '     o+oo',
        ' * +     ',
        ' Oo   O  ',
        '      x  ',
    },
}

function Level2:construct()
    Level.construct(self, 9, 9)

    self.mapOffset.x = -32
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add doors.
    entities:GetTile(4, 7).exits.ne = true
    entities:GetTile(4, 7).exits.sw = true
    entities:GetTile(6, 4).exits.nw = true
    entities:GetTile(6, 4).exits.se = true

    entities:GetTile(2, 7).callbacks.press = function()
        entities:GetTile(7, 6).exits.e = true
        entities:GetTile(7, 6).exits.w = true
    end

    -- Add a snake.
    snake = Snake(map, {{7, 2}, {8, 2}, {8, 3}, {7, 3}})
end

-- Gets called when an entity is eaten, for the level to respond.
function Level2:EntityEaten(entityType, x, y)
    if entityType == 'bigfood' and not self.sentText then
        log:insert("After eating a red pellet, snake will not fit through tight spaces.")
        log:insert("You may press 'R' to retry the current level.")
        self.sentText = true
    end
end

-- Gets called when the player reaches the exit.
function Level2:OnExit()
    Level.OnExit(self)

    snake:ExitLevel(function ()
        LoadLevel('sandbox')
    end)
end

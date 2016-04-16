TwoHeadsLevel = class(Level)
levels.twoheads = TwoHeadsLevel

local mapStrings = {
    map = {
        '   ########',
        '  #########',
        ' #........#',
        '#.#######.#',
        '#...##...# ',
        '#########  ',
        '########   ',
    },
    entities = {
        '           ',
        '           ',
        '           ',
        '           ',
        '   o  o    ',
        '           ',
        '           ',
    },
}

function TwoHeadsLevel:construct()
    Level.construct(self, 11, 7)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a snake.
    snake = Snake(map, {{4, 3}, {5, 3}, {6, 3}, {7, 3}, {8, 3}, {9, 3}})

    log:insert("Due to using too many portals however, snake now has two heads.")
end

-- Gets called when an entity is eaten, for the level to respond.
function TwoHeadsLevel:EntityEaten(entityType, x, y)
    if #snake.parts > 6 then
        self:SpawnEntity('exit')
    end
end

-- Gets called when the player reaches the exit.
function TwoHeadsLevel:OnExit()
    Level.OnExit(self)

    snake:ExitLevel(function ()
        LoadLevel('seesaw')
    end)
end

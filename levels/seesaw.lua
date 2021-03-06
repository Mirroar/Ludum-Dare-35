SeeSawLevel = class(Level)
levels.seesaw = SeeSawLevel

local mapStrings = {
    map = {
        '   ...#####',
        '  ###.#####',
        ' #..#.#...#',
        '#.##...##.#',
        '#...#.#..# ',
        '#####.###  ',
        '#####...   ',
    },
    entities = {
        '           ',
        '           ',
        '   o       ',
        '           ',
        '           ',
        '           ',
        '           ',
    },
}

function SeeSawLevel:construct()
    Level.construct(self, 11, 7)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a snake.
    snake = Snake(map, {{4, 1}, {5, 1}, {6, 1}})

    self.foodCount = 0
end

-- Gets called when an entity is eaten, for the level to respond.
function SeeSawLevel:EntityEaten(entityType, x, y)
    if entityType == 'food' then
        if self.foodCount % 2 == 0 then
            entities:GetTile(8, 5):SetType('food')
        else
            entities:GetTile(4, 3):SetType('food')
        end
        self.foodCount = self.foodCount + 1

        if self.foodCount == 8 then
            entities:GetTile(8, 7):SetType('exit')
            log:insert('If snake eats too much, there might not be a way back. Or sideways, in this case...')
        elseif self.foodCount == 11 then
            entities:GetTile(8, 5):SetType('exit')
            log:insert('Fortunately, it seems there is always a way out.')
        end
    end
end

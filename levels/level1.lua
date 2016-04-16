Level1 = class(Level)
levels.level1 = Level1

function Level1:construct()
    Level.construct(self, 5, 5)

    self.mapOffset.x = -15
    self.mapOffset.y = 50

    -- Initialize map.
    for x = 1, self.mapWidth do
        for y = 1, self.mapHeight do
            if x + y > math.min(self.mapWidth, self.mapHeight) / 2 + 1 then
                if x + y < math.max(self.mapWidth, self.mapHeight) + math.min(self.mapWidth, self.mapHeight) / 2 + 1 then
                    map:GetTile(x, y):SetType('floor')
                end
            end
        end
    end

    entities:GetTile(3, 3):SetType('exit')

    -- Add a snake.
    snake = Snake(map, {{3, 1}, {3, 2}})
end

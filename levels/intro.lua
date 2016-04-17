IntroLevel = class(Level)
levels.intro = IntroLevel

function IntroLevel:construct()
    Level.construct(self, 11, 11)

    self.mapOffset.x = 0
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

    self:SpawnEntity('food')

    -- Add a snake.
    snake = Snake(map, {{5, 5}, {5, 6}, {6, 6}})
    snake.parts[3].type = 'normal'
    snake.parts[3].size = 7

    log:insert("Meet snake. Snake is a snake.")
    log:insert("You can help snake move by dragging its head.")
end

-- Gets called when an entity is eaten, for the level to respond.
function IntroLevel:EntityEaten(entityType, x, y)
    if entityType == 'food' then
        if not self.sentText then
            log:insert("Eating green pellets helps snake with growing.")
            self.sentText = true
        end
        if #snake.parts == 5 then
            self:SpawnEntity('bigfood')
        elseif #snake.parts == 10 then
            self:SpawnEntity('exit')
        else
            self:SpawnEntity('food')
        end
    elseif entityType == 'bigfood' then
        log:insert("Eating red pellets also helps snake with growing. A bit more than necessary, some might say.")
        self:SpawnEntity('food')
    end
end

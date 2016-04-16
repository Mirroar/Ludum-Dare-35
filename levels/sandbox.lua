SandboxLevel = class(Level)
levels.sandbox = SandboxLevel

function SandboxLevel:construct()
    Level.construct(self, 15, 15)

    self.mapOffset.x = -80
    self.mapOffset.y = 50

    -- Initialize map.
    for x = 1, self.mapWidth do
        for y = 1, self.mapHeight do
            if x + y > math.min(self.mapWidth, self.mapHeight) / 2 + 1 then
                if x + y < math.max(self.mapWidth, self.mapHeight) + math.min(self.mapWidth, self.mapHeight) / 2 + 1 then
                    if love.math.random() < 0.9 or x == 8 then
                        map:GetTile(x, y):SetType('floor')
                    else
                        map:GetTile(x, y):SetType('wall')
                    end
                end
            end
        end
    end

    -- Add entities to collect.
    self:SpawnEntity('food')
    self:SpawnEntity('food')
    self:SpawnEntity('bigfood')

    self:SpawnEntity('smalldoor', {
        nw = love.math.random() < 0.5,
        ne = love.math.random() < 0.5,
        w = love.math.random() < 0.5,
        ne = love.math.random() < 0.5,
        sw = love.math.random() < 0.5,
        se = love.math.random() < 0.5,
    })
    self:SpawnEntity('smalldoor', {
        nw = love.math.random() < 0.5,
        ne = love.math.random() < 0.5,
        w = love.math.random() < 0.5,
        ne = love.math.random() < 0.5,
        sw = love.math.random() < 0.5,
        se = love.math.random() < 0.5,
    })

    -- Add a snake.
    snake = Snake(map, {{8, 8}, {8, 9}, {8, 10}, {8, 11}, {8, 12}})
end

function SandboxLevel:EntityEaten(entityType, x, y)
    Level.EntityEaten(self, entityType, x, y)

    if entityType == 'food' then
        self:SpawnEntity(entityType)
    end
end

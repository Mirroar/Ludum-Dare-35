Level = class()

function Level:construct()
    self.mapOffset = {
        x = 0,
        y = 0,
    }
end

function Level:SpawnEntity(entityType)
    -- TODO: Make sure this doesn't spawn in the snake, either.
    local done = false
    while not done do
        local x = love.math.random(mapWidth)
        local y = love.math.random(mapHeight)

        if map:GetTile(x, y):GetType() == 'floor' and entities:GetTile(x, y):GetType() == nil then
            entities:GetTile(x, y):SetType(entityType)
            done = true
        end
    end
end

function Level:EntityEaten(entityType, x, y)
end

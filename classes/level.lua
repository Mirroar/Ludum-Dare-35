Level = class()

function Level:construct(mapWidth, mapHeight)
    self.mapOffset = {
        x = 0,
        y = 0,
    }

    self.mapWidth = mapWidth
    self.mapHeight = mapHeight

    -- Initialize map container.
    map = Map(mapWidth, mapHeight)
    map:SetTileOffset(1, 32, 0)
    map:SetTileOffset(2, 16, 28)

    -- Initialize entities container.
    entities = Map(mapWidth, mapHeight)
    entities:SetTileOffset(1, 32, 0)
    entities:SetTileOffset(2, 16, 28)

    -- Spawning the snake is the responsibility of the actual level
    -- implementation.
end

local mapKey = {
    [' '] = nil,
    ['.'] = 'floor',
    ['#'] = 'wall',
    ['x'] = 'exit',
    ['o'] = 'food',
    ['O'] = 'bigfood',
}

-- Loads a map from an array of strings.
function Level:LoadMap(mapStrings)
    for mapName, strings in pairs(mapStrings) do
        for y = 1, #strings do
            local row = strings[y]
            for x = 1, string.len(row) do
                local char = string.sub(row, x, x)
                if mapKey[char] then
                    _G[mapName]:GetTile(x, y):SetType(mapKey[char])
                end
            end
        end
    end
end

function Level:SpawnEntity(entityType, ...)
    -- TODO: Make sure this doesn't spawn in the snake, either.
    local done = false
    while not done do
        local x = love.math.random(self.mapWidth)
        local y = love.math.random(self.mapHeight)

        if map:GetTile(x, y):GetType() == 'floor' and entities:GetTile(x, y):GetType() == nil and not snake:IsOn(x, y) then
            entities:GetTile(x, y):SetType(entityType, ...)
            done = true
        end
    end
end

function Level:EntityEaten(entityType, x, y)
end

function Level:OnExit()
end

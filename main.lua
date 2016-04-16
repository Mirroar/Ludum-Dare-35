require('classes/class')
require('classes/textureatlas')
require('classes/tiledtextureatlas')
require('classes/tile')
require('classes/map')
require('classes/entity')
require('classes/bullet')
require('classes/actor')
require('classes/player')
require('classes/entitymanager')
require('classes/menu')
require('classes/log')
require('classes/tweenmanager')

require('classes/snake')

-- Makes sure angles are always between 0 and 360.
function angle(x)
    return x % 360
end

-- Interpolates linearly between min and max.
function lerp(min, max, percentile, unbound)
    if not unbound then
        percentile = math.max(0, math.min(1, percentile))
    end
    return min + (max - min) * percentile
end

-- Interpolation linearly for angles.
function lerpAngle(min, max, percentile)
    min = angle(min)
    max = angle(max)

    if min > max then
        -- Switch everything around to make sure min is always less than max
        -- (necessary for next step).
        local temp = max
        max = min
        min = temp
        percentile = 1 - percentile
    end

    if math.abs(min - max) > 180 then
        -- Interpolate in the opposite (shorter) direction by putting max on
        -- the other side of min.
        max = max - 360
    end

    return angle(lerp(min, max, percentile))
end

-- Loads and defines all needed textures.
local function LoadTextures()
    --textures = TiledTextureAtlas("images/Textures.png")
    --textures:SetTileSize(32, 32)
    --textures:SetTilePadding(2, 2)
    --textures:SetTileOffset(2, 2)
    --textures:DefineTile("empty", 1, 1)
end

-- Loads and defines all needed sounds.
local function LoadSounds()
    sounds = {
        --[[menu = {
            love.audio.newSource("sounds/Menu.wav", "static"),
        },--]]
    }
end

-- Play a defined sound.
function PlaySound(id)
    if sounds[id] then
        local sound = sounds[id][math.random(1, #sounds[id])]
        love.audio.rewind(sound)
        love.audio.play(sound)
    end
end

local mapWidth = 15
local mapHeight = 15

function SpawnEntity(entityType)
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

-- Initializes the application.
function love.load()
    love.window.setTitle("Ludum Dare 35")
    love.window.setMode(1280, 720)
    love.mouse.setVisible(true)

    -- Initialize message log.
    log = Log()
    log:insert('initialized...')

    -- Initialize tween manager.
    tweens = TweenManager()

    -- Load assets.
    LoadTextures()
    LoadSounds()

    mapOffset = {
        x = -15,
        y = 50,
    }

    map = Map(mapWidth, mapHeight)
    map:SetTileOffset(1, 32, 0)
    map:SetTileOffset(2, 16, 28)

    -- Initialize map.
    for x = 1, mapWidth do
        for y = 1, mapHeight do
            if x + y > math.min(mapWidth, mapHeight) / 2 + 1 then
                if x + y < math.max(mapWidth, mapHeight) + math.min(mapWidth, mapHeight) / 2 + 1 then
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
    entities = Map(mapWidth, mapHeight)
    entities:SetTileOffset(1, 32, 0)
    entities:SetTileOffset(2, 16, 28)

    SpawnEntity('food')
    SpawnEntity('food')
    SpawnEntity('bigfood')

    -- Add a snake.
    snake = Snake(map, {{8, 8}, {8, 9}, {8, 10}, {8, 11}, {8, 12}})
end

-- Handles per-frame state updates.
function love.update(delta)
    tweens:update(delta)
    snake:update(delta)
end

-- Draws a frame.
function love.draw()
    -- Clear screen.
    love.graphics.setBackgroundColor(32, 32, 32)
    love.graphics.clear()

    -- Draw map.
    love.graphics.setColor(255, 255, 255)
    love.graphics.push()
    love.graphics.translate(mapOffset.x, mapOffset.y)
    map:draw()
    entities:draw()
    snake:draw()
    love.graphics.pop()

    -- Draw message log.
    love.graphics.push()
    love.graphics.translate(0, 400)
    love.graphics.setColor(255, 255, 255)
    log:draw()
    love.graphics.pop()
end

function love.mousepressed(x, y, button, istouch)
    snake:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    snake:mousereleased(x, y, button, istouch)
end

-- Handles pressed keys.
function love.keypressed(key, scanCode, isRepeat)
    if scanCode == 'escape' then
        love.event.quit()
    end
end

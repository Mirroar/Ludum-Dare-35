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
require('classes/level')

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
        music1 = {
            love.audio.newSource("sounds/music1.ogg", "stream"),
        },
    }
end

-- Play a defined sound.
function PlaySound(id)
    if sounds[id] then
        local sound = sounds[id][math.random(1, #sounds[id])]
        love.audio.rewind(sound)
        love.audio.play(sound)
        return sound
    end
end

function _HueToRGB(p, q, hue)
    if hue < 0 then
        hue = hue + 1
    elseif hue > 1 then
        hue = hue -1
    end

    if hue < 1 / 6 then
        return p + (q - p) * 6 * hue
    end
    if hue < 1 / 2 then
        return q
    end
    if hue < 2 / 3 then
        return p + (q - p) * 6 * (2/3 - hue)
    end

    return p
end

function HSLToRGB(hue, saturation, lightness)
    local r, g, b = lightness, lightness, lightness

    if saturation ~= 0 then
        local q = lightness + saturation - lightness * saturation
        if lightness < 0.5 then
            q = lightness * (1 + saturation)
        end

        local p = 2 * lightness - q

        r = _HueToRGB(p, q, hue + 1 / 3)
        g = _HueToRGB(p, q, hue)
        b = _HueToRGB(p, q, hue - 1 / 3)
    end

    return r * 255, g * 255, b * 255
end

local levelList = {
    {
        id = 'intro',
        name = 'Welcome to Limbo',
    },
    {
        id = 'twoheads',
        name = 'There are two sides to every coin',
    },
    {
        id = 'seesaw',
        name = 'Back and Forth',
    },
    {
        id = 'buttons',
        name = 'Mutable state',
    },
    {
        id = 'kitty',
        name = '???',
    },
    {
        id = 'stuck',
        name = 'Oneway street',
    },
    {
        id = 'stick',
        name = 'Sticking ones nose into things',
    },
    {
        id = 'ld',
        name = 'Thank you for playing!',
    },
    {
        id = 'sandbox',
        name = 'The sandbox',
    },
}
currentLevel = 1

-- Positions map on the screen's center.
function PositionMap()
    local minX, maxX, minY, maxY
    local width, height = map:GetSize()

    for x = 1, width do
        for y = 1, height do
            local tile = map:GetTile(x, y)
            if tile:GetType() then
                local screenX, screenY = map:GetScreenPosition(x, y)

                if not minX or screenX < minX then
                    minX = screenX
                end
                if not maxX or screenX > maxX then
                    maxX = screenX
                end
                if not minY or screenY < minY then
                    minY = screenY
                end
                if not maxY or screenY > maxY then
                    maxY = screenY
                end
            end
        end
    end

    local centerX = (minX + maxX) / 2
    local centerY = (minY + maxY) / 2

    local windowWidth, windowHeight = love.graphics.getDimensions()

    level.mapOffset.x = windowWidth / 2 - centerX
    level.mapOffset.y = windowHeight / 2 - centerY + 50
end

function LoadLevel(id)
    if not levels[id] then
        require('levels/' .. id)
    end
    level = levels[id]()

    PositionMap()
end

function LoadCurrentLevel()
    if currentLevel < 1 then
        currentLevel = 1
    end

    if currentLevel > #levelList then
        currentLevel = #levelList
    end

    LoadLevel(levelList[currentLevel].id)
end

-- Initializes the application.
function love.load()
    love.window.setTitle("Snakeshift")
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

    levels = {}

    music = PlaySound('music1')
    music:setLooping(true)

    showMenu = true
    menu = Menu()
    menu:AddItem("Start", function()
        currentLevel = 1
        LoadCurrentLevel()
        showMenu = false
    end)
    menu:AddItem("Sandbox", function()
        currentLevel = #levelList
        LoadCurrentLevel()
        showMenu = false
    end)
    menu:AddItem("Quit", function()
        love.event.quit()
    end)
end

-- Handles per-frame state updates.
function love.update(delta)
    tweens:update(delta)

    if snake then
        snake:update(delta)
    end

    if showMenu then
        menu:update(delta)
    end
end

-- Draws a frame.
function love.draw()
    -- Clear screen.
    love.graphics.setBackgroundColor(32, 32, 32)
    love.graphics.clear()

    -- Draw map.
    love.graphics.setColor(255, 255, 255)
    love.graphics.push()
    if level then
        love.graphics.translate(level.mapOffset.x, level.mapOffset.y)
    end
    if map then
        map:draw()
    end
    if entities then
        entities:draw()
    end
    if snake then
        snake:draw()
    end
    love.graphics.pop()

    -- Draw message log.
    love.graphics.push()
    love.graphics.translate(0, 400)
    love.graphics.setColor(255, 255, 255)
    log:draw()
    love.graphics.pop()

    if showMenu then
        menu:draw()
    end
end

function love.mousepressed(x, y, button, istouch)
    if snake then
        snake:mousepressed(x, y, button, istouch)
    end
end

function love.mousereleased(x, y, button, istouch)
    if snake then
        snake:mousereleased(x, y, button, istouch)
    end
end

-- Handles pressed keys.
function love.keypressed(key, scanCode, isRepeat)
    if showMenu then
        menu:keypressed(key, scanCode, isRepeat)
    end

    if scanCode == 'escape' then
        love.event.quit()
    end

    if key == 'r' then
        -- Restart current level.
        LoadCurrentLevel()
    end

    if key == '+' then
        currentLevel = currentLevel + 1
        LoadCurrentLevel()
    end
    if key == '-' then
        currentLevel = currentLevel - 1
        LoadCurrentLevel()
    end
end

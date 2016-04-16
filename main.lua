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

-- Initializes the application.
function love.load()
    love.window.setTitle("Ludum Dare 35")
    love.window.setMode(1280, 720)

    log = Log()
    log:insert('initialized...')

    LoadTextures()
    LoadSounds()

    map = Map(15, 15)
    map:SetTileOffset(1, 32, 0)
    map:SetTileOffset(2, 16, 20)
end

-- Handles per-frame state updates.
function love.update(delta)
end

-- Draws a frame.
function love.draw()
    -- Clear screen.
    love.graphics.setBackgroundColor(32, 32, 32)
    love.graphics.clear()

    love.graphics.setColor(255, 255, 255)
    log:draw()

    love.graphics.setColor(255, 255, 255)
    map:draw()
end

-- Handles pressed keys.
function love.keypressed(key, scanCode, isRepeat)
    if scanCode == 'escape' then
        love.event.quit()
    end
end

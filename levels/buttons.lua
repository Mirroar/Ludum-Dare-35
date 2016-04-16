ButtonsLevel = class(Level)
levels.buttons = ButtonsLevel

local mapStrings = {
    map = {
        '        ...',
        '       ###.',
        '      ...#.',
        '      .##. ',
        '      ...  ',
        '     .  .  ',
        '  ...   ...',
        ' .###  ....',
        '.#.........',
        '.##.  .... ',
        '...   ...  ',
    },
    entities = {
        '           ',
        '           ',
        '      o *  ',
        '           ',
        '           ',
        '     +  +  ',
        '           ',
        '        oo ',
        '  * o+ oxo ',
        '       oo  ',
        '           ',
    },
}

function ButtonsLevel:construct()
    Level.construct(self, 11, 11)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a snake.
    snake = Snake(map, {{9, 1}, {10, 1}, {11, 1}})

    -- Add functionality to buttons.
    entities:GetTile(9, 3).callbacks.press = function ()
        entities:GetTile(6, 6).exits.ne = true
        entities:GetTile(6, 6).exits.sw = true
        log:insert('New paths might open.')
    end
    entities:GetTile(3, 9).callbacks.press = function ()
        entities:GetTile(9, 6).exits.nw = true
        entities:GetTile(9, 6).exits.se = true
    end

    log:insert('Many things can happen when snake moves onto a button.')
end

-- Gets called when the player reaches the exit.
function ButtonsLevel:OnExit()
    Level.OnExit(self)

    snake:ExitLevel(function ()
        LoadLevel('level2')
    end)
end

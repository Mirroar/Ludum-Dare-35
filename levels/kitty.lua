KittyLevel = class(Level)
levels.kitty = KittyLevel

local mapStrings = {
    map = {
        '   #####        #####',
        '  #    #.......#    #',
        '  #   ..........   # ',
        '  #  ...........  #  ',
        '  # ............ #   ',
        '  #.###.....###.#    ',
        '  ..  ......  ..     ',
        ' ...............     ',
        ' ......##......      ',
        ' .............       ',
        ' ............        ',
        ' ...........         ',
        ' ..........          ',
        ' .........           ',
        '                     ',
    },
    entities = {
        '                     ',
        '                     ',
        '                     ',
        '                     ',
        '                     ',
        '                     ',
        '                     ',
        '                     ',
        '   *        *        ',
        '    *  o  *          ',
        '  *        *         ',
        '                     ',
        '                     ',
        '   O   O             ',
        '                     ',
    },
}

function KittyLevel:setButton(id, value)
    return function()
        self.buttons[id] = value

        if self.buttons[1] and self.buttons[2] and self.buttons[3] then
            entities:GetTile(13, 7):SetType('exit')
            map:GetTile(13, 7):SetType('floor')
        else
            entities:GetTile(13, 7):SetType(nil)
            map:GetTile(13, 7):SetType(nil)
        end

        if self.buttons[4] and self.buttons[5] and self.buttons[6] then
            entities:GetTile(6, 7):SetType('exit')
            map:GetTile(6, 7):SetType('floor')
        else
            entities:GetTile(6, 7):SetType(nil)
            map:GetTile(6, 7):SetType(nil)
        end
    end
end

function KittyLevel:construct()
    Level.construct(self, 21, 15)

    self.buttons = {}

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add button functionality.
    entities:GetTile(4, 9).callbacks.press = self:setButton(1, true)
    entities:GetTile(4, 9).callbacks.release = self:setButton(1, false)

    entities:GetTile(5, 10).callbacks.press = self:setButton(2, true)
    entities:GetTile(5, 10).callbacks.release = self:setButton(2, false)

    entities:GetTile(3, 11).callbacks.press = self:setButton(3, true)
    entities:GetTile(3, 11).callbacks.release = self:setButton(3, false)

    entities:GetTile(13, 9).callbacks.press = self:setButton(4, true)
    entities:GetTile(13, 9).callbacks.release = self:setButton(4, false)

    entities:GetTile(11, 10).callbacks.press = self:setButton(5, true)
    entities:GetTile(11, 10).callbacks.release = self:setButton(5, false)

    entities:GetTile(12, 11).callbacks.press = self:setButton(6, true)
    entities:GetTile(12, 11).callbacks.release = self:setButton(6, false)

    -- Add a snake.
    snake = Snake(map, {{4, 12}, {4, 13}, {5, 13}, {6, 13}, {7, 12}, {7, 13}, {8, 13}, {9, 13}, {10, 12}})
end

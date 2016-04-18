LDLevel = class(Level)
levels.ld = LDLevel

local mapStrings = {
    map = {
        ' ....   .......  ',
        ' .##.   .#####.. ',
        ' .##.   .######. ',
        ' .##.   .##  ##. ',
        ' .##.   .##  ##. ',
        ' .##.   .##  ##. ',
        ' .##.....##  ##. ',
        ' .#####..#####.  ',
        ' .#####..####.   ',
        ' ............    ',
        '       ..        ',
        '       ..        ',
        '   ...........   ',
        '  ............   ',
        '  ............   ',
        '  ............   ',
        '  ...........    ',
    },
    entities = {
        ' *      *     *  ',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '                 ',
        '       *         ',
        '                 ',
        '                 ',
        ' *          *    ',
        '                 ',
        '                 ',
        '    ooo  oooo    ',
        '      o  o       ',
        '    oo   ooo     ',
        '      o     o    ',
        '   ooo   ooo     ',
    },
}

function LDLevel:setButton(id, value)
    return function()
        self.buttons[id] = value

        if self.buttons[1] and self.buttons[2] and self.buttons[3] and self.buttons[4] and self.buttons[5] and self.buttons[6] then
            entities:GetTile(8, 17):SetType('exit')
            entities:GetTile(9, 17):SetType('exit')
        else
            entities:GetTile(8, 17):SetType(nil)
            entities:GetTile(9, 17):SetType(nil)
        end

    end
end

function LDLevel:construct()
    Level.construct(self, 17, 17)

    self.buttons = {}

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add functionality to buttons.
    entities:GetTile(2, 1).callbacks.press = self:setButton(1, true)
    entities:GetTile(2, 1).callbacks.release = self:setButton(1, false)

    entities:GetTile(9, 1).callbacks.press = self:setButton(2, true)
    entities:GetTile(9, 1).callbacks.release = self:setButton(2, false)

    entities:GetTile(15, 1).callbacks.press = self:setButton(3, true)
    entities:GetTile(15, 1).callbacks.release = self:setButton(3, false)

    entities:GetTile(8, 7).callbacks.press = self:setButton(4, true)
    entities:GetTile(8, 7).callbacks.release = self:setButton(4, false)

    entities:GetTile(2, 10).callbacks.press = self:setButton(5, true)
    entities:GetTile(2, 10).callbacks.release = self:setButton(5, false)

    entities:GetTile(13, 10).callbacks.press = self:setButton(6, true)
    entities:GetTile(13, 10).callbacks.release = self:setButton(6, false)

    -- Add a snake.
    snake = Snake(map, {{8, 7}, {9, 7}})
end

-- Gets called when an entity is eaten, for the level to respond.
function LDLevel:EntityEaten(entityType, x, y)
    self:SpawnEntity(entityType)
end

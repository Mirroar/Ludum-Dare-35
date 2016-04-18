StickLevel = class(Level)
levels.stick = StickLevel

local mapStrings = {
    map = {
        '   ####   ###    ',
        '  #...#  #..#    ',
        ' #..### #.#.#    ',
        '###...# ##.#     ',
        '#.#.#####..######',
        '#...............#',
        '#######.###.###.#',
        '     #.## #...###',
        '    #.#.# #.#..# ',
        '    #..#  #...#  ',
        '    ###   ####   ',
    },
    entities = {
        '                 ',
        '    +*           ',
        '  o        O     ',
        '   ++o    o      ',
        ' o               ',
        ' +         +  o+ ',
        '       +       o ',
        '           +x    ',
        '       *   +  o  ',
        '             o   ',
        '                 ',
    },
}

function StickLevel:construct()
    Level.construct(self, 17, 11)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add exits to doors.
    entities:GetTile(2, 6).exits.e = true
    entities:GetTile(2, 6).exits.nw = true

    entities:GetTile(5, 2).exits.e = true
    entities:GetTile(5, 2).exits.w = true

    entities:GetTile(12, 6).exits.e = true
    entities:GetTile(12, 6).exits.w = true

    entities:GetTile(8, 7).exits.ne = true
    entities:GetTile(8, 7).exits.nw = true
    entities:GetTile(8, 7).exits.sw = true

    entities:GetTile(4, 4).exits.nw = true
    entities:GetTile(4, 4).exits.e = true
    entities:GetTile(4, 4).exits.se = true

    -- Add button functionality.
    entities:GetTile(6, 2).callbacks.press = function()
        entities:GetTile(5, 4).exits.e = true
        entities:GetTile(5, 4).exits.w = true

        entities:GetTile(12, 6).exits.se = true
    end

    entities:GetTile(8, 9).callbacks.press = function()
        entities:GetTile(16, 6).exits.w = true
        entities:GetTile(16, 6).exits.se = true

        entities:GetTile(12, 8).exits.nw = true
        entities:GetTile(12, 8).exits.se = true

        entities:GetTile(12, 9).exits.nw = true
        entities:GetTile(12, 9).exits.se = true
    end

    -- Add a snake.
    snake = Snake(map, {{10, 3}, {11, 2}})
end

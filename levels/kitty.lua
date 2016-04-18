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
        ' ......#......       ',
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
        '    *     *          ',
        '  *        *         ',
        '                     ',
        '                     ',
        '   O   O             ',
        '                     ',
    },
}

function KittyLevel:construct()
    Level.construct(self, 21, 15)

    self.mapOffset.x = -16
    self.mapOffset.y = 50

    -- Initialize map.
    self:LoadMap(mapStrings)

    -- Add a snake.
    snake = Snake(map, {{4, 12}, {4, 13}, {5, 13}, {6, 13}, {7, 12}, {7, 13}, {8, 13}, {9, 13}, {10, 12}})
end

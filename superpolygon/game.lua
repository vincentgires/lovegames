local gamestates = {'PLAY', 'PAUSE', 'END'}

local game = {
    multiplayer = {
        collision = true
    },
    camera = {
        rotation = true,
        shake = true
    },
    scene = {
        swap_bg_colors = true
    },
    debug = {
        hithox = true
    },
    state = 'END'
}

return game

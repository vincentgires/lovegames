game = {
    players = 1,
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
        hithox = false
    }
}


function game:start()
    scene.seconds = 0
    scene.bg_colors = {
        r = random_float(0, 0.5),
        g = random_float(0, 0.5),
        b = random_float(0, 0.5)
    }
end


function game:reset()

end

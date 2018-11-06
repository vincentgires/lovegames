local gamestates = {'PLAY', 'PAUSE', 'END'}

game = {
    multiplayer = {
        collision = true
    },
    speed = 5,
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


function game:start()
    for i, player in ipairs(players) do
        -- reset attributes
        player.failure = 0
    end

    self:reset()
end

function game:reset()
    scene.bg_colors = {
        r = random_float(0, 0.5),
        g = random_float(0, 0.5),
        b = random_float(0, 0.5)
    }

    -- reset attributes
    scene.base_time = 0
    scene.frame = 0
    scene.seconds = 0
    camera.angle = 0
    camera.scale = 1

    for i, player in ipairs(players) do
        player.angle = 360/(#players/i)
        player.collide = false
    end

    -- reset pattern
    block_sequence.blocks = {}
    -- first pattern
    local group, segments = get_random_group()
    block_sequence:add_group(group, segments)

    game.state = 'PLAY'
end

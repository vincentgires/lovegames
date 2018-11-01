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
    state = 'PLAY'
}


function game:start()
    for i, player in ipairs(players) do
        -- set position
        local num = #players
        player.angle = 360/(num/i)

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

    -- reset pattern
    block_sequence.blocks = {}
    -- first pattern
    local group, segments = get_random_group()
    block_sequence:add_group(group, segments)

    game.state = 'PLAY'
end

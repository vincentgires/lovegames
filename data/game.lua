game = {
    players = 1,
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
    }
}


function game:start()
    scene.seconds = 0
    scene.bg_colors = {
        r = random_float(0, 0.5),
        g = random_float(0, 0.5),
        b = random_float(0, 0.5)
    }

    for i, player in ipairs(players) do
        -- set position
        local num = #players
        player.angle = 360/(num/i)

        -- reset attributes
        player.failure = 0
    end

    -- reset pattern
    block_sequence.blocks = {}

    -- first pattern
    local group, segments = get_random_group()
    block_sequence:add_group(group, segments)
end

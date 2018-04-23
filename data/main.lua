require 'player'
require 'utils'
require 'block'
require 'collision'

function love.load()
    love.window.setTitle('Super Polygon')
    
    local player1 = Player:new()
    player1.key_left = 'left'
    player1.key_right = 'right'
    player1.color = {1, 0, 1}
    
    local player2 = Player:new()
    player2.key_left = 'q'
    player2.key_right = 'd'
    player2.color = {0, 1, 1}
    
--     players = {player1, player2}
    players = {player1}
    
    camera = {
        angle = 0,
        speed = 2    
    }
    
    scene = {
        segments = 5,
        base_time = 0,
        seconds = 0,
        speed = 5
    }
    
    blocks = get_blocks_from_sequence()
    
end

function love.update(dt)
    -- scene
    
    -- seconds
    scene.base_time = scene.base_time + dt
    if scene.base_time > 1 then
        scene.base_time = scene.base_time - 1
        scene.seconds = scene.seconds + 1
    end
    
    -- camera
    camera.angle = camera.angle + dt * camera.speed

    -- blocks
    print(table_length(blocks))
    if table_length(blocks) ~= 0 then
        for k, v in pairs(blocks) do
            if v.finished == true then
                blocks[k] = nil
            else
                v:update()
            end
        end
    else
        -- create next pattern
        blocks = get_blocks_from_sequence()
    end
    
    -- player
    for k, v in pairs(players) do
        v:update(dt)
    end
    
    -- check collisions
    check_collision()
    
    -- force console output
    io.flush()
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    love.graphics.translate(width/2, height/2)
    -- camera
    love.graphics.rotate(camera.angle)
    
    -- blocks
    for k, v in pairs(blocks) do
        v:draw()
    end
    
    -- circle
    love.graphics.setColor(1, 1, 1)
    love.graphics.circle("line", 0, 0, 40, scene.segments)
    
    -- center
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('line', -5, -5, 10, 10)
    
    -- player
    for k, v in pairs(players) do
        v:draw()
    end
    
    -- text overlay
    love.graphics.reset()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Timer: " .. scene.seconds, 0, 0)
    for i, p in pairs(players) do
        local y = 20
        love.graphics.print(
            'Player' .. i .. ' - Failure ' .. p.failure, 0, y+(i*50))
    end
    
end

function love.keypressed(key)
--     if key == 'left' then
--         print('left')
--     end
--     
--     if key == 'right' then
--         print('right')
--     end

    if key == 'f' then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false, "desktop")
        else
            love.window.setFullscreen(true, "desktop")
        end
    end
    
    if key == 'escape' then
        love.event.quit()
    end
end

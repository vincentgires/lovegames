require 'player'
require 'utils'
require 'block'

function love.load()
    love.window.setTitle('Super Polygon')
    
    player = Player:new()
    player.key_left = 'left'
    player.key_right = 'right'
    
    player2 = Player:new()
    player2.key_left = 'q'
    player2.key_right = 'd'
    
    players = {player, player2}
    
    camera = {
        angle = 0,
        speed = 2    
    }
    
    scene = {
        segments = 5,
        seconds = 0
    }
    
    blocks = get_blocks_from_sequence()
    
end

function love.update(dt)
    -- camera
    camera.angle = camera.angle + dt * camera.speed
    
    -- blocks
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
    
    -- force console output
    io.flush()
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    love.graphics.translate(width/2, height/2)
    
    -- camera
    love.graphics.rotate(camera.angle)
    
    -- background
    love.graphics.setColor(50, 50, 50)
    
    -- blocks
    for k, v in pairs(blocks) do
        v:draw()
    end
    
    -- circle
    love.graphics.setColor(100, 100, 100)
    love.graphics.circle("line", 0, 0, 40, scene.segments)
    
    -- center
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('line', -5, -5, 10, 10)
    
    -- player
    for k, v in pairs(players) do
        v:draw()
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

require 'player'

function love.load()
    player_angle = 0
    player_speed = .1
    
    camera_angle = 0
    camera_speed = 2
    
    segments = 5
end

function love.update(dt)
    
    -- camera
--     camera_angle = camera_angle + dt * camera_speed
    
    -- player
    
    if love.keyboard.isDown('left') then
        player_angle = player_angle - player_speed
    end
    
    if love.keyboard.isDown('right') then
        player_angle = player_angle + player_speed
    end
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    love.graphics.translate(width/2, height/2)
    
    -- camera
    love.graphics.rotate(camera_angle)
    
    -- background
    love.graphics.setColor(50, 50, 50)
--     local slice = math.pi / 5
--     love.graphics.arc( "fill", 0, 0, 100, slice, (math.pi * 2) - slice*8)
    -- circle
    local x, y, r = 0, 0, 100
    for i = 1, 360, 360/segments do
        local angle = i * math.pi / 180
        local ptx, pty = x + r * math.cos( angle ), y + r * math.sin( angle )
        local stars = {ptx, pty}
        love.graphics.points(stars)
    end
    
    love.graphics.setColor(100, 100, 100)
    love.graphics.circle("line", 0, 0, 40, 5)
    
    -- center
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('line', -5, -5, 10, 10)
    
    -- player
    love.graphics.setColor(255, 255, 255)
    love.graphics.rotate(player_angle)
    love.graphics.translate(0, -50)
    local vertices = {-5, 0, 5, 0, 0, -10}
    love.graphics.polygon('fill', vertices)
end

function love.keypressed(key)
--     if key == 'left' then
--         print('left')
--     end
--     
--     if key == 'right' then
--         print('right')
--     end
    
    if key == 'escape' then
        love.event.quit()
    end
end

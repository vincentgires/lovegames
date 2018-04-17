require 'player'
require 'utils'
require 'block'
require 'scene'

function love.load()
    player = Player:new()
    player.key_left = 'left'
    player.key_right = 'right'
    
    player2 = Player:new()
    player2.key_left = 'q'
    player2.key_right = 'd'
    
    players = {player, player2}
    
    camera = {}
    camera.angle = 0
    camera.speed = 2
    
    segments = 5
end

function love.update(dt)
    -- camera
--     camera.angle = camera.angle + dt * camera.speed
    
    -- player
    player:update(dt)
--     for k, v in pairs(players) do
--         v:update(dt)
--     end
    
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
    -- circle
    love.graphics.setPointSize(4)
    local test = block_points(1)
    love.graphics.points(test)
    
    love.graphics.setColor(100, 100, 100)
    love.graphics.circle("line", 0, 0, 40, 5)
    
    -- center
    love.graphics.setColor(0, 255, 0)
    love.graphics.rectangle('line', -5, -5, 10, 10)
    
    -- player
    player:draw()
--     for k, v in pairs(players) do
--         v:draw(dt)
--     end
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

player = {}
player.angle = 0
player.speed = .1

function player:update(dt)
    if love.keyboard.isDown(player.key_left) then
        player.angle = player.angle - player.speed
    end
    
    if love.keyboard.isDown(player.key_right) then
        player.angle = player.angle + player.speed
    end
end

function player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rotate(player.angle)
    love.graphics.translate(0, -50)
    local vertices = {-5, 0, 5, 0, 0, -10}
    love.graphics.polygon('fill', vertices)
end

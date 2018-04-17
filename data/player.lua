Player = {
    angle = 0,
    speed = 0.1
}

function Player:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Player:update(dt)
    if love.keyboard.isDown(self.key_left) then
        self.angle = self.angle - self.speed
    end
    
    if love.keyboard.isDown(self.key_right) then
        self.angle = self.angle + self.speed
    end
end

function Player:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rotate(self.angle)
    love.graphics.translate(0, -50)
    local vertices = {-5, 0, 5, 0, 0, -10}
    love.graphics.polygon('fill', vertices)
end

Player = {
    angle = 0,
    speed = 5,
    size = 5,
    center = 70,
    color = {1, 1, 1},
    points = nil
}

function Player:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Player:update(dt)
    if love.keyboard.isDown(self.key_left) then
        self.angle = self.angle - self.speed
    end
    
    if love.keyboard.isDown(self.key_right) then
        self.angle = self.angle + self.speed
    end
    
    self:update_points()
    
end

function Player:update_points()
    local angle = self.angle * math.pi / 180 -- convert to radians
    local points = {-self.size, -self.size, self.size, 0, -self.size, self.size}
    local offset_points = points_from_angle(self.center, self.angle)
    
    for k, v in ipairs(points) do
        if k%2 == 1 then
            x = points[k] * math.cos(angle) - points[k+1] * math.sin(angle)
            y = points[k+1] * math.cos(angle) + points[k] * math.sin(angle)
            points[k] = x + offset_points[1]
            points[k+1] = y + offset_points[2]
        end
    end
    
    self.points = points
end


function Player:draw()
    love.graphics.setColor(self.color)
    if self.points then
        love.graphics.polygon('fill', self.points)
    end
end

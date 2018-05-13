Player = {
    name = 'Player',
    angle = 0,
    speed = 5,
    size = 5,
    center = 70,
    color = {1, 1, 1},
    points = nil,
    failure = 0,
    key_right = nil,
    key_left = nil
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
    local s = self.size
    local points = {-s, -s, s, 0, -s, s}
    local offset_points = points_from_angle(self.center, self.angle)

    for i, p in ipairs(points) do
        if i%2 == 1 then
            x = points[i] * math.cos(angle) - points[i+1] * math.sin(angle)
            y = points[i+1] * math.cos(angle) + points[i] * math.sin(angle)
            points[i] = x + offset_points[1]
            points[i+1] = y + offset_points[2]
        end
    end

    self.points = points

    if self.angle > 360 then
        self.angle = self.angle - 360
    elseif self.angle < 0 then
        self.angle = 360 - self.angle
    end
end

function Player:draw()
    love.graphics.setColor(self.color)
    if self.points then
        love.graphics.polygon('fill', self.points)
    end
end

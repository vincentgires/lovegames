Player = {
    name = 'Player',
    angle = 0,
    speed = 5,
    size = 5,
    center = 70,
    color = {1, 1, 1},
    points = nil,
    failure = 0,
    key_left = 'left',
    key_right = 'right',
    move_left = true,
    move_right = true,
    hitbox_size = 10
}


function Player:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end


function Player:update(dt)
    self.move_left = true
    self.move_right = true

    -- check position of other players
    for i, player in pairs(players) do
        if self ~= player then
            local player_x = points_from_angle(player.center, player.angle)[1]
            local player_y = points_from_angle(player.center, player.angle)[2]

            if love.keyboard.isDown(self.key_left) then
                local x = points_from_angle(self.center, self.angle-self.speed)[1]
                local y = points_from_angle(self.center, self.angle-self.speed)[2]
                local collide = point_in_circle(x, y, player_x, player_y, self.hitbox_size)
                if collide then
                    self.move_left = false
                end
            elseif love.keyboard.isDown(self.key_right) then
                local x = points_from_angle(self.center, self.angle+self.speed)[1]
                local y = points_from_angle(self.center, self.angle+self.speed)[2]
                local collide = point_in_circle(x, y, player_x, player_y, self.hitbox_size)
                if collide then
                    self.move_right = false
                end
            end
        end
    end

    if love.keyboard.isDown(self.key_left) and self.move_left then
        self.angle = self.angle - self.speed
    end
    if love.keyboard.isDown(self.key_right) and self.move_right then
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

    -- draw sides for debug
    love.graphics.setColor(1, 0, 0)
    love.graphics.line({self.points[1], self.points[2],
                        self.points[3], self.points[4]})
    love.graphics.setColor(0, 1, 0)
    love.graphics.line({self.points[5], self.points[6],
                        self.points[3], self.points[4]})

    -- draw player collision hitbox for debug
    love.graphics.setColor(0, 0, 1)
    local x = points_from_angle(self.center, self.angle)[1]
    local y = points_from_angle(self.center, self.angle)[2]
    love.graphics.setColor(0, 1, 0)
    love.graphics.circle('line', x, y, self.hitbox_size)
end

Player = {
    name = 'Player',
    number = 1,
    angle = 0,
    speed = 5,
    size = 5,
    center = 70,
    color = {1, 1, 1},
    points = nil,
    failure = 0,
    key_left = 'left',
    key_right = 'right',
    freeze = false,
    hitbox_size = 10,
    collide = nil
}


function Player:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    self.number = #players + 1
    table.insert(players, instance)
    return instance
end


function Player:update(dt)
    self.freeze = false
    local direction = nil

    if love.keyboard.isDown(self.key_left) then
        direction = -1
    end
    if love.keyboard.isDown(self.key_right) then
        direction = 1
    end

    if direction then
        -- check position of other players
        if game.multiplayer.collision then
            for i, player in pairs(players) do
                if self ~= player then
                    local player_x = points_from_angle(player.center, player.angle)[1]
                    local player_y = points_from_angle(player.center, player.angle)[2]
                    local x = points_from_angle(self.center, self.angle + (self.speed * direction))[1]
                    local y = points_from_angle(self.center, self.angle + (self.speed * direction))[2]
                    local collide = point_in_circle(x, y, player_x, player_y, self.hitbox_size)
                    if collide then
                        self.freeze = true
                    end
                end
            end
        end

        if not self.freeze then
            self.angle = self.angle + (self.speed * direction)
        end
    end

    self:update_points()
    self:check_block_collision()
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

    -- draw player collision hitbox for debug
    if game.debug.hitbox then
        love.graphics.setColor(0, 0, 1)
        local x = points_from_angle(self.center, self.angle)[1]
        local y = points_from_angle(self.center, self.angle)[2]
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('line', x, y, self.hitbox_size)
    end
end


function Player:check_block_collision()
    if self.points then
        for i=1,3,2 do
            -- front player shape /\
            local px1 = self.points[i]
            local px2 = self.points[i+1]
            local py1 = self.points[i+2]
            local py2 = self.points[i+3]

            for _, block in pairs(block_sequence.blocks) do

                -- check if the player has already hit the block
                for i, player in ipairs(block.collided_players) do
                    if player.number == self.number then
                        goto continue
                    end
                end

                -- if block.points and not self.collide then
                if block.points then
                    -- bottom of the block \->_____<-/
                    local bx1 = block.points[1]
                    local bx2 = block.points[2]
                    local by1 = block.points[3]
                    local by2 = block.points[4]
                    local collide, x, y = segment_vs_segment(
                        px1, px2, py1, py2, bx1, bx2, by1, by2)
                    if collide then
                        table.insert(block.collided_players, self)
                        -- self.collide = true
                        self.failure = self.failure + 1
                        return true, x, y
                    end
                end
                ::continue::
            end
        end
    end
end

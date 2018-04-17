Block = {
    position = 1,
    size = 20,
    offset = 600
}

function Block:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Block:points(position)
    local points = {}
    local slice = 360/segments
    local angle = slice + slice * position
    
    points = merge_tables(points, points_from_angle(self.offset, angle))
    points = merge_tables(points, points_from_angle(self.offset, angle+slice))
    points = merge_tables(points, points_from_angle(self.offset+self.size, angle+slice))
    points = merge_tables(points, points_from_angle(self.offset+self.size, angle))
    
    return points
end

function Block:update(dt)
    self.offset = self.offset - 5
    if self.offset <= 0 then
        print('stop')
        self = nil
    end
end

function Block:draw()
    love.graphics.setPointSize(4)
    local points = self:points(self.position)
    love.graphics.polygon('fill', points)
end

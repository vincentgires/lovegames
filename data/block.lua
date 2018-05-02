function get_random_group(group)
    local nbr = math.random(1, table_length(block_groups))
    local group = group or block_groups[nbr] -- default pattern
    local segments = group.segments
    
    local blocks = {}
    for i, b in pairs(group.blocks) do
        local block = Block:new()
        block.position = b['position']
        block.offset = b['offset']
        table.insert(blocks, block)
    end
    
    return blocks, segments
end

-------------------------------------------------------------------------------

Block = {
    position = 1,
    offset = 0,
    size = 30,
    radius = 600,
    collided_players = {},
    points = nil,
    finished = false,
    segments = nil -- WIP ??
}

function Block:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Block:update_points(position)
    local points = {}
    local slice = 360/scene.segments
    local angle = slice + slice * position
    
    points = merge_tables(points, points_from_angle(self.radius+(self.offset*self.size), angle))
    points = merge_tables(points, points_from_angle(self.radius+(self.offset*self.size), angle+slice))
    points = merge_tables(points, points_from_angle(self.radius+self.size+(self.offset*self.size), angle+slice))
    points = merge_tables(points, points_from_angle(self.radius+self.size+(self.offset*self.size), angle))
    
    self.points = points
end

function Block:update(dt)
    self.radius = self.radius - scene.speed
    if self.radius+(self.offset*self.size) <= 0 then
        self.finished = true
    end
    
    self:update_points(self.position)
end

function Block:draw()
    love.graphics.setPointSize(4)
    if self.points then
        love.graphics.polygon('fill', self.points)
    end
end


-------------------------------------------------------------------------------

block_sequence = {
    blocks = {} -- {position, offset, segments}
}

function block_sequence:add_group(group, segments)
    for k, b in pairs(group) do
        local block = Block:new()
        block.position = b.position
        block.offset = b.offset
        block.segments = segments
        table.insert(self.blocks, block)
    end
end

function block_sequence:update(dt)
--     self:add_group(block_groups[1])
--     print(table_length(self.blocks))

    --scene.segments = sequence.segments

end

function block_sequence:draw()
    
end



-------------------------------------------------------------------------------


block_groups = {
    {
        segments = 5,
        blocks = {
            {position = 1, offset = 0},
            {position = 2, offset = 0},
            {position = 3, offset = 0},
            {position = 5, offset = 6},
            {position = 4, offset = 6},
            {position = 6, offset = 9},
            {position = 7, offset = 9},
            {position = 3, offset = 9},
            
            {position = 5, offset = 11},
            {position = 4, offset = 13},
            {position = 6, offset = 13},
            {position = 7, offset = 15},
            {position = 3, offset = 17}
        }
    },
    {
        segments = 4,
        blocks = {
            {position = 1, offset = 0},
            {position = 3, offset = 0},
            {position = 5, offset = 4},
            {position = 4, offset = 4},
            {position = 6, offset = 9},
            {position = 7, offset = 9},
            {position = 3, offset = 9}
        }
    }
}

--[[
block_sequences = {
    {
        segments = 5,
        blocks = {
            {position = 1, offset = 0},
            {position = 6, offset = 9},
        }
    }
}
]]

--[[
block_sequences = {
    {
        segments = 5,
        blocks = {
            {position = 1, offset = 0},
            {position = 2, offset = 0},
            {position = 3, offset = 0},
            {position = 5, offset = 6},
            {position = 4, offset = 6},
            {position = 6, offset = 9},
            {position = 7, offset = 9},
            {position = 3, offset = 9},

        }
    }
}
]]

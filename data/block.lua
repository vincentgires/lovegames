Block = {
    position = 1,
    offset = 0,
    size = 30,
    radius = 600,
    finished = false
}

function Block:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Block:points(position)
    local points = {}
    local slice = 360/scene.segments
    local angle = slice + slice * position
    
    points = merge_tables(points, points_from_angle(self.radius+(self.offset*self.size), angle))
    points = merge_tables(points, points_from_angle(self.radius+(self.offset*self.size), angle+slice))
    points = merge_tables(points, points_from_angle(self.radius+self.size+(self.offset*self.size), angle+slice))
    points = merge_tables(points, points_from_angle(self.radius+self.size+(self.offset*self.size), angle))
    
    return points
end

function Block:update(dt)
    self.radius = self.radius - 5
    if self.radius+(self.offset*self.size) <= 0 then
        self.finished = true
    end
end

function Block:draw()
    love.graphics.setPointSize(4)
    local points = self:points(self.position)
    love.graphics.polygon('fill', points)
end

function get_blocks_from_sequence(sequence)
    local nbr = math.random(1, table_length(block_sequences))
    print(table_length(block_sequences), nbr)
    sequence = sequence or block_sequences[nbr] -- default pattern
    
    scene.segments = sequence.segments
    
    local blocks = {}
    for k, b in pairs(sequence.blocks) do
        local block = Block:new()
        block.position = b['position']
        block.offset = b['offset']
        table.insert(blocks, block)
    end
    
    return blocks
end

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
            {position = 3, offset = 9}
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

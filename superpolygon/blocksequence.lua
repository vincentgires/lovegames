local game = require 'game'
local scene = require 'scene'
local utils = require 'utils'

local Block = {
    position = 1,
    offset = 0,
    size = 30,
    radius = 600, -- initial radius, start from outside the screen
    points = nil,
    finished = false,
    segments = nil
}

function Block:new()
    local instance = {}
    instance.collided_players = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Block:update_points(position)
    local points = {}
    local slice = 360/scene.segments
    local angle = slice + slice * position

    points = utils.merge_tables(
        points, utils.points_from_angle(
            self.radius+(self.offset*self.size), angle))
    points = utils.merge_tables(
        points, utils.points_from_angle(
            self.radius+(self.offset*self.size), angle+slice))
    points = utils.merge_tables(
        points, utils.points_from_angle(
            self.radius+self.size+(self.offset*self.size), angle+slice))
    points = utils.merge_tables(
        points, utils.points_from_angle(
            self.radius+self.size+(self.offset*self.size), angle))

    self.points = points
end

function Block:update(dt)
    if game.state == 'PLAY' then
        self.radius = self.radius - blocksequence.speed
        if self.radius+(self.offset*self.size) <= 0 then
            self.finished = true
        end
        self:update_points(self.position)
    end
end

function Block:draw()
    -- love.graphics.setPointSize(4)
    if self.points then
        love.graphics.polygon('fill', self.points)
    end
end

-------------------------------------------------------------------------------

blocksequence = {
    blocks = {}, -- {position, offset, segments}
    speed = nil
}

function blocksequence:add_group(group, segments)
    for k, b in pairs(group) do
        local block = Block:new()
        block.position = b.position
        block.offset = b.offset
        block.segments = segments
        table.insert(self.blocks, block)
    end
end

function get_random_group(group)
    local nbr = love.math.random(1, #blockgroups)
    local group = group or blockgroups[nbr] -- default pattern
    local segments = group.segments

    local blocks = {}
    for i, b in pairs(group.blocks) do
        if b.range then
            for j=b.range[1], b.range[2] do
                local block = Block:new()
                block.position = j
                block.offset = b['offset']
                table.insert(blocks, block)
            end
        else
            local block = Block:new()
            block.position = b['position']
            block.offset = b['offset']
            table.insert(blocks, block)
        end
    end

    return blocks, segments
end

function blocksequence:update(dt)
    for i, block in pairs(self.blocks) do
        block:update(dt)

        -- set scene segments with next block
        scene.segments = self.blocks[1].segments

        -- add next pattern
        if #self.blocks <= 3 then
        -- if #self.blocks <= 1 then
            local group, segments = get_random_group()
            self:add_group(group, segments)
        end
    end

    -- remove finished blocks
    for i, block in pairs(self.blocks) do
        if block.finished == true then
            self.blocks[i] = nil -- make sure it's removed
            table.remove(self.blocks, i)
        end
    end

end

return blocksequence

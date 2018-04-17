Block = {}

function Block:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Block:update(dt)
    
end

function Block:draw()
    
end

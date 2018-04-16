Block = {test='TEST'}

function Block:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Block:update(dt)
    
end

function Block:draw()
    print("gg", self.value, self.test)
end

aa = Block:new()
bb = Block:new()

aa.value = 'aassa'
bb.value = '2ss2222'

aa:draw()
bb:draw()

-- print(aa.value, aa.test)
-- print(bb.value, bb.test)

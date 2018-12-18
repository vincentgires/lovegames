--[[
TODO:
- ACTION manager
- multiple input (A+B send an ACTION)
- pressed/released support
]]

local Input = {
    joysticks = love.joystick.getJoysticks(),
    axis_threshold = 0.1
}

function Input:new()
    local instance = {}
    instance.name = name
    setmetatable(instance, self)
    self.__index = self
    return instance
end

function Input:update(dt)

    for _, joystick in ipairs(self.joysticks) do
        -- buttons
        for btn=1, joystick:getButtonCount() do
            if joystick:isDown(btn) then
                print(joystick, btn)
            end
        end
        -- hat
        for i=1, joystick:getHatCount() do
            local hat = joystick:getHat(i)
            if hat ~= 'c' then
                print(joystick, hat)
            end
        end
        -- axis
        for i=1, joystick:getAxisCount() do
            local axis = joystick:getAxis(i)
            print(joystick, axis)
        end
    end


end

return Input

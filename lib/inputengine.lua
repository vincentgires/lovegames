--[[
TODO:
- pressed/released support
- define the axis deadzone
- multi input for the same control
]]

joysticks = love.joystick.getJoysticks()

local INPUT_SUBTYPES = {
    'KEYBOARD',
    'MOUSE_BUTTON',
    'MOUSE_WHEEL',
    'JOYSTICK_BUTTON',
    'JOYSTICK_HAT',
    'JOYSTICK_AXIS'
}

local Input = {
    -- axis_threshold = 0.1,
    controls = {},
}

function Input:new(t)
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Input:add_control(name, t)
    -- t = {name='jump', subtype='JOYSTICK_BUTTON', value=1}
    t = t or {}
    t.name = name
    self.controls[name] = t
end

function Input:check_active_control(subtype, value)
    for _, control in pairs(self.controls) do
        if control.subtype == subtype and control.value == value then
            print('-------', control.name)
        end
    end
end

function Input:update(dt)
    -- mouse
    -- TODO: add scroll wheels
    for btn=1, 3 do -- TODO: mouse could have more than 3 buttons
        if love.mouse.isDown(btn) then
            print('mouse', btn)
            self:check_active_control('MOUSE_BUTTON', btn)
        end
    end
    -- keyboard
    --love.keyboard.isDown
    -- joystick
    for _, joystick in ipairs(joysticks) do
        -- buttons
        for btn=1, joystick:getButtonCount() do
            if joystick:isDown(btn) then
                print('boutton', joystick, btn)
                self:check_active_control('JOYSTICK_BUTTON', btn)
            end
        end
        -- hat
        for i=1, joystick:getHatCount() do
            local hat = joystick:getHat(i)
            if hat ~= 'c' then -- 'c' is the rest hat position
                print('hat', joystick, hat)
                self:check_active_control('JOYSTICK_HAT', hat)
            end
        end
        -- axis
        -- TODO: find a way to set a "rest" pose / deadzone
        -- some axis of some controller start from -1 to 1 and not 0 to +/- 1
        --[[for i=1, joystick:getAxisCount() do
            local axis = joystick:getAxis(i)
            print('axis', joystick, axis)
        end]]
    end
end

function Input:down(control)

end

function Input:pressed(control)

end

function Input:released(control)

end

return Input

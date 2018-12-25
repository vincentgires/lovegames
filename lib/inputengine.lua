--[[
TODO:
- pressed/released support
- define the axis deadzone
- method to get active action
]]

local joysticks = love.joystick.getJoysticks()

local Input = {
    -- axis_threshold = 0.1,
    actions = {}
}

function Input:new(t)
    -- Input can be instanciated, for exemple, to set a second input manager
    -- for a second player
    t = t or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

function Input:bind_action(name, t)
    -- Bind action to controller and value
    -- t = {controller='joystick', number=2, event='button', value=1}
    -- t = {controller='keyboard', value='return'}

    -- can support multi input for the same action
    -- check if action doesn't already exist
    if not self.actions[name] then
        self.actions[name] = {}
    end
    table.insert(self.actions[name], t)
end

function Input:unbind_action(name)

end
--[[
function Input:check_active_control(subtype, value)
    for _, action in pairs(self.actions) do
        if action.subtype == subtype and action.value == value then
            --print('-------', action.name)
            action.active = true
        else
            action.active = false
        end
    end
end
]]
function Input:update(dt)
    -- mouse
    -- TODO: add scroll wheels
    for btn=1, 3 do -- TODO: mouse could have more than 3 buttons
        if love.mouse.isDown(btn) then
            --print('mouse', btn)
            --self:check_active_control('MOUSE_BUTTON', btn)
        end
    end
    -- keyboard
    --love.keyboard.isDown
    -- joystick
    for num, joystick in ipairs(joysticks) do
        -- buttons
        for btn=1, joystick:getButtonCount() do
            if joystick:isDown(btn) then
                --print('boutton', joystick, btn, 'num', num)
                --self:check_active_control('JOYSTICK_BUTTON', btn)
            end
        end
        -- hat
        for i=1, joystick:getHatCount() do
            local hat = joystick:getHat(i)
            if hat ~= 'c' then -- 'c' is the rest hat position
                --print('hat', joystick, hat)
                --self:check_active_control('JOYSTICK_HAT', hat)
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

function Input:is_down(action_name)
    local controllers = self.actions[action_name]
    for _, controller in ipairs(controllers) do

        if controller.device == 'keybord' then
            if love.keyboard.isDown(controller.value) then
                print(action_name, 'keybord')
                return true
            end
        elseif controller.device == 'mouse' then
            if love.mouse.isDown(controller.value) then
                if controller.event == 'button' then
                    print(action_name, 'mouse')
                    return true
                end
            end
        elseif controller.device == 'joystick' then
            local joystick = joysticks[controller.number]
            if controller.event == 'button' then
                if joystick:isDown(controller.value) then
                    print(action_name, 'button')
                    return true
                end
            elseif controller.event == 'hat' then
                local hat = joystick:getHat(controller.value)
                if hat ~= 'c' then -- 'c' is the rest hat position
                    print(action_name, 'hat')
                    return true
                end
            end
        end
    end
end

function Input:is_pressed(action_name)

end

function Input:is_released(action_name)

end

return Input

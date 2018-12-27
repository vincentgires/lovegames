--[[
TODO:
- pressed/released support
- define the axis deadzone
- add a listener to set controller by user input
- save/read from file: lua/json?
- sequence manipulation (fireball, dragon, etc)
]]

local GAMEPAD_AXIS = {
    'leftx', 'rightx', 'lefty', 'righty', 'triggerleft', 'triggerright'}

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
    -- t = {device='joystick', number=2, event='button', value=1}
    -- t = {device='keyboard', value='return'}
    -- t = {device='joystick', number=2, event='hat', index=1, value='r'}

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
        -- print(joystick:getName())
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
                --print('hat', joystick, hat, i)
                --self:check_active_control('JOYSTICK_HAT', hat)
            end
        end
        -- axis
        -- some axis of some controller start from -1 to 1 and not 0 to +/- 1
        if joystick:isGamepad() then
            for i, axe in ipairs(GAMEPAD_AXIS) do
                -- print(axe, joystick:getGamepadAxis(axe))
            end
        else
            for i=1, joystick:getAxisCount() do
                local axis = joystick:getAxis(i)
                -- print('axis', joystick, axis, i)
            end
        end

    end
end

function Input:is_down(action_name)
    local controllers = self.actions[action_name]
    for _, controller in ipairs(controllers) do
        local value = controller.value

        if controller.device == 'keybord' then
            if love.keyboard.isDown(value) then
                return true
            end

        elseif controller.device == 'mouse' then
            if love.mouse.isDown(value) then
                if controller.event == 'button' then
                    return true
                end
            end

        elseif controller.device == 'joystick' then
            local joystick = joysticks[controller.number]
            if not joystick then
                goto continue
            end
            if controller.event == 'button' then
                if joystick:isDown(value) then
                    return true
                end
            elseif controller.event == 'hat' then
                local hat = joystick:getHat(controller.index)
                -- action detection is possible for 'up' and 'left'
                -- while pressing the 'upleft' hat position
                if string.find(hat, value) then
                    return true
                end
            elseif controller.event == 'axis' then
                -- detect gamepad can avoid that some axis like triggers
                -- start from -1 to 1 and not 0 to +/- 1
                -- TODO: use axis_threshold
                local index = controller.index
                if joystick:isGamepad() then
                    if type(index) == 'string' then
                        if joystick:getGamepadAxis(index) == value then
                            return true
                        end
                    end
                else
                    if type(index) == 'number' then
                        if joystick:getAxis(index) == value then
                            return true
                        end
                    end
                end
            end
        end
        ::continue::
    end
end

function Input:is_pressed(action_name)

end

function Input:is_released(action_name)

end

function Input:get_active_actions()
    -- returns a table with action that are active
    local actions = {}
    for name, action in pairs(self.actions) do
        if self:is_down(name) then
            table.insert(actions, name)
        end
    end
    return actions
end

return Input

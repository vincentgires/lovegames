--[[
TODO:
- add a listener to set controller by user input
- save/read from file: lua/json?
- sequence manipulation (fireball, dragon, etc)
]]

local function is_item_in_table(item_name, t)
    for i, item in ipairs(t) do
        if item == item_name then
            return true
        end
    end
    return false
end

local GAMEPAD_AXIS = {
    'leftx', 'rightx', 'lefty', 'righty', 'triggerleft', 'triggerright'}

local joysticks = love.joystick.getJoysticks()

local Input = {
    deadzone = 0.1,
    actions = {},
    active_actions = {},
    prev_actions = {}
}

function Input:new(t)
    -- Input can be instanciated to set several input manager
    -- example: two players, menu navigation
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

    --[[
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
    ]]

    self.prev_actions = self.active_actions
    self.active_actions = self:get_active_actions()
end

function Input:is_active(action_name)
    local controllers = self.actions[action_name]
    for _, controller in ipairs(controllers) do

        if controller.device == 'keybord' then
            if love.keyboard.isDown(controller.value) then
                return true
            end

        elseif controller.device == 'mouse' then
            if love.mouse.isDown(controller.value) then
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
                -- TODO: check if joystick:isGamepad()
                -- joystick:isGamepadDown(controller.value)
                if joystick:isDown(controller.value) then
                    return true
                end
            elseif controller.event == 'hat' then
                local hat = joystick:getHat(controller.index)
                -- action detection is possible for 'up' and 'left'
                -- while pressing the 'upleft' hat position
                if string.find(hat, controller.value) then
                    return true
                end
            elseif controller.event == 'axis' then
                -- detect gamepad can avoid that some axis like triggers
                -- start from -1 to 1 and not 0 to +/- 1
                local index = controller.index
                local axis_value

                -- detect if axis is active
                -- 0 is the rest pose
                if joystick:isGamepad() then
                    if type(index) == 'string' then
                        local active_value = joystick:getGamepadAxis(index)
                        if active_value ~= 0 then
                            axis_value = active_value
                        end
                    end
                else
                    if type(index) == 'number' then
                        local active_value = joystick:getAxis(index)
                        if active_value ~= 0 then
                            axis_value = active_value
                        end
                    end
                end

                -- detect position
                if axis_value then
                    -- positif
                    if axis_value > 0 and controller.value > 0 then
                        if axis_value >= controller.value * self.deadzone then
                            return true
                        end
                    -- negatif
                    elseif axis_value < 0 and controller.value < 0 then
                        if axis_value <= controller.value * self.deadzone then
                            return true
                        end
                    end
                end

            end
        end
        ::continue::
    end
end

function Input:is_pressed(action)
    local in_active = is_item_in_table(action, self.active_actions)
    local in_prev = is_item_in_table(action, self.prev_actions)
    if in_active and not in_prev then
        return true
    end
    return false
end

function Input:is_released(action)
    local in_active = is_item_in_table(action, self.active_actions)
    local in_prev = is_item_in_table(action, self.prev_actions)
    if in_prev and not in_active then
        return true
    end
    return false
end

function Input:get_active_actions()
    -- returns a table with action that are active
    local actions = {}
    for name, action in pairs(self.actions) do
        if self:is_active(name) then
            table.insert(actions, name)
        end
    end
    return actions
end

return {Input=Input}

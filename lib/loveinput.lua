--[[
TODO:
- add a listener to set controller by user input
- save/read from file: lua/json?
- sequence manipulation (fireball, dragon, etc)
]]

local GAMEPAD_AXIS = {
    'leftx', 'rightx', 'lefty', 'righty', 'triggerleft', 'triggerright'}
local joysticks = love.joystick.getJoysticks()

local function is_item_in_table(item_name, t)
    for i, item in ipairs(t) do
        if item == item_name then
            return true
        end
    end
    return false
end

local function listen(deadzone)
    deadzone = deadzone or 0
    local controls = {} -- list of {device, number, event, index, value}
    -- mouse
    -- TODO: add scroll wheels
    for btn=1, 3 do -- TODO: mouse could have more than 3 buttons
        if love.mouse.isDown(btn) then
            local control = {device='mouse', event='button', value=btn}
            table.insert(controls, control)
        end
    end
    -- keyboard
    -- TODO
    -- love.keyboard.isDown
    -- joystick
    for num, joystick in ipairs(joysticks) do
        -- print(joystick:getName())
        -- buttons
        for btn=1, joystick:getButtonCount() do
            if joystick:isDown(btn) then
                --print('boutton', joystick, btn, 'num', num)
                local control = {device='joystick', number=num, event='button', value=btn}
                table.insert(controls, control)
            end
        end
        -- hat
        for i=1, joystick:getHatCount() do
            local hat = joystick:getHat(i)
            if hat ~= 'c' then -- 'c' is the rest hat position
                local control = {device='joystick', number=num, event='hat', index=i, value=hat}
                table.insert(controls, control)
            end
        end
        -- axis
        -- detect gamepad can avoid that some axis like triggers
        -- start from -1 to 1 and not 0 to +/- 1
        if joystick:isGamepad() then
            for i, axe in ipairs(GAMEPAD_AXIS) do
                local axis_value = joystick:getGamepadAxis(axe)
                local control = {device='joystick', number=num, event='axis', index=i}
                -- TODO: deadzone
                -- TODO: this part is duplicated
                if axis_value > 0 then
                    control.value = '+' end
                if axis_value < 0 then
                    control.value = '-' end
                if axis_value ~= 0 then
                    table.insert(controls, control) end
            end
        else
            for i=1, joystick:getAxisCount() do
                local axis_value = joystick:getAxis(i)
                local control = {device='joystick', number=num, event='axis', index=i}
                -- TODO: deadzone
                -- TODO: this part is duplicated
                if axis_value > 0 then
                    control.value = '+' end
                if axis_value < 0 then
                    control.value = '-' end
                if axis_value ~= 0 then
                    table.insert(controls, control) end
            end
        end
    end
    return controls
end

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

-- TODO
function Input:unbind_action(name)

end

function Input:update(dt)
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

return {Input=Input, listen=listen}

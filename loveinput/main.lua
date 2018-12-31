loveinput = require 'loveinput'
serialize = require 'serialize'

function love.load()
    input = loveinput.Input:new()
    local jump_control = {device='joystick', number=2, event='button', value=1}
    local left_control = {device='joystick', number=2, event='hat', index=1, value='l'}
    local right_control = {device='joystick', number=2, event='hat', index=1, value='r'}
    local click_control = {device='mouse', event='button', value=1}
    local key_control = {device='keybord', value='space'}
    local axe_control = {device='joystick', number=2, event='axis', index=2, direction='+'}
    local trigger_control = {device='joystick', number=2, event='axis', index='triggerleft', direction='+'}
    local axis_left_control = {device='joystick', number=2, event='axis', index='leftx', direction='-'}
    local axis_right_control = {device='joystick', number=2, event='axis', index='leftx', direction='+'}
    local axis2_left_control = {device='joystick', number=2, event='axis', index='rightx', direction='-'}
    local axis2_right_control = {device='joystick', number=2, event='axis', index='rightx', direction='+'}
    input:bind_action('jump', jump_control)
    input:bind_action('left', left_control)
    input:bind_action('right', right_control)
    input:bind_action('click', click_control)
    input:bind_action('key', key_control)
    input:bind_action('axe', axe_control)
    input:bind_action('trigger', trigger_control)
    input:bind_action('left axis', axis_left_control)
    input:bind_action('right axis', axis_right_control)
    input:bind_action('left axis2', axis2_left_control)
    input:bind_action('right axis2', axis2_right_control)
end

function love.update(dt)
    --[[
    if #input.active_actions > 0 then
        serialize.print_table(input.active_actions) end

    -- needed to detect pressed/released actions
    input:update(dt)

    if input:is_pressed('jump') then
        print(input:is_pressed('jump'))
    end

    if input:is_released('jump') then
        print(input:is_released('jump'))
    end
    ]]

    --if loveinput.listen() then
    --    serialize.print_table(loveinput.listen())
    --end
    serialize.print_table(loveinput.listen())

    -- force console output
    io.flush()
end

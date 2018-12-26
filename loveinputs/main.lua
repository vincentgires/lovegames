inputengine = require 'inputengine'
serialize = require 'serialize'

function love.load()
    input = inputengine:new()
    local jump_control = {device='joystick', number=2, event='button', value=1}
    local left_control = {device='joystick', number=2, event='hat', index=1, value='l'}
    local right_control = {device='joystick', number=2, event='hat', index=1, value='r'}
    local click_control = {device='mouse', event='button', value=1}
    local key_control = {device='keybord', value='space'}
    local axe_control = {device='joystick', number=2, event='axis', index=2, value=1}
    input:bind_action('jump', jump_control)
    input:bind_action('left', left_control)
    input:bind_action('right', right_control)
    input:bind_action('click', click_control)
    input:bind_action('key', key_control)
    input:bind_action('axe', axe_control)
end

function love.update(dt)
    local active_actions = input:get_active_actions()
    if #active_actions > 0 then serialize.print_table(input:get_active_actions()) end

    -- force console output
    io.flush()
end

function love.draw()

end

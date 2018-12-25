inputengine = require 'inputengine'
serialize = require 'serialize'

function love.load()
    input = inputengine:new()
    local jump_control = {device='joystick', number=2, event='button', value=1}
    local jump_control_hat = {device='joystick', number=2, event='hat', value=1}
    local click_control = {device='mouse', event='button', value=1}
    local key_control = {device='keybord', value='space'}
    input:bind_action('jump', jump_control)
    input:bind_action('jump', jump_control_hat)
    input:bind_action('click', click_control)
    input:bind_action('key', key_control)
end

function love.update(dt)
    local active_actions = input:get_active_actions()
    if #active_actions > 0 then serialize.print_table(input:get_active_actions()) end

    -- force console output
    io.flush()
end

function love.draw()

end

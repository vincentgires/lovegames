inputengine = require 'inputengine'
serialize = require 'serialize'

function love.load()
    input = inputengine.Input:new()
    local jump_control = {device='joystick', number=2, event='button', value=1}
    local jump_control_hat = {device='joystick', number=2, event='hat', value=1}
    local click_control = {device='mouse', event='button', value=1}
    input:bind_action('jump', jump_control)
    input:bind_action('jump', jump_control_hat)
    input:bind_action('click', click_control)
    -- serialize.print_table(input.controls)
end

function love.update(dt)
    input:update()
    input:is_down('jump')
    input:is_down('click')
    -- force console output
    io.flush()
end

function love.draw()

end

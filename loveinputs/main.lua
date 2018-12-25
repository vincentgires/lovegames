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
    -- serialize.print_table(input.controls)
end

function love.update(dt)
    --input:update()
    if input:is_down('jump') then
        print(input:is_down('jump'))
    end
    if input:is_down('click') then
        print(input:is_down('click'))
    end
    if input:is_down('key') then
        print(input:is_down('key'))
    end
    -- force console output
    io.flush()
end

function love.draw()

end

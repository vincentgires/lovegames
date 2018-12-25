inputengine = require 'inputengine'
serialize = require 'serialize'

function love.load()
    input = inputengine:new()
    local jump_control = {device='joystick', number=2, event='button', value=1}
    local jump_control_hat = {device='joystick', number=2, event='hat', value=1}
    local click_control = {device='mouse', event='button', value=1}
    input:bind_action('jump', jump_control)
    input:bind_action('jump', jump_control_hat)
    input:bind_action('click', click_control)
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
    -- force console output
    io.flush()
end

function love.draw()

end

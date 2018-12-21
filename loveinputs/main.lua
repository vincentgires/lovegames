Input = require 'inputengine'
serialize = require 'serialize'

function love.load()
    input = Input:new()
    local jump_control = {subtype='JOYSTICK_BUTTON', value=1}
    local click_control = {subtype='MOUSE_BUTTON', value=1}
    input:add_control('jump', jump_control)
    input:add_control('click', click_control)

    serialize.print_table(input.controls)
end

function love.update(dt)
    input:update()

    -- force console output
    io.flush()
end

function love.draw()

end

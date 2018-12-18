Input = require 'inputengine'

function love.load()
    input = Input:new()
end

function love.update(dt)
    input:update()

    -- force console output
    io.flush()
end

function love.draw()

end

menu = {
    active = true
}


function draw_color_text()

end


function menu:update(dt)

end


function menu:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local font = love.graphics.getFont()
    local text = 'Press enter to start'
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(
        text,
        width/2 - font:getWidth(text)/2,
        height/2 - font:getHeight(text)/2)
end

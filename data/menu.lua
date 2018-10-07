local ROOT_ITEMS = {
    'START GAME',
    'OPTIONS'
}

local OPTIONS_ITEMS = {
    'SHAKE',
    'ROTATIONS',
    'SWAP COLORS',
    'MULTIPLAYER COLLISION'

}

local ITEM_SPACE = 10


menu = {
    active = true
}


function draw_color_text()

end


function menu:update(dt)

    -- if love.keyboard.isDown('space') then
    --     print('space')
    -- end

end


function menu:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    love.graphics.setFont(font.menu)
    local font = love.graphics.getFont()

--     local text = 'Press enter to start'
--     love.graphics.setColor(1, 1, 1)
--     love.graphics.print(
--         text,
--         width/2 - font:getWidth(text)/2,
--         height/2 - font:getHeight(text)/2)

    for i=1, #ROOT_ITEMS do
        love.graphics.print(
            ROOT_ITEMS[i],
            width/2 - font:getWidth(ROOT_ITEMS[i])/2,
            height/2 - font:getHeight(ROOT_ITEMS[i])/2 + ITEM_SPACE -- ????
        )
    end
end

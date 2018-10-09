local TITLE = 'SUPER POLYGON'

local ROOT_ITEMS = {
    'START GAME',
    'OPTIONS'
}

local OPTIONS_ITEMS = {
    'SPEED',
    'SHAKE',
    'ROTATIONS',
    'SWAP COLORS',
    'MULTIPLAYER COLLISION'
}

menu = {
    active = true,
    items = {}
}


function menu:create(items)
    for i, v in ipairs(items) do
        print(i, v)
    end
   -- return ???
end


function draw_color_text()

end


function menu:update(dt)
end


function menu:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    love.graphics.setColor(1, .7, .3)

    love.graphics.setFont(font.title)
    love.graphics.print(
        'SUPER POLYGON',
        width/2 - font.title:getWidth(TITLE)/2,
        height/100*10)

    love.graphics.setFont(font.menu)
    for i=1, #OPTIONS_ITEMS do
        local items_area = height/2
        local items_y_step = items_area/#OPTIONS_ITEMS
        love.graphics.print(
            OPTIONS_ITEMS[i],
            width/2 - font.menu:getWidth(OPTIONS_ITEMS[i])/2,
            (items_y_step * i) - items_y_step/#OPTIONS_ITEMS - font.menu:getHeight(OPTIONS_ITEMS[i]) + items_area/2
        )
    end
end

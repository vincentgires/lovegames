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

local ITEM_TYPE = {
    'ACTION',
    'TEXTINPUT',
    'COLORHUE'
}

-------------------------------------------------------------------------------

MenuItem = {
    active = false,
    text = '',
    subtype = nil
}

function MenuItem:new()
    local instance = {}
    setmetatable(instance, self)
    self.__index = self
    return instance
end

-------------------------------------------------------------------------------

menu = {
    active = true,
    items = {}
}


function menu:create(items)
    local itemstable = {}
    for i, v in ipairs(items) do
        local item = MenuItem:new()
        item.text = v
        table.insert(itemstable, item)
    end
   return itemstable
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
            ((items_y_step * i) - items_y_step/#OPTIONS_ITEMS
             - font.menu:getHeight(OPTIONS_ITEMS[i]) + items_area/2)
        )
    end
end


local m = menu:create(OPTIONS_ITEMS)
print(#m)

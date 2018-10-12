local GAME_TITLE = 'SUPER POLYGON'

-------------------------------------------------------------------------------

MenuItem = {
    active = false,
    subtype = nil
}

function MenuItem:new(text, subtype)
    local instance = {}
    instance.text = text or '---'
    instance.subtype = subtype
    setmetatable(instance, self)
    self.__index = self
    return instance
end

-------------------------------------------------------------------------------

local ROOT_ITEMS = {
    MenuItem:new('START GAME', 'ACTION'),
    MenuItem:new('OPTIONS', 'MENU'),
}

local OPTIONS_ITEMS = {
    MenuItem:new('SPEED', 'NUMBER'),
    MenuItem:new('SHAKE', 'BOOLEAN'),
    MenuItem:new('ROTATIONS', 'DEGREE'),
    MenuItem:new('SWAP COLORS', 'BOOLEAN'),
    MenuItem:new('MULTIPLAYER COLLISION', 'BOOLEAN')
}

local ITEM_TYPE = {
    'ACTION',
    'MENU',
    'TEXTINPUT',
    'COLORHUE',
    'NUMBER',
    'DEGREE',
    'BOOLEAN'
}

-------------------------------------------------------------------------------

menu = {
    active = true,
    items = {}
}

menu.items = OPTIONS_ITEMS


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
        width/2 - font.title:getWidth(GAME_TITLE)/2,
        height/100*10)

    love.graphics.setFont(font.menu)
    for i=1, #menu.items do
        local items_area = height/2
        local items_y_step = items_area/#menu.items
        love.graphics.print(
            menu.items[i].text,
            width/2 - font.menu:getWidth(menu.items[i].text)/2,
            ((items_y_step * i) - items_y_step/#menu.items
             - font.menu:getHeight(menu.items[i].text) + items_area/2)
        )
    end
end

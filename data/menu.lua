local GAME_TITLE = {
    text = 'SUPER POLYGON',
    color = {1.0, 0.7, 0.3}
}

-------------------------------------------------------------------------------

MenuItem = {
    subtype = nil,
    color = {1.0, 0.7, 0.3},
    active_color = {1.0, 1.0, 1.0}
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
    active_index = 1,
    items = {},
}

menu.items = OPTIONS_ITEMS


function draw_color_text()

end


function menu:next_item(direction)
    local new_index = self.active_index + direction
    if new_index > #self.items then
        self.active_index = 1
    elseif new_index < 1 then
        self.active_index = #self.items
    else
        self.active_index = new_index
    end
end

function menu:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(GAME_TITLE.color)
    love.graphics.setFont(font.title)
    love.graphics.print(
        'SUPER POLYGON',
        width/2 - font.title:getWidth(GAME_TITLE.text)/2,
        height/100*10)

    love.graphics.setFont(font.menu)
    for i, item in pairs(self.items) do
        local items_area = height/2
        local items_y_step = items_area/#self.items
        if self.active_index == i then
            love.graphics.setColor(item.active_color)
        else
            love.graphics.setColor(item.color)
        end
        love.graphics.print(
            item.text,
            width/2 - font.menu:getWidth(item.text)/2,
            ((items_y_step * i) - items_y_step/#self.items
             - font.menu:getHeight(item.text) + items_area/2)
        )
    end
end

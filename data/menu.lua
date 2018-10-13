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

function MenuItem:new(text, subtype, datapath)
    self.__index = self
    local instance = {}
    setmetatable(instance, self)
    instance.text = text or '---'
    instance.subtype = subtype
    instance.datapath = datapath
    return instance
end

function MenuItem:get_value()
    -- the result should be something like _G['game']['camera']['rotation']
    local value = _G
    for i, v in pairs(self.datapath) do
        value = value[v]
    end
    return value
end

function MenuItem:set_value(val)
    --[[]]
    local value = _G
    for i, v in pairs(self.datapath) do
        -- stop before the last value to make it value settable
        if i == #self.datapath then
            goto continue
        end
        value = value[v]
    end
    ::continue::
    local attr = self.datapath[#self.datapath]
    value[attr] = val
end

-------------------------------------------------------------------------------

local ROOT_ITEMS = {
    MenuItem:new('START GAME', 'ACTION'),
    MenuItem:new('OPTIONS', 'MENU'),
}

local OPTIONS_ITEMS = {
    MenuItem:new('SPEED', 'NUMBER', {'game', 'speed'}),
    MenuItem:new('SHAKE', 'BOOLEAN', {'game', 'camera', 'shake'}),
    MenuItem:new('ROTATIONS', 'BOOLEAN', {'game', 'camera', 'rotation'}),
    MenuItem:new('SWAP COLORS', 'BOOLEAN', {'game', 'scene', 'swap_bg_colors'}),
    MenuItem:new('MULTIPLAYER COLLISION', 'BOOLEAN', {'game', 'multiplayer', 'collision'})
}

--[[
local ITEM_TYPE = {
    'ACTION',
    'MENU',
    'TEXTINPUT',
    'COLORHUE',
    'NUMBER',
    'BOOLEAN'
}
]]

-------------------------------------------------------------------------------

menu = {
    active = true,
    active_index = 1,
    items = {},
}
menu.items = OPTIONS_ITEMS


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
        local text = item.text
        if self.active_index == i then
            love.graphics.setColor(item.active_color)
            text = '> ' .. text
            local value = item:get_value()
            if item.subtype == 'BOOLEAN' then
                if value then text = text .. ' [*]' else text = text .. ' [_]' end
            elseif item.subtype == 'NUMBER' then
                text = text .. ' ['.. value ..']'
            end
        else
            love.graphics.setColor(item.color)
        end
        love.graphics.print(
            text,
            width/2 - font.menu:getWidth(text)/2,
            ((items_y_step * i) - items_y_step/#self.items
             - font.menu:getHeight(text) + items_area/2)
        )
    end
end

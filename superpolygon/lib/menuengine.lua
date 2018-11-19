--[[
TODO:
- text alignment
- sound
- manage more items than screen can display
- set not selectable item (grey it out) (attr: enable/use)
- second action (to delete item or increase color intensity)
- or add unlimited ACTIONS with custom key binding
]]

local utf8 = require 'utf8'
local colorutils = require 'lib/colorutils'

local ITEM_TYPE = {
    'ACTION',
    'TEXTINPUT',
    'COLORHUE',
    'NUMBER',
    'BOOLEAN',
    'SETKEY'
}
local DEFAULT_ITEM_COLOR = {1.0, 0.7, 0.3}
local DEFAULT_ACTIVE_COLOR = {1.0, 1.0, 1.0}

local MenuItem = {
    use = true,
    subtype = nil,
    color = DEFAULT_ITEM_COLOR,
    active_color = DEFAULT_ACTIVE_COLOR
}

function MenuItem:new(t)
    -- t = {text, subtype, datapath, property, options, use}
    t = t or {}
    self.__index = self
    setmetatable(t, self)
    return t
end

function MenuItem:get_value()
    if not self.datapath then
        return nil
    end
    local value = self.datapath
    for _, v in pairs(self.property) do
        value = value[v]
    end
    -- the result should be something like my_table['my']['property']
    return value
end

function MenuItem:set_value(val)
    local value = self.datapath
    for i, v in pairs(self.property) do
        -- stop before the last value to make the value settable
        if i == #self.property then
            goto continue
        end
        value = value[v]
    end
    ::continue::
    local prop = self.property[#self.property]
    value[prop] = val
end

local menuengine = {
    title = nil,
    active_index = 1,
    items = {}, -- current MenuItems
    parent_items = {}, -- list of tables of MenuItems
    wait_for_key = false,
    info = nil
}

function menuengine:create_item(t)
    local item = MenuItem:new(t)
    return item
end

function menuengine:set_items(items)
    table.insert(self.parent_items, self.items)
    self.items = items
    self.active_index = 1
end

function menuengine:set_parent_items()
    if #self.parent_items ~= 0 then
        self.items = self:get_parent_menuitems()
        table.remove(self.parent_items, #self.parent_items)
    end
    self.active_index = 1
end

function menuengine:get_parent_menuitems()
    local parent_item = self.parent_items[#self.parent_items]
    return parent_item
end

function menuengine:edit_textinput(t)
    local item = self.items[self.active_index]
    if item.subtype == 'TEXTINPUT' then
        local val = item:get_value()
        val = val..t -- add input text
        item:set_value(val) -- update datapath value
        item.text = val -- update text menu
    end
end

function menuengine:keypressed(key)
    local item = self.items[self.active_index]

    -- Set keys
    if self.wait_for_key then
        if item.subtype == 'SETKEY' then
            item:set_value(key)
            self.wait_for_key = false
        end

    else
        if key == 'escape' then
            if not self.wait_for_key then
                self:set_parent_items()
            end

        elseif key == 'up' then
            self:next_item(-1)

        elseif key == 'down' then
            self:next_item(1)

        elseif key == 'return' then
            if item.subtype == 'BOOLEAN' then
                local val = not item:get_value()
                item:set_value(val)
            end

            if item.subtype == 'ACTION' then
                if item.options then
                    item.datapath(item.options)
                else
                    item.datapath()
                end
            end

            if item.subtype == 'SETKEY' then
                self.wait_for_key = true
            end

        elseif key == 'left' or key == 'right' then
            local direction = nil

            if item.subtype == 'NUMBER' then
                if key == 'left' then direction = -1
                elseif key == 'right' then direction = 1 end
                local val = item:get_value() + direction
                item:set_value(val)
            end

            if item.subtype == 'BOOLEAN' then
                local val = not item:get_value()
                item:set_value(val)
            end

            if item.subtype == 'COLORHUE' then
                local r = item:get_value()[1]
                local g = item:get_value()[2]
                local b = item:get_value()[3]
                local h, s, v = colorutils.rgb_to_hsv(r, g, b)
                if key == 'left' then direction = -0.05
                elseif key == 'right' then direction = 0.05 end
                r, g, b = colorutils.hsv_to_rgb(h+direction, s, v)
                item:set_value({r, g, b})
            end

        elseif key == 'backspace' then
            if item.subtype == 'TEXTINPUT' then
                local val = item:get_value()
                local byteoffset = utf8.offset(val, -1)
                if byteoffset then
                    val = string.sub(val, 1, byteoffset - 1)
                    item:set_value(val)
                    item.text = val
                end
            end
        end
    end
end

function menuengine:next_item(direction)
    local new_index = self.active_index + direction
    if new_index > #self.items then
        self.active_index = 1
    elseif new_index < 1 then
        self.active_index = #self.items
    else
        self.active_index = new_index
    end
    if not self.items[self.active_index].use then
        menuengine:next_item(direction)
    end
end

function menuengine:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    love.graphics.setColor(DEFAULT_ITEM_COLOR)
    love.graphics.setFont(font.title)
    love.graphics.print(
        self.title,
        width/2 - font.title:getWidth(self.title)/2,
        height/100*10)

    love.graphics.setFont(font.menu_items)
    for i, item in pairs(self.items) do
        local text = item.text

        if self.active_index == i then
            love.graphics.setColor(item.active_color)
            if item.subtype == 'BOOLEAN' then
                text = '> '..text
                local value = item:get_value()
                if value then text = text..' [*]' else text = text..' [_]' end
            elseif item.subtype == 'NUMBER' then
                text = '> '..text
                local value = item:get_value()
                text = text..' ['..value..']'
            elseif item.subtype == 'ACTION' or item.subtype == 'COLORHUE' then
                text = '> '..text
            elseif item.subtype == 'TEXTINPUT' then
                text = '> '..text..'_'
            elseif item.subtype == 'SETKEY' then
                text = '> '..text
                if self.wait_for_key then
                    text = text..' [_]'
                else
                    local value = item:get_value()
                    text = text..' ['..value..']'
                end
            end
        else
            love.graphics.setColor(item.color)
        end

        local x = width/2 - font.menu_items:getWidth(text)/2
        local text_height = font.menu_items:getHeight(text)
        local text_center = (height/2 - text_height/2)
        local y = text_center + text_height*i
        local y = y - (text_height*#self.items)/2
        love.graphics.print(text, x, y)

        if item.subtype == 'COLORHUE' then
            local hue_height = 10*window.scale
            local hue_width = width/3
            local hue_step = 50
            local w = hue_width/hue_step

            local hue_y = y+font.menu_items:getHeight(text)
            -- HUE ramp
            for i=1, hue_step, 1 do
                local r, g, b = colorutils.hsv_to_rgb(i/hue_step, 1, 1)
                love.graphics.setColor(r, g, b)
                love.graphics.rectangle('fill', hue_width+i*w, hue_y, w, hue_height)
            end

            -- cursor position in the ramp
            do
                -- TODO: use table.unpack({1,2,3})
                local r = item:get_value()[1]
                local g = item:get_value()[2]
                local b = item:get_value()[3]
                local h, s, v = colorutils.rgb_to_hsv(r, g, b)
                love.graphics.setColor(r, g, b)
                local tri_x = hue_width+(h*hue_step)*w
                local tri_y = hue_y+hue_height
                local s = 5*window.scale
                local vertices = {tri_x-s, tri_y+s*2, tri_x, tri_y, tri_x+s, tri_y+s*2}
                love.graphics.polygon('fill', vertices)
            end
        end
    end
    if self.info then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font.menu_info)
        local info_text = self.info
        local info_width = font.menu_info:getWidth(info_text)
        local info_height = font.menu_info:getHeight(info_text)
        local x = width/2 - info_width/2
        local y = height - info_height*2
        love.graphics.print(info_text, x, y)
    end
end

return menuengine

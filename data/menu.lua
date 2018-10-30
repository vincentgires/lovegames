local utf8 = require('utf8')

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
    if not self.datapath then
        return nil
    end

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
        -- stop before the last value to make the value settable
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
-- MenuItem:new('SPEED', 'NUMBER', {'game', 'speed'}),
-- ............................... datapath: game.speed

function set_players_menuitems()
    local items = {}
    for i, player in ipairs(players) do
        table.insert(items, MenuItem:new(player.name, 'PLAYER'))
    end
    table.insert(items, MenuItem:new('ADD PLAYER', 'ACTION', add_player))
    menu.items = items
end

function add_player()
    players:new()
    set_players_menuitems()
end

function set_player_options_menuitems(player)
    local player_num = nil
    for i, p in ipairs(players) do
        if p == player then
            player_num = i
        end
    end

    local items = {
        MenuItem:new(player.name, 'TEXTINPUT'),
        MenuItem:new('LEFT KEY', 'SETKEY', {'players', player_num, 'key_left'}),
        MenuItem:new('RIGHT KEY', 'SETKEY', {'players', player_num, 'key_right'}),
        MenuItem:new('COLOR', 'COLORHUE', {'players', player_num, 'color'})
    }
    menu.items = items
end

function remove_player(p)
    for k, v in pairs(players) do
        if v == p then
            table.remove(players, k)
        end
    end
    set_players_menuitems()
end

local root_items = {
    MenuItem:new('START GAME', 'ACTION'),
    MenuItem:new('OPTIONS', 'MENU'),
}

local options_items = {
    MenuItem:new('SPEED', 'NUMBER', {'game', 'speed'}),
    MenuItem:new('SHAKE', 'BOOLEAN', {'game', 'camera', 'shake'}),
    MenuItem:new('ROTATIONS', 'BOOLEAN', {'game', 'camera', 'rotation'}),
    MenuItem:new('SWAP COLORS', 'BOOLEAN', {'game', 'scene', 'swap_bg_colors'}),
    MenuItem:new('MULTIPLAYER COLLISION', 'BOOLEAN', {'game', 'multiplayer', 'collision'})
}

--[[
local players_items = {
    MenuItem:new('ADD PLAYER', 'ACTION', add_player)
}
--]]

--[[
local ITEM_TYPE = {
    'ACTION',
    'MENU',
    'TEXTINPUT',
    'COLORHUE',
    'NUMBER',
    'BOOLEAN',
    'PLAYER',
    'SETKEY',
}
]]

-------------------------------------------------------------------------------

menu = {
    active = true,
    active_index = 1,
    items = {},
    wait_for_key = false
}

-- inital menu
-- menu.items = options_items
-- set_players_menuitems()
set_player_options_menuitems(players[1])


function menu:edit_textinput(t)
    local item = self.items[self.active_index]
    if item.subtype == 'PLAYER' or item.subtype == 'TEXTINPUT' then
        -- TODO: make it more generic, no direct call to player
        local player = players[self.active_index]
        player.name = player.name .. t -- update player name
        item.text = player.name -- update player name in menu
    elseif item.subtype == 'SETKEY' then
        -- BUG DOES NOT RUN
        if menu.wait_for_key then
            print('WIP')
            menu.wait_for_key = false
        end
    end
end

function menu:keypressed(key)
    local item = self.items[self.active_index]

    if key == 'up' then
        self:next_item(-1)

    elseif key == 'down' then
        self:next_item(1)

    elseif key == 'space' or key == 'return' then
        if item.subtype == 'BOOLEAN' then
            local val = not item:get_value()
            item:set_value(val)
        end

        if item.subtype == 'ACTION' then
            item.datapath()
        end

        if item.subtype == 'SETKEY' then
            -- print(item:set_value('n'))
            menu.wait_for_key = true
        end

    elseif key == 'left' or key == 'right' then
        local direction = nil

        if item.subtype == 'NUMBER' then
            if key == 'left' then direction = -1
            elseif key == 'right' then direction = 1 end
            local val = item:get_value() + direction
            item:set_value(val)
        end

        if item.subtype == 'COLORHUE' then
            local r = item:get_value()[1]
            local g = item:get_value()[2]
            local b = item:get_value()[3]
            local h, s, v = rgb_to_hsv(r, g, b)
            if key == 'left' then direction = -0.05
            elseif key == 'right' then direction = 0.05 end
            r, g, b = hsv_to_rgb(h+direction, s, v)
            item:set_value({r, g, b})
        end

    elseif key == 'backspace' then
        if item.subtype == 'PLAYER' or item.subtype == 'TEXTINPUT' then
            local player = players[self.active_index]
            local byteoffset = utf8.offset(player.name, -1)
            if byteoffset then
                player.name = string.sub(player.name, 1, byteoffset - 1)
                item.text = player.name
            end
        end

    elseif key == 'delete' then
        if item.subtype == 'PLAYER' then
            local player = players[self.active_index]
            remove_player(player)
        end
    end
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
        local text = item.text
        if self.active_index == i then
            love.graphics.setColor(item.active_color)
            if item.subtype == 'BOOLEAN' then
                text = '> ' .. text
                local value = item:get_value()
                if value then text = text .. ' [*]' else text = text .. ' [_]' end
            elseif item.subtype == 'NUMBER' then
                text = '> ' .. text
                local value = item:get_value()
                text = text .. ' ['.. value ..']'
            elseif item.subtype == 'ACTION' then
                text = '> ' .. text
            elseif item.subtype == 'PLAYER' then
                text = '> #' ..tostring(i).. ' ' .. text .. '_'
            elseif item.subtype == 'TEXTINPUT' then
                text = '> ' .. text .. '_'
            elseif item.subtype == 'SETKEY' then
                text = '> ' .. text
                if menu.wait_for_key then
                    text = text .. ' [_]'
                else
                    local value = item:get_value()
                    text = text .. ' ['.. value ..']'
                end
            end

        else
            love.graphics.setColor(item.color)
            if item.subtype == 'PLAYER' then
                text = '#' ..tostring(i).. ' ' .. text
            end

        end

        local y = ((items_y_step * i) - items_y_step/#self.items
                   - font.menu:getHeight(text) + items_area/2)

        love.graphics.print(
            text,
            width/2 - font.menu:getWidth(text)/2,
            y
        )

        if item.subtype == 'COLORHUE' then
            local hue_height = 10*window.scale
            local hue_width = width/3
            local hue_step = 50
            local w = hue_width/hue_step

            -- HUE ramp
            for i=1, hue_step, 1 do
                local r, g, b = hsv_to_rgb(i/hue_step, 1, 1)
                love.graphics.setColor(r, g, b)
                love.graphics.rectangle("fill", hue_width+i*w, y+30, w, hue_height)
            end

            -- player position in the ramp
            do
                local r = item:get_value()[1]
                local g = item:get_value()[2]
                local b = item:get_value()[3]
                local h, s, v = rgb_to_hsv(r, g, b)
                love.graphics.setColor(1, 1, 1)
                love.graphics.rectangle("fill", hue_width+(h*hue_step)*w, y+30, w, hue_height*2)
            end
        end
    end
end

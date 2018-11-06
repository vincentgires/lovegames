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

function MenuItem:new(text, subtype, datapath, options)
    self.__index = self
    local instance = {}
    setmetatable(instance, self)
    instance.text = text or '---'
    instance.subtype = subtype
    instance.datapath = datapath
    instance.options = options
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

local ITEM_TYPE = {
    'ACTION',
    'TEXTINPUT',
    'COLORHUE',
    'NUMBER',
    'BOOLEAN',
    'PLAYER',
    'SETKEY',
}

local options_items = {
    MenuItem:new(
        'SPEED', 'NUMBER',
        {'game', 'speed'}),
    MenuItem:new(
        'SHAKE', 'BOOLEAN',
        {'game', 'camera', 'shake'}),
    MenuItem:new(
        'CAMERA ROTATIONS', 'BOOLEAN',
        {'game', 'camera', 'rotation'}),
    MenuItem:new(
        'CAMERA SPEED', 'NUMBER',
        {'camera', 'speed'}),
    MenuItem:new(
        'SWAP COLORS', 'BOOLEAN',
        {'game', 'scene', 'swap_bg_colors'}),
    MenuItem:new(
        'MULTIPLAYER COLLISION', 'BOOLEAN',
        {'game', 'multiplayer', 'collision'})
}

local function start_game()
    menu.active = false
    game:start()
end

local function set_options_menuitems()
    menu:set_items(options_items)
end

function set_players_menuitems()
    local items = {}
    for i, player in ipairs(players) do
        local player_menuitem = MenuItem:new(
            player.name, 'PLAYER', {'players', i, 'name'}, {player=player})
        table.insert(items, player_menuitem)
    end
    table.insert(items, MenuItem:new('ADD PLAYER', 'ACTION', add_player))
    menu:set_items(items)
    menu.info = 'Remove player with DEL key'
end

function add_player()
    local player = players:new()
    set_players_menuitems()

    -- set menu active_index to new player
    for i, item in ipairs(menu.items) do
        if item.options then
            if item.options.player == player then
                menu.active_index = i
            end
        end
    end
end

function set_player_options_menuitems(player)
    local player_num = nil
    for i, p in ipairs(players) do
        if p == player then
            player_num = i
        end
    end

    local items = {
        MenuItem:new(
            player.name, 'TEXTINPUT',
            {'players', player_num, 'name'}),
        MenuItem:new(
            'LEFT KEY', 'SETKEY',
            {'players', player_num, 'key_left'}),
        MenuItem:new(
            'RIGHT KEY', 'SETKEY',
            {'players', player_num, 'key_right'}),
        MenuItem:new(
            'COLOR', 'COLORHUE',
            {'players', player_num, 'color'})
    }
    menu:set_items(items, set_players_menuitems)
    menu.info = nil
end

function set_blockgroups(t)
    block_groups = t.blockgroups
    start_game()
end

function set_blockgroups_menuitems()
    local items = {}
    local files = love.filesystem.getDirectoryItems(BLOCKGROUPS_FOLDER)
    for i, file in ipairs(files) do
        local chunk = love.filesystem.load(BLOCKGROUPS_FOLDER..'/'..file)
        local result = chunk()
        local name = result.name or file
        local blockgroups_menuitem = MenuItem:new(
            name, 'ACTION', set_blockgroups, {blockgroups=result})
        table.insert(items, blockgroups_menuitem)
    end
    menu:set_items(items)
    local save_directory = love.filesystem.getSaveDirectory()..'/'..BLOCKGROUPS_FOLDER
    menu.info = save_directory
end

function remove_player(p)
    for k, v in pairs(players) do
        if v == p then
            table.remove(players, k)
        end
    end
    set_players_menuitems()
end

root_items = {
    MenuItem:new('START GAME', 'ACTION', set_blockgroups_menuitems),
    MenuItem:new('PLAYERS', 'ACTION', set_players_menuitems),
    MenuItem:new('OPTIONS', 'ACTION', set_options_menuitems),
}

-------------------------------------------------------------------------------

menu = {
    active = true,
    active_index = 1,
    items = {},
    set_parent_items = nil, -- expect a function
    wait_for_key = false,
    info = nil
}

function menu:set_items(items, set_parent_items)
    self.items = items
    self.set_parent_items = set_parent_items
    self.active_index = 1
end

function menu:edit_textinput(t)
    local item = self.items[self.active_index]
    if item.subtype == 'PLAYER' or item.subtype == 'TEXTINPUT' then
        local val = item:get_value()
        val = val .. t -- add input text
        item:set_value(val) -- update datapath value
        item.text = val -- update text menu
    end
end

function menu:keypressed(key)
    local item = self.items[self.active_index]

    -- Set player keys
    if menu.wait_for_key then
        if item.subtype == 'SETKEY' then
            item:set_value(key)
            menu.wait_for_key = false
        end

    else
        if key == 'up' then
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
                menu.wait_for_key = true
            end

            if item.subtype == 'PLAYER' then
                local player = item.options.player
                set_player_options_menuitems(player)
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
                local h, s, v = rgb_to_hsv(r, g, b)
                if key == 'left' then direction = -0.05
                elseif key == 'right' then direction = 0.05 end
                r, g, b = hsv_to_rgb(h+direction, s, v)
                item:set_value({r, g, b})
            end

        elseif key == 'backspace' then
            if item.subtype == 'PLAYER' or item.subtype == 'TEXTINPUT' then
                local val = item:get_value()
                local byteoffset = utf8.offset(val, -1)
                if byteoffset then
                    val = string.sub(val, 1, byteoffset - 1)
                    item:set_value(val)
                    item.text = val
                end
            end

        elseif key == 'delete' then
            if item.subtype == 'PLAYER' then
                local player = item.options.player
                remove_player(player)
            end
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

    love.graphics.setFont(font.menu_items)
    for i, item in pairs(self.items) do
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
            elseif item.subtype == 'ACTION' or item.subtype == 'COLORHUE' then
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
                local r, g, b = hsv_to_rgb(i/hue_step, 1, 1)
                love.graphics.setColor(r, g, b)
                love.graphics.rectangle('fill', hue_width+i*w, hue_y, w, hue_height)
            end

            -- player position in the ramp
            do
                local r = item:get_value()[1]
                local g = item:get_value()[2]
                local b = item:get_value()[3]
                local h, s, v = rgb_to_hsv(r, g, b)
                love.graphics.setColor(r, g, b)
                local tri_x = hue_width+(h*hue_step)*w
                local tri_y = hue_y+hue_height
                local s = 5*window.scale
                local vertices = {tri_x-s, tri_y+s*2, tri_x, tri_y, tri_x+s, tri_y+s*2}
                love.graphics.polygon('fill', vertices)
            end
        end
    end
    if menu.info then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font.menu_info)
        local info_text = menu.info
        local info_width = font.menu_info:getWidth(info_text)
        local info_height = font.menu_info:getHeight(info_text)
        local x = width/2 - info_width/2
        local y = height - info_height*2
        love.graphics.print(info_text, x, y)
    end
end

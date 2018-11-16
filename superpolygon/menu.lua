local game = require 'game'
local players = require 'players'
local camera = require 'camera'
local blocksequence = require 'blocksequence'
local menuengine = require 'lib/menuengine'

local BLOCKGROUPS_FOLDER = 'blockgroups'

local menu = {
    active = true
}

local options_items = {
    menuengine:create_item{
        text='SHAKE',
        subtype='BOOLEAN',
        datapath=game,
        property={'camera', 'shake'}
    },
    menuengine:create_item{
        text='CAMERA ROTATIONS',
        subtype='BOOLEAN',
        datapath=game,
        property={'camera', 'rotation'}
    },
    menuengine:create_item{
        text='CAMERA SPEED',
        subtype='NUMBER',
        datapath=camera,
        property={'speed'}
    },
    menuengine:create_item{
        text='SWAP COLORS',
        subtype='BOOLEAN',
        datapath=game,
        property={'scene', 'swap_bg_colors'}
    },
    menuengine:create_item{
        text='MULTIPLAYER COLLISION',
        subtype='BOOLEAN',
        datapath=game,
        property={'multiplayer', 'collision'}
    }
}

local function start_game()
    menu.active = false
    game:start()
end

local function set_options_menuitems()
    menuengine:set_items(options_items)
end

local function remove_player(t)
    local player = t.player
    -- delete player in parent menuitems
    for k, v in pairs(menuengine.parent_items) do
        if v.options then
            local p = v.options.player
            if p == player then
                table.remove(menuengine.parent_items, k)
            end
        end
    end
    -- delete player object
    for k, v in pairs(players) do
        if v == player then
            table.remove(players, k)
        end
    end
    menuengine:set_items(menuengine.parent_items)
end

local function set_player_options_menuitems(t)
    local player = t.player
    local player_num = nil
    for i, p in ipairs(players) do
        if p == player then
            player_num = i
        end
    end

    local items = {
        menuengine:create_item{
            text=player.name,
            subtype='TEXTINPUT',
            datapath=players,
            property={player_num, 'name'}
        },
        menuengine:create_item{
            text='LEFT KEY',
            subtype='SETKEY',
            datapath=players,
            property={player_num, 'key_left'}
        },
        menuengine:create_item{
            text='RIGHT KEY',
            subtype='SETKEY',
            datapath=players,
            property={player_num, 'key_right'}
        },
        menuengine:create_item{
            text='COLOR',
            subtype='COLORHUE',
            datapath=players,
            property={player_num, 'color'}
        },
        menuengine:create_item{
            text='REMOVE',
            subtype='ACTION',
            datapath=remove_player,
            options={player=player}
        }
    }
    menuengine:set_items(items)
    menuengine.info = nil
end

local function create_player_menuitem(player)
    local menuitem = menuengine:create_item{
        text=player.name,
        subtype='ACTION',
        datapath=set_player_options_menuitems,
        options={player=player},
        is_player=true -- needed to detect if text could be updated
    }
    return menuitem
end

local function add_player()
    local player = players:new()
    local menuitem = create_player_menuitem(player)
    -- insert before 'ADD PLAYER'
    table.insert(menuengine.items, #menuengine.items, menuitem)

    -- set menu active_index to new player
    for i, item in ipairs(menuengine.items) do
        if item.options then
            if item.options.player == player then
                menuengine.active_index = i
            end
        end
    end
end

local function set_players_menuitems()
    local items = {}
    for i, player in ipairs(players) do
        local menuitem = create_player_menuitem(player)
        table.insert(items, menuitem)
    end
    table.insert(
        items,
        menuengine:create_item{
            text='ADD PLAYER',
            subtype='ACTION',
            datapath=add_player})
    menuengine:set_items(items)
end

local function set_blockgroups(t)
    -- TODO: make blockgroups local variable
    blockgroups = t.blockgroups
    blocksequence.speed = t.blockgroups.speed
    start_game()
end

local function set_blockgroups_menuitems()
    local items = {}
    local files = love.filesystem.getDirectoryItems(BLOCKGROUPS_FOLDER)
    for i, file in ipairs(files) do
        local chunk = love.filesystem.load(BLOCKGROUPS_FOLDER..'/'..file)
        local result = chunk()
        local name = result.name or file
        local blockgroups_menuitem = menuengine:create_item{
            text=name,
            subtype='ACTION',
            datapath=set_blockgroups,
            options={blockgroups=result}
        }
        table.insert(items, blockgroups_menuitem)
    end
    menuengine:set_items(items)
    local save_directory = love.filesystem.getSaveDirectory()..'/'..BLOCKGROUPS_FOLDER
    menuengine.info = save_directory
end

-- TODO: make it local
root_items = {
    menuengine:create_item{
        text='START GAME',
        subtype='ACTION',
        datapath=set_blockgroups_menuitems},
    menuengine:create_item{
        text='PLAYERS',
        subtype='ACTION',
        datapath=set_players_menuitems},
    menuengine:create_item{
        text='OPTIONS',
        subtype='ACTION',
        datapath=set_options_menuitems}
}

return menu

require 'utils'
local game = require 'game'
local camera = require 'camera'
local players = require 'players'
local scene = require 'scene'
local blocksequence = require 'blocksequence'
local serialize = require 'lib/serialize'
require 'menu'

local SETTINGS_FILE = 'settings.lua'

function love.load()
    love.window.setTitle('SUPER POLYGON')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.keyboard.setKeyRepeat(true)
    font:create_or_update()

    -- default menu
    menu:set_items(root_items)

    if not load_settings() then
        -- default player
        players:new('Player 1', 'left', 'right', {1, 0, 1})
    end

end


function love.textinput(t)
    if menu.active then
        menu:edit_textinput(t)
    end
end


function love.update(dt)
    scene:update(dt)
    camera:update(dt)
    blocksequence:update(dt)
    players:update(dt)

    -- seconds timer
    if scene.base_time > 1 then
        camera.angle_timer = camera.angle_timer - 1
    end

    -- force console output
    io.flush()
end


function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    if menu.active then
        menu:draw()

    else
        love.graphics.translate(width/2, height/2)

        -- camera
        love.graphics.scale(window.scale)
        love.graphics.rotate(camera.angle)
        love.graphics.scale(camera.scale)

        -- background
        for segment=1,scene.segments do
            local colors = {}
            local r = scene.bg_colors.r
            local g = scene.bg_colors.g
            local b = scene.bg_colors.b

            if scene.segments % 2 == 0 then
                if segment % 2 == 0 then
                    if scene.bg_colors_switch then
                        colors = {r, g, b}
                    else
                        colors = {r*0.85, g*0.85, b*0.85}
                    end
                else
                    if scene.bg_colors_switch then
                        colors = {r*0.85, g*0.85, b*0.85}
                    else
                        colors = {r, g, b}
                    end
                end
            else
                local shift = nil
                if scene.bg_colors_switch then
                    if segment == scene.segments then
                        shift = 1
                    else
                        shift = segment + 1
                    end
                else
                    shift = segment
                end
                local range = scene.segments/shift
                colors = {r/range, g/range, b/range}
            end
            love.graphics.setColor(colors)
            local points = {}
            local angle = (360/scene.segments)*segment
            local slice = 360/scene.segments
            points = merge_tables(points, points_from_angle(40, angle))
            points = merge_tables(points, points_from_angle(40, angle+slice))
            points = merge_tables(points, points_from_angle(900, angle+slice))
            points = merge_tables(points, points_from_angle(900, angle))
            love.graphics.polygon('fill', points)
        end

        -- blocks
        love.graphics.setColor(1, 1, 1)
        for i, block in pairs(blocksequence.blocks) do
            block:draw()
        end

        -- circle
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle('line', 0, 0, 40, scene.segments)

        -- center
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle('line', -5, -5, 10, 10)

        -- player
        players:draw()

        -- text overlay
        love.graphics.reset()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font.game)
        local timer_text = 'TIMER: ' .. scene.seconds
        love.graphics.print(timer_text, 0, 0)
        local y = font.game:getHeight(timer_text)
        for i, p in ipairs(players) do
            love.graphics.setColor(p.color)
            local text = p.name .. ' - FAILURE ' .. p.failure
            love.graphics.print(text, 0, y)
            y = y + font.game:getHeight(text)
        end

        if game.state == 'END' then
            local info_font = font.title
            love.graphics.setFont(info_font)
            love.graphics.setColor{1.0, 0.7, 0.3}

            local text = 'PRESS ENTER TO RESTART'
            local text_width = info_font:getWidth(text)
            local text_height = info_font:getHeight(text)
            local x = width/2 - text_width/2
            local y = height - text_height*2
            love.graphics.print(text, x, y)

            local text = scene.seconds..' SECONDS'
            local text_width = info_font:getWidth(text)
            local text_height = info_font:getHeight(text)
            local x = width/2 - text_width/2
            love.graphics.print(text, x, text_height)
        end
    end
end


function love.keypressed(key)

    if key == 'f11' then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false, 'desktop')
            love.window.setMode(
                window.default_width, window.default_height, {resizable=true})
            love.resize(window.default_width, window.default_height)

        else
            love.window.setFullscreen(true, 'desktop')
        end
    end

    if key == 'return' then
        if game.state == 'END' and not menu.active then
            game:reset()
        end
    end

    if key == 'escape' then
        if menu.active then
            if not menu.wait_for_key then
                -- TODO: root_items should not be a global variable
                if menu.items == root_items then
                    love.event.quit()
                    save_settings()
                elseif menu.set_parent_items then
                    menu.set_parent_items()
                else
                    menu:set_items(root_items)
                    menu.info = nil
                end
            end
        else
            menu.active = true
        end
    end

    if menu.active then
        menu:keypressed(key)
    end
end


function love.resize(w, h)
    window.scale = w/window.default_width
    font:create_or_update()
end


function load_settings()
    local file = love.filesystem.getInfo(SETTINGS_FILE)
    if file then
        local chunk = love.filesystem.load(SETTINGS_FILE)
        settings = chunk()
        if settings.players then
            for i, player in ipairs(settings.players) do
                players:new(
                    player.name,
                    player.key_left,
                    player.key_right,
                    player.color)
            end
        end
        return true
    else
        return false
    end
end


function save_settings()
    local settings = {}
    settings.players = {}
    for i, p in ipairs(players) do
        local player = {
            name = p.name,
            key_left = p.key_left,
            key_right = p.key_right,
            color = p.color}
        table.insert(settings.players, player)
    end
    local settings_string = serialize.table_tostring(settings)
    love.filesystem.write(SETTINGS_FILE, 'return '..settings_string)
end


function game:start()
    for i, player in ipairs(players) do
        -- reset attributes
        player.failure = 0
    end

    self:reset()
end

function game:reset()
    scene.bg_colors = {
        r = random_float(0, 0.5),
        g = random_float(0, 0.5),
        b = random_float(0, 0.5)
    }

    -- reset attributes
    scene.base_time = 0
    scene.frame = 0
    scene.seconds = 0
    camera.angle = 0
    camera.scale = 1

    for i, player in ipairs(players) do
        player.angle = 360/(#players/i)
        player.collide = false
    end

    -- reset pattern
    blocksequence.blocks = {}
    -- first pattern
    local group, segments = get_random_group()
    blocksequence:add_group(group, segments)

    game.state = 'PLAY'
end

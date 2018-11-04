require 'player'
require 'utils'
require 'block'
require 'collision'
require 'game'
require 'menu'
scene = require 'scene'
camera = require 'camera'


function love.load()
    love.window.setTitle('SUPER POLYGON')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.keyboard.setKeyRepeat(true)
    font:create_or_update()

    -- default player
    players:new('Player 1', 'left', 'right', {1, 0, 1})

    -- default menu
    menu:set_items(root_items)

    -- settings
    --if not love.filesystem.getInfo('settings.txt') then
    --    love.filesystem.newFile('settings.txt')
    --end
end


function love.textinput(t)
    if menu.active then
        menu:edit_textinput(t)
    end
end


function love.update(dt)
    scene:update(dt)
    camera:update(dt)
    block_sequence:update(dt)
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
        for i, block in pairs(block_sequence.blocks) do
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
        love.graphics.print('TIMER: ' .. scene.seconds, 0, 0)
        local y = 20
        for i, p in ipairs(players) do
            local text = p.name .. ' - FAILURE ' .. p.failure
            love.graphics.print(text, 0, y)
            y = y + font.game:getHeight(text)
        end
    end
end


function love.keypressed(key)

    if key == 'f11' then
        if love.window.getFullscreen() then
            love.window.setFullscreen(false, 'desktop')
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
            -- TODO: root_items should not be a global variable, change to a module level
            if menu.items == root_items then
                love.event.quit()
            else
                menu:set_items(root_items)
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

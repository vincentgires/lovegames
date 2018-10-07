window = {
    default_width = 800,
    default_height = 600,
    scale = 1
}

font = {
    menu = nil,
    game = nil
}


function love.conf(t)
    t.window.width = window.default_width
    t.window.height = window.default_height
    t.window.resizable = true
    -- t.window.fullscreen = true
    -- t.window.fullscreentype = 'exclusive'
end

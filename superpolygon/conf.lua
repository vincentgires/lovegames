-- TODO: make it local variable
window = {
    default_width = 800,
    default_height = 600,
    scale = 1
}

-- TODO: make it local variable
font = {
    menu = nil,
    game = nil
}

function font:create_or_update()
    self.title = love.graphics.newFont(
        'fonts/VCR_OSD_MONO.ttf', 35*window.scale)
    self.menu_items = love.graphics.newFont(
        'fonts/VCR_OSD_MONO.ttf', 25*window.scale)
    self.menu_info = love.graphics.newFont(
        'fonts/VCR_OSD_MONO.ttf', 16*window.scale)
    self.game = love.graphics.newFont(
        'fonts/VCR_OSD_MONO.ttf', 16*window.scale)
end

function love.conf(t)
    t.window.width = window.default_width
    t.window.height = window.default_height
    t.window.resizable = true
end

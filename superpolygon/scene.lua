local game = require 'game'
local camera = require 'camera'
local utils = require 'utils'

local scene = {
    segments = 5,
    base_time = 0,
    seconds = 0,
    frame = 0,
    bg_colors = {
        r = utils.random_float(0, 0.5),
        g = utils.random_float(0, 0.5),
        b = utils.random_float(0, 0.5)
    },
    bg_colors_switch = false
}

function scene:update(dt)
    self.frame = self.frame + 1
    if game.state == 'PLAY' then
        self.base_time = self.base_time + dt
        if self.base_time > 1 then
            self.base_time = self.base_time - 1
            self.seconds = self.seconds + 1
            camera.angle_timer = camera.angle_timer - 1
            if game.scene.swap_bg_colors then
                self.bg_colors_switch = not self.bg_colors_switch
            end
        end
    end
end

return scene

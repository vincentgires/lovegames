local scene = {
    segments = 5,
    base_time = 0,
    seconds = 0,
    frame = 0,
    -- bg_colors = {
    --     r = 0.5,
    --     g = 0.5,
    --     b = 0.5
    -- }
    bg_colors = {
        r = random_float(0, 0.5),
        g = random_float(0, 0.5),
        b = random_float(0, 0.5)
    },
    bg_colors_switch = false
}


function scene:update(dt)
    self.frame = self.frame + 1

    self.base_time = self.base_time + dt
    if scene.base_time > 1 then
        self.base_time = self.base_time - 1
        self.seconds = self.seconds + 1
        camera.angle_timer = camera.angle_timer - 1
        self.bg_colors_switch = not self.bg_colors_switch
    end

end


return scene

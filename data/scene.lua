local scene = {
    segments = 5,
    base_time = 0,
    seconds = 0,
    speed = 5,
    frame = 0
}

function scene:update(dt)
    self.frame = self.frame + 1
    
    self.base_time = self.base_time + dt
    if scene.base_time > 1 then
        self.base_time = self.base_time - 1
        self.seconds = self.seconds + 1
        camera.angle_timer = camera.angle_timer - 1
    end
    
end

return scene

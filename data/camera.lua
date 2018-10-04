local camera = {
    speed = 2,
    angle = 0,
    angle_timer = math.random(1,10),
    shake_timer = 1/4,
    shake_base_time = 0,
    scale = 1
}


function camera:update(dt)
    -- camera scale
    if game.camera.shake then
        self.shake_base_time = self.shake_base_time + dt
        if self.shake_base_time > self.shake_timer then
            self.shake_base_time = self.shake_base_time - self.shake_timer
            -- self.scale = random_float(0.9, 1.1)
            if self.scale <= 1.1 then
                self.scale = self.scale + 0.05
            else
                self.scale = 1
            end
        end
    end

    -- change direction and reset timer
    if self.angle_timer <= 0 then
        self.angle_timer = math.random(1,10)
        self.speed = self.speed * -1
    end

    if game.camera.rotation then
        self.angle = self.angle + dt * self.speed
    end
end

return camera

function circle_points(radius)
    local points = {}
    local x, y, r = 0, 0, radius
    
    for i = 1, 360, 360/segments do
        local angle = i * math.pi / 180
        local ptx, pty = x + r * math.cos(angle), y + r * math.sin(angle)
        table.insert(points, {ptx, pty})
    end
    
    return points
end

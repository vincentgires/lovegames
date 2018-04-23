function merge_tables(t1, t2)
   for k, v in pairs(t2) do
      table.insert(t1, v)
   end 
   return t1
end

function table_length(t)
    local cpt = 0
    for k, v in pairs(t) do
        cpt = cpt + 1
    end
    return cpt
end


function circle_points(radius)
    local points = {}
    local x, y, r = 0, 0, radius
    
    for i=1, 360, 360/scene.segments do
        local angle = i * math.pi / 180
        local ptx = x + r * math.cos(angle)
        local pty = y + r * math.sin(angle)
        table.insert(points, {ptx, pty})
    end
    
    return points
end

function points_from_angle(radius, angle)
    local points = {}
    local x, y, r = 0, 0, radius
    local angle = angle * math.pi / 180
    local ptx = x + r * math.cos(angle)
    local pty = y + r * math.sin(angle)
    table.insert(points, ptx)
    table.insert(points, pty)
    return points
end


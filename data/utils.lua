function merge_tables(t1, t2)
   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end 
   return t1
end

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

function points_from_angle(radius, angle)
    local points = {}
    local x, y, r = 0, 0, radius
    local angle = angle * math.pi / 180
    local ptx = x + r * math.cos(angle)
    local pty = y + r * math.sin(angle)
    table.insert(points, {ptx, pty})
    return points
end


function block_points()
    local points = {}
    
    points = merge_tables(points, points_from_angle(100, 90))
    points = merge_tables(points, points_from_angle(120, 90))
    points = merge_tables(points, points_from_angle(100, 40))
    points = merge_tables(points, points_from_angle(120, 40))
    
    return points
end

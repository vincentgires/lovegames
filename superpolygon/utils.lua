function merge_tables(t1, t2)
   for k, v in pairs(t2) do
      table.insert(t1, v)
   end
   return t1
end


function random_float(lower, greater)
    return lower + love.math.random() * (greater - lower)
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

function rgb_to_hsv(r, g, b)
    local maxc = math.max(r, g, b)
    local minc = math.min(r, g, b)
    local v = maxc
    if minc == maxc then
        return 0.0, 0.0, v
    end
    local s = (maxc-minc) / maxc
    local rc = (maxc-r) / (maxc-minc)
    local gc = (maxc-g) / (maxc-minc)
    local bc = (maxc-b) / (maxc-minc)
    local h
    if r == maxc then
        h = bc-gc
    elseif g == maxc then
        h = 2.0+rc-bc
    else
        h = 4.0+gc-rc
    end
    h = (h/6.0) % 1.0
    return h, s, v
end

function hsv_to_rgb(h, s, v)
    if s == 0.0 then
        return v, v, v end
    local i = math.floor(h*6.0)
    local f = (h*6.0) - i
    local p = v*(1.0 - s)
    local q = v*(1.0 - s*f)
    local t = v*(1.0 - s*(1.0-f))
    i = i%6
    if i == 0 then
        return v, t, p end
    if i == 1 then
        return q, v, p end
    if i == 2 then
        return p, v, t end
    if i == 3 then
        return p, q, v end
    if i == 4 then
        return t, p, v end
    if i == 5 then
        return v, p, q end
end

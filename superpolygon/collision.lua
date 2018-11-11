-- Usefull collision detection algorithms : https://2dengine.com/?p=intersections

local collision = {}

function collision.segment_vs_segment(x1, y1, x2, y2, x3, y3, x4, y4)
    local dx1, dy1 = x2 - x1, y2 - y1
    local dx2, dy2 = x4 - x3, y4 - y3
    local dx3, dy3 = x1 - x3, y1 - y3
    local d = dx1*dy2 - dy1*dx2

    if d == 0 then
        return false
    end

    local t1 = (dx2*dy3 - dy2*dx3)/d
    if t1 < 0 or t1 > 1 then
        return false
    end

    local t2 = (dx1*dy3 - dy1*dx3)/d
    if t2 < 0 or t2 > 1 then
        return false
    end

    return true, x1 + t1*dx1, y1 + t1*dy1
end

function collision.point_in_circle(px, py, cx, cy, r)
  local dx, dy = px - cx, py - cy
  return dx*dx + dy*dy <= r*r
end

return collision

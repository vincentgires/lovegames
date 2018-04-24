function segment_vs_segment(x1, y1, x2, y2, x3, y3, x4, y4)
    -- https://2dengine.com/?p=intersections
    
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
    
    -- point of intersection
    return true, x1 + t1*dx1, y1 + t1*dy1
end

function check_collision()
    for player_num, player in pairs(players) do
        if player.points then
            for i=1,3,2 do
                -- front player shape /\
                local px1 = player.points[i]
                local px2 = player.points[i+1]
                local py1 = player.points[i+2]
                local py2 = player.points[i+3]
                
                for l, block in pairs(blocks) do
                    if block.points then
                        
                        -- bottom of the block \->_____<-/
                        local bx1 = block.points[1]
                        local bx2 = block.points[2]
                        local by1 = block.points[3]
                        local by2 = block.points[4]
                        
                        local collide, x, y = segment_vs_segment(
                            px1, px2, py1, py2, bx1, bx2, by1, by2)
                        
                        if collide then
                            print(px1, px2, py1, py2)
                            table.insert(block.collided_players, player_num)
                            player.failure = player.failure + 1
                            return true, x, y
                        end
                    end
                end
            end
        end
    end
end

-- Usefull collision detection algorithms : https://2dengine.com/?p=intersections

function segment_vs_segment(x1, y1, x2, y2, x3, y3, x4, y4)
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


function point_in_circle(px, py, cx, cy, r)
  local dx, dy = px - cx, py - cy
  return dx*dx + dy*dy <= r*r
end


function check_block_collision()
    for player_num, player in ipairs(players) do
        if player.points then
            for i=1,3,2 do
                --[[ front player shape /\ ]]
                local px1 = player.points[i]
                local px2 = player.points[i+1]
                local py1 = player.points[i+2]
                local py2 = player.points[i+3]

                for _, block in pairs(block_sequence.blocks) do
                    -- if block.points then
                    -- if block.points and not has_value(block.collided_players, player_num) then
                    if block.points and not block.collided_players[player_num] then
                        --[[ bottom of the block \->_____<-/ ]]
                        local bx1 = block.points[1]
                        local bx2 = block.points[2]
                        local by1 = block.points[3]
                        local by2 = block.points[4]
                        local collide, x, y = segment_vs_segment(
                            px1, px2, py1, py2, bx1, bx2, by1, by2)
                        if collide then
                            table.insert(block.collided_players, player_num)
                            player.failure = player.failure + 1
                            -- TODO: ne peut pas retuner true ! sinon pas de collision sur le prochain player
                            -- faire que la fonction prenne plutot un player en parametre: check_block_collision(player)
                            return true, x, y
                        end
                    end
                end
            end
        end
    end
end

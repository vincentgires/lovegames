local serialize = {}

local function table_length(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function serialize.table_tostring(t)
    local result = '{'
    local count = 1
    for k, v in pairs(t) do
        local valid = true
        -- Check key type
        if type(v) ~= 'function' then
            if type(k) == 'string' then
                result = result..k..'='
            end
        end
        -- Check value type
        if type(v) == 'table' then
            result = result..serialize.table_tostring(v)
        elseif type(v) == 'boolean' then
            result = result..tostring(v)
        elseif type(v) == 'number' then
            result = result..v
        elseif type(v) == 'string' then
            result = result..string.format('%q', v)
        else
            valid = false
        end
        if valid and count ~= table_length(t) then
            result = result..','
        end
        count = count + 1
    end
    return result..'}'
end

function serialize.print_table(t)
    print(serialize.table_tostring(t))
end

return serialize

--[[
local test_table = {a='aa', 1,2,3,'ss4','ss5', b=false, t={1,2,{c='cc'}}}
local serialized = serialize.table_tostring(test_table)
print(serialized)
]]

function table.tostring(t)
    local result = '{'
    for k, v in pairs(t) do
        -- Check key type
        if type(k) == 'string' then
            result = result..k..'='
        end
        -- Check value type
        if type(v) == 'table' then
            result = result..table.tostring(v)
        elseif type(v) == 'boolean' then
            result = result..tostring(v)
        elseif type(v) == 'number' then
            result = result..v
        elseif type(v) == 'string' then
            result = result..string.format('%q', v)
        else
            error('Invalid value: '..tostring(v))
        end
        result = result..','
    end
    -- Remove leading commas from the result
    if result ~= '' then
        result = result:sub(1, #result-1)
    end
    return result..'}'
end

--[[
local test_table = {a='aa', 1,2,3,'ss4','ss5', b=false, t={1,2,{c='cc'}}}
local serialized = table.tostring(test_table)
print(serialized)
]]

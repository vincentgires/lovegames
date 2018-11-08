function table.tostring(t)
    local result = '{'
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
            result = result..table.tostring(v)
        elseif type(v) == 'boolean' then
            result = result..tostring(v)
        elseif type(v) == 'number' then
            result = result..v
        elseif type(v) == 'string' then
            result = result..string.format('%q', v)
        else
            valid = false
        end
        -- TODO: don't add comma at the end an array
        if valid then
            result = result..','
        end
    end
    return result..'}'
end

--[[
local test_table = {a='aa', 1,2,3,'ss4','ss5', b=false, t={1,2,{c='cc'}}}
local serialized = table.tostring(test_table)
print(serialized)
]]
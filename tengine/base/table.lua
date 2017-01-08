--[[
	table
]]

local string_format = string.format
local pairs = pairs

local ok, table_new = pcall(require, "table.new")
if not ok or type(table_new) ~= "function" then
    function table:new()
        return {}
    end
end

local _copy
_copy = function(t, lookup)
    if type(t) ~= "table" then
        return t
    elseif lookup[t] then
        return lookup[t]
    end
    local n = {}
    lookup[t] = n
    for key, value in pairs(t) do
        n[_copy(key, lookup)] = _copy(value, lookup)
    end
    return n
end

function table.copy(t)
    local lookup = {}
    return _copy(t, lookup)
end

function table.keys(hashtable)
    local keys = {}
    for k, v in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(hashtable)
    local values = {}
    for k, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.map(t, fn)
    local n = {}
    for k, v in pairs(t) do
        n[k] = fn(v, k)
    end
    return n
end

function table.walk(t, fn)
    for k,v in pairs(t) do
        fn(v, k)
    end
end

function table.filter(t, fn)
    local n = {}
    for k, v in pairs(t) do
        if fn(v, k) then
            n[k] = v
        end
    end
    return n
end

function table.length(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

function table.readonly(t, name)
    name = name or "table"
    setmetatable(t, {
        __newindex = function()
            error(string_format("<%s:%s> is readonly table", name, tostring(t)))
        end,
        __index = function(_, key)
            error(string_format("<%s:%s> not found key: %s", name, tostring(t), key))
        end
    })
    return t
end


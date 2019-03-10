
map = {}
--创建地图
function createMap(raw, col, mul)
    local raw = raw or 6
    local col = col or 6
    local count = 1
    local size = raw * col
    for i = 1, raw do 
        map[i] = {}
        for j = 1, col do 
            if count == size / mul + 1
            then
             count = 1
            end    
            map[i][j] = count
            count = count + 1
        end
        --if i == raw / 2 
        
    end
end

--随机打乱
function randomMap(times)
    math.randomseed(os.time())
    local times = times or 100
    for i = 1, times do 
    local a = math.random( 1, #map )
    local b = math.random( 1, #map[1] )
    local c = math.random( 1, #map )
    local d = math.random( 1, #map[1] )
    map[a][b], map[c][d] = map[c][d], map[a][b]
    end
end

function printMap()
    io.write("\n")
    --io.write("    ",string.rep( "-", 4 * (#map[1] + 1) ),"\n")
    local s = {};
    io.write(string.rep( " ", 5 ))
    for i = 1, #map[1] do
        io.write(string.format( " %2d  ", i))
    end
    io.write("\n")
    for i in ipairs(map) do 
        s[i] = {}
        io.write(string.rep( " ", 5 ),string.rep( "-", 5 * (#map[1] - 1) ),"----\n")
        io.write(string.format( " %2d |", i))
        for j in ipairs(map[i]) do
            if map[i][j] == 0 then s[i][j] = string.rep( " ", 3 )
            else s[i][j] = string.format( "%3d",map[i][j] )
            end
        end
        io.write(table.concat( s[i], " |" )," |\n")
    end
    io.write(string.rep( " ", 5 ),string.rep( "-", 5 * (#map[1] - 1) ),"----\n")
    io.write("\n")
end

local function c2c(araw, acol, braw, bcol)
    local deta = (acol > bcol) and - 1 or  1
    local gap = 0
    repeat 
        gap = gap + deta
        if acol + gap == bcol then 
            return true
        end
    until map[araw][acol + gap] ~= 0
    return false
end

local function r2r(araw, acol, braw, bcol)
    local deta = (araw > braw) and - 1 or  1
    local gap = 0
    repeat 
        gap = gap + deta
        if araw + gap == braw then  
            return true
        end
    until map[araw + gap][acol] ~= 0
    return false
end

local function c2c0(araw, acol, braw, bcol)
    return map[braw][bcol] == 0 and c2c(araw, acol, braw, bcol)
end

local function r2r0(araw, acol, braw, bcol)
    return map[braw][bcol] == 0 and r2r(araw, acol, braw, bcol)
end

--判断可连 可连返回true，不可返回false
local function matchMap(araw, acol, braw, bcol)
    --同一位置直接返回
    if araw == braw and acol == bcol  then return false end
    --不相等直接返回
    if map[araw][acol] ~= map[braw][bcol] then return false end
    --为0直接返回
    if map[araw][acol] == 0 then return false end
    --同排相邻
    if araw == braw  then
        if(c2c(araw, acol, braw, bcol)) then showcase("||") return true end
    --同行相邻
    elseif(acol == bcol) then 
        if(r2r(araw, acol, braw, bcol)) then showcase("||") return true end
    end
    
    --一个拐角
    if c2c0(araw, acol, araw, bcol) 
        and r2r(araw, bcol, braw, bcol)
        or  r2r0(araw, acol, braw, acol) 
        and c2c(braw, acol, braw, bcol) then showcase("|_")
        return true
    end

    --越界拐角
    if (acol == #map[1] or c2c0(araw, acol, araw, #map[1])) 
        and (bcol == #map[1] or c2c0(braw, bcol, braw, #map[1])) 
    or (acol == 1 or c2c0(araw, acol, araw, 1))
        and (bcol == 1 or c2c0(braw, bcol, braw, 1)) 
    or (araw == 1 or r2r0(araw, acol, 1, acol)) 
        and (braw == 1 or r2r0(braw, bcol, 1, bcol))
    or (araw == #map or r2r0(araw, acol, #map, acol)) 
        and (braw == #map or r2r0(braw, bcol, #map, bcol)) 
        then 
            showcase("__||--")
        return true
    end

    --竖连接线
    for i = 1, #map[1] do
        if c2c0(araw, acol, araw, i) and c2c(braw, bcol, braw, i) and r2r0(araw, i, braw, i) then 
            showcase("_|-")
            return true
        end
    end

    --横连接线
    for i = 1, #map do
        if r2r0(araw, acol, i, acol) and r2r(braw, bcol, i, b) and c2c0(i, acol, i, bcol) then
            showcase("|-|")
            return true
        end
    end

    return false
end

--连成功，返回被消去的值，失败返回0
function updateMap(araw, acol, braw, bcol)
    if matchMap(araw, acol, braw, bcol) then
        showcase("kill " .. map[braw][bcol] .. "!")
        local result = map[braw][bcol];
        map[araw][acol], map[braw][bcol] = 0,0
        return result
    else
        showcase("fail!")
        return 0
    end
end

function showcase(a)
    io.write(a,"\n")
end

function MapIO()
    io.write("first number raw:")
    a = io.read("*number")
    io.write("\nfirst number col:")
    b = io.read("*number")
    io.write("\nsecond number raw:")
    c = io.read("*number")
    io.write("\nsecond number col:")
    d = io.read("*number")
    io.write("\n")
    updateMap(a, b, c, d)
    printMap()
end

function overMap()
    for i in ipairs(map) do 
        for j in ipairs(map[i]) do
            if map[i][j] ~= 0 then return false end
        end
    end
    return true
end
--[[
io.write("raw:")
a = io.read("*number")
io.write("col:")
b = io.read("*number")

createMap(a, b)

randomMap()
printMap()
while not overMap() do
    MapIO()
end
showcase("congratulations!")]]

local function printTable( t )
 
    local printTable_cache = {}
 
    local function sub_printTable( t, indent )
 
        if ( printTable_cache[tostring(t)] ) then
            print( indent .. "*" .. tostring(t) )
        else
            printTable_cache[tostring(t)] = true
            if ( type( t ) == "table" ) then
                for pos,val in pairs( t ) do
                    if ( type(val) == "table" ) then
                        print( indent .. "[" .. pos .. "] => " .. tostring( t ).. " {" )
                        sub_printTable( val, indent .. string.rep( " ", string.len(pos)+8 ) )
                        print( indent .. string.rep( " ", string.len(pos)+6 ) .. "}" )
                    elseif ( type(val) == "string" ) then
                        print( indent .. "[" .. pos .. '] => "' .. val .. '"' )
                    else
                        print( indent .. "[" .. pos .. "] => " .. tostring(val) )
                    end
                end
            else
                print( indent..tostring(t) )
            end
        end
    end
 
    if ( type(t) == "table" ) then
        print( tostring(t) .. " {" )
        sub_printTable( t, "  " )
        print( "}" )
    else
        sub_printTable( t, "  " )
    end
end



normalcommands = {
    ['/arm'] =      function(x) end,
    ['/car'] =      function(x) end,
    ['/cash'] =     function(x) end,
    ['/help'] =     function(x) help() end,
    ['/lowgrav'] =  function(x) lowgrav         (1250) end,
    ['/kill'] =     function(x) killplayer      (25000) end,
    ['/strong'] =   function(x) strong          (1250) end,
    ['/bs'] =       function(x) botSwarm        (250) end,
    
}

admincommands = {
    ['/arm'] =      function(x) end,
    ['/car'] =      function(x) end,
    ['/cash'] =     function(x) end,
    ['/r'] =        function(x) flagStateForReset(""); dofile("main/commands.lua");timemultiply=1 end,
    ['/d'] =        function(x) timemultiply= timemultiply+1 end,
    ['/timer'] =    function(x) timer() end,
    ['/help'] =     function(x) help() end,
    ['/time'] =     function(x) timeset         (0) end,
    ['/grav'] =     function(x) gravchange      (0) end,
    ['/lowgrav'] =  function(x) lowgrav         (0) end,
    ['/kill'] =     function(x) killplayer      (0) end,
    ['/give'] =     function(x) give            (0) end,
    ['/strong'] =   function(x) strong          (0) end,
    ['/bodyswap'] = function(x) bodyswapToggle  (0) end,
    ['/bs'] =       function(x) botSwarm        (0) end,
    
}



function bodyswapToggle(cash)
    if buy(cash) then
        bodswap = bodswap ~= true
        --[[
        if (bodswap ~= true) then 
            bodswap = true
            print("BodySwap is Active")
        else 
            bodswap = false
            print("BodySwap is Inactive")
        end
        ]]
    end
end

function botSwarm(cash)
    if buy(cash) then
        local player = player.human
        local rb = player:getRigidBody(0)

        for i=1,10 do 
            players.createBot()
            
        end

        for i=0,10 do 
            local b = players[i]
            if (b.isBot == true) then
                b.name = "jon"
                humans.create(rb.pos, rb.rot, b)
            end
        end
    end
end

function give(cash)
    local input = cmd[#cmd-1]
    local command = cmd[2]
    cmd[#cmd] = string.gsub(cmd[#cmd],' '..input,'')
    cmd[#cmd] = string.gsub(cmd[#cmd],cmd[2]..' ','')

    for i=0,players.getCount() do 
        p = players[i]
        if p.name == cmd[#cmd] then

            if command == 'cash' then
                p.money = p.money+input
                p:updateFinance()
            end



        end
    end
end

function gravchange(cash)
    if buy(cash) then
        if (cmd[2] ~= "/grav") then
            server.gravity = tonumber(cmd[2])/10000
        else
            server.gravity = server.defaultGravity
        end
    end
end

function help()
    player:sendMessage("/lowgrav - moon gravity")
    player:sendMessage("/strong - multiplies the mass of the player by 10 (can stack)")
    player:sendMessage("/kill X - kills the player with the given name")
    player:sendMessage("/bs - summons a small mob of bots")
    player:sendMessage("")
    player:sendMessage("")
    player:sendMessage("")
    player:sendMessage("")
    player:sendMessage("")
    player:sendMessage("")
end

function killplayer(cash)
    if buy(cash) then
        for i=0,players.getCount() do 
            p = players[i]
            if p.name == cmd[#cmd] then
                p = p.human
                p.isAlive = false
            end
        end
    end
end

function lowgrav(cash)
    if buy(cash) then
        server.gravity = -.00001
    end
    busyWait('server.gravity = server.defaultGravity',5)
end

function resumeTimeinRange(range,x,y,z)
    local pos = Vector(x,y,z)
    local data = bodiesInRange(pos,range)
    for i,set in ipairs(data) do
        local h = data[i][1]
        for i=0,15 do
            local rg = h:getRigidBody(i)
            rg.isActive = true
        end
    end
end

function stopTimeinRange(range,pos)
    local x,y,z = extractNumbers(pos)
    local data = bodiesInRange(pos,range)
    for i,set in ipairs(data) do
        local h = data[i][1]
        for i=0,15 do
            local rg = h:getRigidBody(i)
            rg.isActive = false
        end
    end
    local temp = 'resumeTimeinRange('..range..','..x..','..y..','..z..')'
    busyWait(temp,5)
end

function strong(cash)
    if buy(cash) then
        local p = player.human
        for i=0,15 do
            local h = p:getRigidBody(i)
            h.mass = h.mass *10
        end
    end
end

function swapPlayerBodies(shooter,victim)
    print(players[0].human,humans[1])

    local buffer = players[0]

    players[0].human = humans[1]
    player:update()

end

function timer()
    busyWait("print('ding ding ding')",5)
end

function timeset(cash)
    server.time = tonumber(cmd[2])*60
end





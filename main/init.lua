time = 0
bodswap = false
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

function hook.run(name, ...)
    -- runs the update file (for per-tick updates)
    dofile("main/updatestuff.lua")
    -- adds 1 to the server time (not game time)
    time = time+1

    if(name == "EventUpdatePlayer") then
      player = ...

    -- checks for player chats
    elseif(name == "PlayerChat") then
        player, message = ...
        
        -- checks if chat is a command
        if string.match(message,"/")then
            cmd = {message}
            temp = 1
            for i in string.gmatch(message, "%S+") do
                table.insert(cmd,temp,i)
                temp = temp + 1
            end

            -- command list
            local commands = {
                ['/r'] = function(x) flagStateForReset("") end,
                ['/d'] = function(x) print(cmd[2]) end,
                ['/time'] = function(x) server.time = tonumber(cmd[2]) end,
                ['/grav'] = function(x) server.gravity = tonumber(cmd[2])/10000 end,
                ['/kill'] = function(x) dofile("main/killplayer.lua") end,
                ['/strong'] = function(x) dofile("main/strong.lua") end,
                ['/bodswap'] = function(x) dofile("main/bodyswap.lua") end,
                ['/botswarm'] = function(x) dofile("main/botswarm.lua") end,
            }
            commands[cmd[1]](cmd[1])

        -- otherwise will print the message in console
        else
            print(player.name .. ": " .. message)
        end
    
    -- checks if player has joined/left
    elseif(name == "PostPlayerCreate")then
        player = ...
        stime = time
        joinwait = true
    elseif(name == "PostPlayerDelete")then
        player = ...
        print(player.name,"Left")
    elseif(name == "EventBulletHit") then
        poop = bullets[1]
        print(poop.player)
        if (bodyswap == true)then
            type,rot,play = ...
            print(vector,rot,play)
        end
    end
  end
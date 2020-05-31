servertime = 0
bodswap = true

busyWaitTimes = {}

dofile("main/commands.lua")

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

function extractNumbers(values)
    local values = tostring(values)
    values = string.gsub(values,"%a","")
    values = string.gsub(values,"%)","")
    values = string.gsub(values,"%(","")
    values = string.gsub(values,",","")

    valuelist = {}

    for i in string.gmatch(values, "%S+") do
        table.insert(valuelist,tonumber(i))
    end
    return unpack(valuelist)
end

function get3Ddistance(x1,y1,z1,x2,y2,z2)
    local xDif,yDif,zDif,distance

    xDif = math.abs(x2-x1)
    yDif = math.abs(y2-y1)
    zDif = math.abs(z2-z1)

    xDif = math.pow(xDif,2)
    yDif = math.pow(yDif,2)
    zDif = math.pow(zDif,2)

    distance = math.sqrt(xDif+yDif+zDif)

    return(distance)
end

function bodiesInRange(position,range)
    local x2,y2,z2,x1,y1,z1
    local human, humanpos
    local distance, datalist

    x1,y1,z1 = extractNumbers(position)

    datalist = {}

    for i=0,humans.getCount()-1 do

        human = humans[i]
        humanpos = human:getPos()

        x2,y2,z2 = extractNumbers(humanpos)

        distance = get3Ddistance(x1,y1,z1,x2,y2,z2)
        if (distance < range) then
            table.insert(datalist,{human,distance})
        end
    end
    return datalist
end

function bodyClosestTo(position)
    local x2,y2,z2,x1,y1,z1
    local human, humanpos, tempHuman
    local distance, tempDistance, data, set

    tempDistance = 99999

    data = bodiesInRange(position,2)
    
    for i,set in ipairs(data) do
        human = data[i][1]
        if ((data[i][2] < tempDistance) and human.isActive == true) then
            tempDistance = data[i][2]
            tempHuman = data[i][1]
        end
    end
    return tempHuman,tempDistance
    
end

function bulletAtPos(position)
    local bx,by,bz
    local bullet, bulletpos, tempBullet, tempbDistance, bdistance
    local x1,y1,z1 = extractNumbers(position)
    tempbDistance = 99999

    for i=0,bullets.getCount()-1 do
        bullet = bullets[i]
        bulletpos = bullet.pos
        bx,by,bz = extractNumbers(bulletpos)
        bdistance = get3Ddistance(x1,y1,z1,bx,by,bz)
        
        if (bdistance < tempbDistance) then
            tempbDistance = bdistance
            tempBullet = bullet
        end


        --print("bullet",distance)
    end
    return tempBullet
end

function busyWait(command,time2execute)

    table.insert(busyWaitTimes,{stimeInSeconds-time2execute,command})

end

function buy(amount)
    if (player.money >= amount) then
        player.money = player.money - amount
        return true
    else
        player:sendMessage('Not enough money, requires: '..amount)
        return false
    end
end

--[[

.__                      __                               
|  |__    ____    ____  |  | __    _______  __ __   ____  
|  |  \  /  _ \  /  _ \ |  |/ /    \_  __ \|  |  \ /    \ 
|   Y  \(  <_> )(  <_> )|    <      |  | \/|  |  /|   |  \
|___|  / \____/  \____/ |__|_ \ /\  |__|   |____/ |___|  /


]]

function hook.run(name, ...)

    if (servertime ~= server.time) then
        -- runs the update file (for per-tick updates)
        dofile("main/updatestuff.lua")
        -- adds 1 to the server time (not game time)
        servertime = server.time
        stimeInSeconds = tonumber(string.format("%.1f",tostring(servertime/60)))
    end



    if(name == "EventUpdatePlayer") then
      player = ...

    -- checks for player chats
    elseif(name == "PlayerChat") then
        player, message = ...
        player.menuTab = 15
        -- checks if chat is a command
        if string.match(message,"/")then
            cmd = {message}
            temp = 1
            for i in string.gmatch(message, "%S+") do
                table.insert(cmd,temp,i)
                temp = temp + 1
            end
            
            cmd[#cmd] = string.gsub(cmd[#cmd],cmd[1]..' ','')

            if player.isAdmin == true then
                admincommands[cmd[1]](1)
            else
                normalcommands[cmd[1]](1)
            end

            print(player.name .. " issued command: ".. cmd[1])

        -- otherwise will print the message in console
        else
            print(player.name .. ": " .. message)
        end
    
    -- checks if player has joined/left
    elseif(name == "PostPlayerCreate")then
        player = ...
        stime = servertime
        joinwait = true
    elseif(name == "PostPlayerDelete")then
        player = ...
        print(player.name,"Left")
    elseif(name == "EventBulletHit") then
        btype,pos,normal = ...

        --event.explosion(pos)

        if ((bodswap == true)and (btype == 1))then
            --stopTimeinRange(3,pos)
            local tempplayer,tempbullet = bodyClosestTo(pos),bulletAtPos(pos)
            --swapPlayerBodies(tempbullet.player,tempplayer.player)

        end
    elseif(name=="GrenadeExplode") then
        gernadeItem = ...
        
        print(gernadeItem.parentItem)

        busyWait('stopTimeinRange(5,gernadeItem.pos)',.1)
        
    end
  end
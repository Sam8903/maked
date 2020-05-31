--print(stimeInSeconds) --seconds
--print(cmd[#cmd-1])

-- player joined

if (joinwait == true)then
    if (servertime > stime+400)then
        p = player.connection
        print(player.name, "joined from ".. p.address..":"..p.port)
        joinwait = false
        player:sendMessage("----- Welcome to Googer's Sexy Server -----")
        player:sendMessage("This is really just a playground for me to")
        player:sendMessage("test with the inner-mechanics of Sub Rosa")
        player:sendMessage(" ")
        player:sendMessage("----- Getting Started -----")
        player:sendMessage("I do have a few commands set up")
        player:sendMessage("so if you want to mess around with them")
        player:sendMessage("just type '/help'") 
        player:sendMessage("")
        player:sendMessage("P.S. expect crashes")
    end
end

if (busyWaitTimes[1] ~= nil) then
    if (stimeInSeconds < busyWaitTimes[1][1]) then
        timend=loadstring(busyWaitTimes[1][2])
        timend()
        table.remove(busyWaitTimes, 1 )
    end
end
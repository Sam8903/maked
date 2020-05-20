-- player joined

if (joinwait == true)then
    if (time >= stime+10)then
        p = player.connection
        print(player.name,"joined from ".. p.address..":"..p.port)
        joinwait = false
    end
end

--[[
if (botwait == true)then
    if (time >= bottime+1000)then
        for i=0,16 do 
            b = players[i]
            if (b.isBot == true) then
                h = b.human
                h:remove()
            end
        end
        
    end
end
botwait = false
--]] 
for i=0,players.getCount() do 
    p = players[i]
    if p.name == cmd[2] then
        p = p.human
        p.isAlive = false
    end
end
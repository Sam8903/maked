p = player.human
rb = p:getRigidBody(0)

for i=1,10 do 
    players.createBot()
    
end

for i=0,10 do 
    b = players[i]
    if (b.isBot == true) then
        b.name = "jon"
        humans.create(rb.pos, rb.rot, b)
    end
end
bottime = 0
botwait = true
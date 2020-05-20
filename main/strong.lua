local p = player.human
for i=0,15 do
    local h = p:getRigidBody(i)
    h.mass = h.mass *1000
end
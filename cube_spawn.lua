
function sysCall_init()
    corout=coroutine.create(coroutineMain)
end

function sysCall_actuation()
    if coroutine.status(corout)~='dead' then
        local ok,errorMsg=coroutine.resume(corout)
        if errorMsg then
            error(debug.traceback(corout,errorMsg),2)
        end
    end
end

function sysCall_cleanup()
    -- do some clean-up here
end



function coroutineMain()
    -- Put some initialization code here
    apple_cube=sim.getObjectHandle('Cuboid_Apple')
    banana_cube=sim.getObjectHandle('Cuboid_Banana')
    
    --sim.getObjectOrientation(
    local tblPos={0.9, 0.8, 0.3}
    
    while true do
        rnd=sim.getRandom(nil)
        if rnd>0.5 then
            cube_copy=sim.copyPasteObjects({apple_cube},0)

        else
            cube_copy=sim.copyPasteObjects({banana_cube},0)
            
        end
        sim.wait(10)
        sim.setObjectPosition(cube_copy[1],-1,tblPos)
        sim.setObjectOrientation(cube_copy[1],1,{0,0,0})
        
    end

end

-- See the user manual or the available code snippets for additional callback functions and details

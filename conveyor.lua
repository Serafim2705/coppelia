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

    handle=sim.getObjectHandle('Proximity_sensor')
    print(handle)
    
    Proximity_sensor = sim.getObjectHandle("Proximity_sensor")
    conveyorSystem = sim.getObjectHandle("conveyor")

    while true do
        result, PSensor_distance,detectedPoint,detectedObjectHandle= sim.readProximitySensor(Proximity_sensor)
        if result > 0 then
            sim.writeCustomTableData(conveyorSystem,'__ctrl__',{vel=0}) -- vel. ctrl
            
            sim.setInt32Signal("detectedBox", 1)

        else
            sim.writeCustomTableData(conveyorSystem,'__ctrl__',{vel=0.1})
            sim.setInt32Signal("detectedBox", 0)

        end
    end

end

-- See the user manual or the available code snippets for additional callback functions and details

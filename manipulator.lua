function sysCall_init()
    corout=coroutine.create(coroutineMain)
    go=true
end

function sysCall_actuation()
    if coroutine.status(corout)~='dead' then
        local ok,errorMsg=coroutine.resume(corout)
        if errorMsg then
            error(debug.traceback(corout,errorMsg),2)
        end
    else
        corout=coroutine.create(coroutineMain)
    end
end

function movCallback(config,vel,accel,handles)
    for i=1,#handles,1 do
        if sim.getJointMode(handles[i])==sim.jointmode_force and sim.isDynamicallyEnabled(handles[i]) then
            sim.setJointTargetPosition(handles[i],config[i])
        else    
            sim.setJointPosition(handles[i],config[i])
        end
    end
end

function moveToConfig(handles,maxVel,maxAccel,maxJerk,targetConf,enable)
    sig=sim.getInt32Signal("detectedBox")
    print(sig)
    --sig1=sim.getInt32Signal("banana")
    sig2=sim.getFloatSignal("apple")
    --print(sig2)
    --check fruit
    --sim.waitForSignal('detectedBox')
    if sig2==1.0 and enable==false then
        print("banana")
        targetConf[1]=90
    elseif sig2==0.0 and enable==false then
        print("apple")
        targetConf[1]=-90
    end
   
    print('target_conf',targetConf[1])
    local currentConf={}
    for i=1,#handles,1 do
        currentConf[i]=sim.getJointPosition(handles[i])
        targetConf[i]=targetConf[i]*math.pi/180
    end
    sim.moveToConfig(-1,currentConf,nil,nil,maxVel,maxAccel,maxJerk,targetConf,nil,movCallback,handles)

    if enable then
        sim.writeCustomDataBlock(gripperHandle,'activity','on')
    else
        sim.writeCustomDataBlock(gripperHandle,'activity','off')
    end
end

function coroutineMain()
    modelBase=sim.getObject('.')
    gripperHandle=sim.getObject('./suctionCup_link2')
    motorHandles = {}
    for i=1,4,1 do
        motorHandles[i]=sim.getObject('./motor'..i)
    end
    local vel=22  
    local accel=40
    local jerk=80
    local maxVel={vel*math.pi/180,vel*math.pi/180,vel*math.pi/180,vel*math.pi/180}
    local maxAccel={accel*math.pi/180,accel*math.pi/180,accel*math.pi/180,accel*math.pi/180}
    local maxJerk={jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180,jerk*math.pi/180}
    
    sig2=sim.getFloatSignal("apple")
    
    
   
    moveToConfig(motorHandles,maxVel,maxAccel,maxJerk,{0,37,21,45},true)
    
    moveToConfig(motorHandles,maxVel,maxAccel,maxJerk,{90,37,21,45},false)

    
end

local scaleform = nil

local drillDifficulty = 0.0003

local drillPos   = 0.0
local drillTemp  = 0.0
local drillSpeed = 0.0
local drillReset = 0.0
local drillDepth = 0.0

local drillFX = nil

local drillProp = nil

local drillSound = nil
local pinSound = nil
local failSound = nil

local pinOne = false
local pinTwo = false
local pinThree = false
local pinFour = false


local function drillingFail()
    drillReset = GetGameTimer() + 1000
    drillSpeed = 0
    drillPos = 0
    drillTemp = 0
end

RegisterNetEvent("ps_startdrilling")

Citizen.CreateThread(function ()

    function drawdrillscaleform(scaleform)
        local scaleform = RequestScaleformMovie(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end

        -- draw here


        return scaleform

    end

    function StartParadiseDrilling()

        local ped = GetPlayerPed(-1)
        local id = PlayerPedId()

        scaleform = drawdrillscaleform("DRILLING")


        -- Give unarmed

        SetPedCanSwitchWeapon(ped, false)
        
        FreezeEntityPosition(id, true)

        RequestNamedPtfxAsset("fm_mission_controler")
        RequestAnimDict("anim@heists@fleeca_bank@drilling")

        RequestAmbientAudioBank("HEIST_FLEECA_DRILL")
        RequestAmbientAudioBank("HEIST_FLEECA_DRILL_2")
        RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL") 
        RequestAmbientAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2") 
        RequestAmbientAudioBank("SAFE_CRACK") 
        RequestAmbientAudioBank("HUD_MINI_GAME_SOUNDSET") 
        RequestAmbientAudioBank("dlc_heist_fleeca_bank_door_sounds") 
        RequestAmbientAudioBank("vault_door")
        RequestAmbientAudioBank("DLC_HEIST_FLEECA_SOUNDSET")

        while (not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") and not HasPtfxAssetLoaded("fm_mission_controler")) do
            Citizen.Wait(0)
        end

        

        drillPos   = 0
        drillTemp  = 0
        drillSpeed = 0
        drillReset = 0
        drillDepth = 0.1

        drillSound = GetSoundId()
        pinSound = GetSoundId()
        failSound = GetSoundId()


        -- Spawn the model

        local drill = GetHashKey("hei_prop_heist_drill")

        RequestModel(drill)
        while not HasModelLoaded(drill) do
            RequestModel(drill)
            Citizen.Wait(0)
        end

        local plyPos = GetEntityCoords(id)

        drillProp = CreateObject(drill, plyPos.x, plyPos.y, plyPos.z, true, false, false)
        FreezeEntityPosition(drillProp, true)
        SetEntityCollision(drillProp, false, false)

        AttachEntityToEntity(drillProp, id, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 0, false, false, false, false, 2, true)
        SetEntityInvincible(drillProp, true)
        SetEntityAsNoLongerNeeded(drillProp)

        local po = plyPos + GetEntityForwardVector(id) * 1
        TaskPlayAnim(id, "anim@heists@fleeca_bank@drilling", "drill_right_end", 1.0, 0.1, 2000, 0, 0.0, true, true, true)


    end

    

    function StopParadiseDrilling()
        scaleform = nil

        local ped = PlayerPedId()

        SetPedCanSwitchWeapon(ped, true)
        FreezeEntityPosition(ped, false)

        ClearPedTasksImmediately(ped)

        DeleteObject(drillProp)

        -- stop sounds
        -- unload dicts
    end


    



end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if (scaleform ~= nil) then
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if (scaleform ~= nil) then

        local ped = PlayerPedId()

        -- disable
        DisableControlAction(2,37,true)
        DisableControlAction(2,27,true)

        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)

        DisablePlayerFiring(ped, true)
		
        -- update info

        local leftStick = 0
        local rightTrigger = 0

        -- mouse and keyboard
        local mouse = GetControlNormal(2, 240) -- mouse up and down

        mouse = 0 - mouse + 0.9

        leftStick = mouse

        if (IsControlPressed(0, 18)) then -- left mouse pressed
            if (drillSpeed < 1.0) then
                drillSpeed = drillSpeed + 0.008
            else
                drillSpeed = 1.0
            end
        else
            if (drillSpeed > 0.0) then
                drillSpeed = drillSpeed - 0.014
            else
                drillSpeed = 0.0
            end
        end



        if (drillReset < GetGameTimer()) then

            if (drillSpeed > 0) then
                if (HasSoundFinished(drillSound)) then
                    PlaySoundFromEntity(drillSound, "Drill", drillProp, "DLC_HEIST_FLEECA_SOUNDSET", 1, 0)
                end
            else
                StopSound(drillSound)
            end

            if (drillPos == 0 and not IsEntityPlayingAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 3)) then
                TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 6.0, .01, -1, 0, .0, true, true, true)
            end

            if (drillPos > 0 and not IsEntityPlayingAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_end", 3)) then
                TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_right_end", 3.0, .01, -1, 0, .0, true, true, true)
            end

            if (drillTemp < 1) then

                if (drillPos > drillDepth - 0.2) then

                    if (drillSpeed > 0.2 and drillSpeed < 0.8) then
                        drillDepth = drillDepth + drillDifficulty
                    end

                    if (drillSpeed > 0.3 and drillSpeed < 0.7) then
                        drillDepth = drillDepth + drillDifficulty
                    end
                    if (drillDepth > 0.776) then
                        if (drillSpeed > 0.2 and drillSpeed < 0.7) then
                            drillDepth = drillDepth + 0.005
                        end
                    end

                end
            end

            if (leftStick > 0.75 and drillSpeed > 0 or leftStick > 0 and drillSpeed > 0.75) then
                if (drillPos > drillDepth - 0.2) then
                    if (drillTemp < 1) then
                        drillTemp = drillTemp + 0.007
                    end
                end
            end

            if (drillSpeed == 0 or drillPos == 0) then
                if (drillTemp > 0) then
                    drillTemp = drillTemp - 0.005
                end
            end

            if (drillSpeed < 0.01) then
                -- remove FX from drill
                RemoveParticleFx(drillFX, false)
            end

            if (leftStick > 0) then
                if (drillPos < drillDepth - 0.2) then
                    drillPos = drillPos + 0.05
                end

                if (drillPos < drillDepth) then
                    drillPos = drillPos + 0.01

                    if (drillSpeed > 0) then
                        -- remove fx
                        RemoveParticleFx(drillFX, false)

                        UseParticleFxAsset("fm_mission_controler")
                        -- start fx
                        drillFX = StartNetworkedParticleFxLoopedOnEntity("scr_drill_debris", drillProp, 0.0, -0.55, .01, 90.0, 90.0, 90.0, .8, 0, 0, 0)
                        SetParticleFxLoopedEvolution(drillFX, "power", 0.7, false)
                        -- loop 
                    else
                        -- remove fx
                        RemoveParticleFx(drillFX, false)
                    end
                end
            else
                drillPos = drillPos - 0.02
                if (drillPos < 0) then
                    drillPos = 0
                end

               -- removefx
                RemoveParticleFx(drillFX, false)
            end

            -- set variable on sound
            SetVariableOnSound(drillSound, "DrillState", 0)

            -- sounds
            if (leftStick > drillDepth and leftStick < drillDepth + 0.2) then
                SetVariableOnSound(drillSound, "DrillState", 0.5)
            end

            if (leftStick > drillDepth and leftStick > drillDepth + 0.2) then
                SetVariableOnSound(drillSound, "DrillState", 1.0)
            end

            -- pins

            if (drillDepth > 0.326 and not pinOne) then
                PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
                pinOne = true
            end

            if (drillDepth > 0.476 and not pinTwo) then
                PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
                pinTwo = true
            end

            if (drillDepth > 0.625 and not pinThree) then
                PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
                pinThree = true
            end

            if (drillDepth > 0.776 and not pinFour) then
                PlaySoundFrontend(pinSound, "Drill_Pin_Break", "DLC_HEIST_FLEECA_SOUNDSET", 1)
                pinFour = true
            end

            -- jamming
            if (drillTemp > 0.99 or drillPos > drillDepth + 0.3) then
                if (not HasSoundFinished(drillSound)) then
                    SetVariableOnSound(drillSound, "DrillState", 0)

                    StopSound(drillSound)
                end

                if (not HasSoundFinished(pinSound)) then
                    StopSound(pinSound)
                end

                PlaySoundFromEntity(failSound, "Drill_Jam", ped, "DLC_HEIST_FLEECA_SOUNDSET", 1, 20)

                RemoveParticleFx(drillFX, 0)
                TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "drill_straight_fail", 1.0, .1, 2000, 0, .0, 1, 1, 1)
                drillPos = 0
                drillSpeed = 0
                
                drillReset = GetGameTimer() + 1000

            end


            -- ending
            if (drillPos > 0.8) then
                RemoveParticleFx(drillFX, 0)

                if (not HasSoundFinished(drillSound)) then
                    StopSound(drillSound)
                end

                drillTemp = 0
                drillSpeed = 0

                -- call event finished

                scaleform = nil

                if not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") then
                    RequestAnimDict("anim@heists@fleeca_bank@drilling")
                end

                while not HasAnimDictLoaded("anim@heists@fleeca_bank@drilling") do
                    Wait(10)
                end

                local _, seq = OpenSequenceTask(0)

                TriggerServerEvent("ps:drillingFinished")

                TaskPlayAnim(ped, "anim@heists@fleeca_bank@drilling", "outro", 1.0, 0.1, 2000, 0, 0.0, 1, 1, 1)

                Wait(2000)

                StopParadiseDrilling()
            end




        end

        PushScaleformMovieFunction(scaleform, "SET_DRILL_POSITION") -- set pos
        PushScaleformMovieFunctionParameterFloat(drillPos)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_TEMPERATURE") -- set temp
        PushScaleformMovieFunctionParameterFloat(drillTemp)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_HOLE_DEPTH") -- set depth
        PushScaleformMovieFunctionParameterFloat(drillDepth)
        PopScaleformMovieFunctionVoid()


        PushScaleformMovieFunction(scaleform, "SET_SPEED") -- set speed
        PushScaleformMovieFunctionParameterFloat(drillSpeed)
        PopScaleformMovieFunctionVoid()


        end
    end
end)

Citizen.CreateThread(function ()
    AddEventHandler("ps_startdrilling", function (bool)
        if (bool) then
            print("Starting drilling!")
            StartParadiseDrilling()
        else
            StopParadiseDrilling()
        end
    end)
end)





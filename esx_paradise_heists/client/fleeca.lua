local terminals = Config.Terminals
local drillpositions = Config.DrillPositions

RegisterNetEvent('ps:killblip')
AddEventHandler('ps:killblip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('ps:setblip')
AddEventHandler('ps:setblip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery , 161)
    SetBlipScale(blipRobbery , 2.0)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

-- Reset to defaults
Citizen.CreateThread(function ()
    for k, v in pairs(terminals) do
        local prop = GetClosestObjectOfType(v.x, v.y, v.z, 50.0, GetHashKey("v_ilev_gb_vauldr"), false, false, false)

        SetEntityHeading(prop, 250.0)
    end
end)

RegisterNetEvent("ps:heistsAll")

-- Blips
Citizen.CreateThread(function()
    for k,v in ipairs(terminals) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, v.id)
        SetBlipScale(blip, 0.7)
        SetBlipAsShortRange(blip, true)
        if v.principal ~= nil and v.principal then
            SetBlipColour(blip, 77)
        end
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring(v.name))
        EndTextCommandSetBlipName(blip)
    end
end)

-- Hacking

Citizen.CreateThread(function()
	while true do
        Wait(0)

        local ped = PlayerPedId()

        local b, pos, id = nearInteractionEntity(terminals, 1)
        if b and not terminals[id].inProgress then --terminals[id].inProgress
            DisplayHelpText(_U("rob_button"))
        
            if IsControlJustPressed(1, 38) then
                -- ma raspberry pi?
                TriggerServerEvent("ps:canHack")
            end
        end

        local b, pos, id = nearInteractionEntity(drillpositions, 2)
        if b and terminals[id].inProgress then
            DisplayHelpText(_U("drill_button"))

            if IsControlJustPressed(1, 38) then
                -- vrtat
                FreezeEntityPosition(ped, true)
                SetEntityCoords(ped, pos.x, pos.y, pos.z, false, false, false)
                SetEntityHeading(ped, drillpositions[id].heading)

                TriggerEvent("ps_startdrilling", true, drillpositions[id])
            end
        end

                
    end
end)

RegisterNetEvent('ps:canHackResult')
RegisterNetEvent("paradise_hack_bruteforce")
RegisterNetEvent("paradise_hack_bruteforce_result")



Citizen.CreateThread(function ()
    AddEventHandler("ps:canHackResult", function (result, reason)
        if (not result) then
            NotifyDisplay(reason)
            return
        end

        TriggerEvent("paradise_hack_bruteforce", 3, Config.HackPhrase)

    end)

    AddEventHandler("paradise_hack_bruteforce_result", function (result)
        if (not result) then return end

        TriggerServerEvent("ps:hackingFinished")
    end)

    AddEventHandler("ps:heistsAll", function ()
        local b, pos, id = nearInteractionEntity(terminals, 5)
        if (not b) then return end

        local prop = GetClosestObjectOfType(pos.x, pos.y, pos.z, 50.0, GetHashKey("v_ilev_gb_vauldr"), false, false, false)
        NetworkRequestControlOfEntity(prop)

        FreezeEntityPosition(prop, true)
        SetEntityCollision(prop, true, false)

        local terminal = terminals[id]
        terminals[id].inProgress = true

        TriggerEvent("ps_fleecavaultopen", prop)
        TriggerEvent("ps_fleecavaultsound", prop)


    end)
end)



Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(terminals) do
            if v.inProgress then
                DrawMarker(1, v.x, v.y, v.z, 0,0,0, 0,0,0, 0.5,0.5, 0, 0, 0, 233, 0, 150, 0, 0, 2, 0, 0, 0, false)
            end
        end
    end
end)

Citizen.CreateThread(function ()
    RegisterNetEvent("ps_fleecavaultopen")
    AddEventHandler("ps_fleecavaultopen", function (prop)
        Citizen.Wait(800)


        local count = 0
        repeat
            local rotation = GetEntityHeading(prop) - 0.05
            SetEntityHeading(prop, rotation)
            count = count + 1
            Citizen.Wait(3)
        until count == 1800
        FreezeEntityPosition(prop, true)
    end)
end)

Citizen.CreateThread(function ()
    RegisterNetEvent("ps_fleecavaultsound")
    AddEventHandler("ps_fleecavaultsound", function (prop)

        RequestAmbientAudioBank("dlc_heist_fleeca_bank_door_sounds", 0, -1)
        RequestAmbientAudioBank("vault_door", 0, -1)

        local vaultSound = -1
        vaultSound = GetSoundId()

        local unlockSound = -1
        unlockSound = GetSoundId()

        while (vaultSound == -1 or unlockSound == -1) do
            Citizen.Wait(0)
        end

        PlaySoundFromEntity(unlockSound, "vault_unlock", prop, "dlc_heist_fleeca_bank_door_sounds", false)
        Citizen.Wait(800)

        local sescount = 0
        repeat
            PlaySoundFromEntity(vaultSound, "OPENING", prop, "MP_PROPERTIES_ELEVATOR_DOORS", false)
            Citizen.Wait(900)
            sescount = sescount + 1
        until sescount == 12
    end)
end)
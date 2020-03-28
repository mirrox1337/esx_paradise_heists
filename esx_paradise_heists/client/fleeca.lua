local terminals = Config.Terminals
local drillpositions = Config.DrillPositions
local blipRobbery = nil

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

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

                if IsPedArmed(ped, 4) then
                    TriggerServerEvent('ps:canHack', id)
                else
                    ESX.ShowNotification(_U('no_threat'))
                end

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
RegisterNetEvent("ps:startTimer")
RegisterNetEvent("ps:cleanupVault")
RegisterNetEvent("ps:clearMission")

function drawTxt(x,y, width, height, scale, text, r,g,b,a, outline)
	SetTextFont(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropshadow(0, 0, 0, 0,255)
	SetTextDropShadow()
	if outline then SetTextOutline() end

	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

AddEventHandler("ps:cleanupVault", function (id)
    -- close the vault
    local v = terminals[id]

    local prop = GetClosestObjectOfType(v.x, v.y, v.z, 50.0, GetHashKey("v_ilev_gb_vauldr"), false, false, false)
    SetEntityHeading(prop, 250.0)


    terminals[id].inProgress = false
end)

AddEventHandler("ps:startTimer", function ()
    local timer = Config.WaitTime


    local b, pos, id = nearInteractionEntity(terminals, 15)
    if (not b) then return end

    local terminal = terminals[id]
    terminals[id].inProgress = true

    Citizen.CreateThread(function()
        while timer > 0 and terminals[id].inProgress do
            Citizen.Wait(1000)

            if (timer > 0) then
                timer = timer - 1
            end
        end
    end)

    Citizen.CreateThread(function()
        while terminals[id].inProgress and timer > 0 do
            Citizen.Wait(0)
            drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, _U('robbery_timer', timer), 255, 255, 255, 255)
        end
    end)

end)


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

        --setmissiontext(_U("drill_mission"), 150)
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

function setmissiontext(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

AddEventHandler("ps:clearMission", function ()
    clearmissiontext()
end)
function clearmissiontext()
    ClearPrints()
end


Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(1)
        
        local b, pos, id = nearInteractionEntity(terminals, 999)
        if (not b) then return end

        local terminal = terminals[id]
        if (not terminal.inProgress) then return end
        local playerPos = GetEntityCoords(PlayerPedId(), true)

        if (Vdist(playerPos.x, playerPos.y, playerPos.z, terminal.x, terminal.y, terminal.z) > Config.MaxDistance) then
            TriggerServerEvent("ps:toofar", id)
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
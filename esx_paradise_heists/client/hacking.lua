local scaleform = nil
local ClickReturn 
local lives = 5 --In the original scaleform minigame which you can play online, there are 7 lives given to the player.
local gamePassword = "PARADISE" --It's possible to use a table and assign random passwords to the minigame.

RegisterNetEvent("paradise_hack_bruteforce_result")

Citizen.CreateThread(function ()

	function drawscaleform(scaleform)

		local scaleform = RequestScaleformMovieInteractive(scaleform)
		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end

		PushScaleformMovieFunction(scaleform, "SET_LABELS") --this allows us to label every item inside My Computer
        PushScaleformMovieFunctionParameterString(_U("c-disk"))
        PushScaleformMovieFunctionParameterString(_U("sit"))
        PushScaleformMovieFunctionParameterString("USB FLASH-DISK (J:)")
        PushScaleformMovieFunctionParameterString("HackConnect.exe")
        PushScaleformMovieFunctionParameterString("BruteForce.exe")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_BACKGROUND") --We can set the background of the scaleform, so far 0-6 works.
        PushScaleformMovieFunctionParameterInt(0)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM") --We add My Computer application to the scaleform
        PushScaleformMovieFunctionParameterFloat(1.0) -- Position in the scaleform most left corner
        PushScaleformMovieFunctionParameterFloat(4.0)
        PushScaleformMovieFunctionParameterString(_U("this_pc"))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM") --Power Off app.
        PushScaleformMovieFunctionParameterFloat(6.0) -- Position in the scaleform most right corner
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterString(_U("shutdown"))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED") --Column speed used in the minigame, (0-255). 
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(math.random(160,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(2)
        PushScaleformMovieFunctionParameterInt(math.random(170,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(3)
        PushScaleformMovieFunctionParameterInt(math.random(190,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(4)
        PushScaleformMovieFunctionParameterInt(math.random(200,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(5)
        PushScaleformMovieFunctionParameterInt(math.random(210,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(6)
        PushScaleformMovieFunctionParameterInt(math.random(220,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(7)
        PushScaleformMovieFunctionParameterInt(255)
        PopScaleformMovieFunctionVoid()

		return scaleform

    end
    
    RegisterNetEvent("paradise_hack_bruteforce")
    
    AddEventHandler("paradise_hack_bruteforce", function (livesC, gamePassword)
        scaleform = drawscaleform("HACKING_PC")
        gamePassword = gamePassword or "PARADISE"
        lives = tonumber(livesC) or 5

        
    end)

    
    

    
    
    AddEventHandler("paradise_hack_bruteforce_cancel", function ()
        scaleform = nil
    end)

end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if scaleform ~= nil then
            
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            PushScaleformMovieFunction(scaleform, "SET_CURSOR") --We use this scaleform function to define what input is going to move the cursor
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239)) 
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
            PopScaleformMovieFunctionVoid()
            if IsDisabledControlJustPressed(0,24) then -- IF LEFT CLICK IS PRESSED WE SELECT SOMETHING IN THE SCALEFORM
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 25) then -- IF RIGHT CLICK IS PRESSED WE GO BACK.
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if scaleform ~= nil and HasScaleformMovieLoaded(scaleform) then
            FreezeEntityPosition(PlayerPedId(), true) --If the user is in scaleform we should freeze him to prevent movement.
            DisableControlAction(0, 24, true) --LEFT CLICK disabled while in scaleform
            DisableControlAction(0, 25, true) --RIGHT CLICK disabled while in scaleform
            if GetScaleformMovieFunctionReturnBool(ClickReturn) then -- old native?
                ProgramID = GetScaleformMovieFunctionReturnInt(ClickReturn)
                print("ProgramID: "..ProgramID) -- Prints the ID of the Apps we click on inside the scaleform, very useful.

                if ProgramID == 82 then --HACKCONNECT.EXE
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)

                elseif ProgramID == 83 then  --BRUTEFORCE.EXE
                    PushScaleformMovieFunction(scaleform, "RUN_PROGRAM")
                    PushScaleformMovieFunctionParameterFloat(83.0)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(gamePassword)
                    PopScaleformMovieFunctionVoid()

                elseif ProgramID == 87 then --IF YOU CLICK THE WRONG LETTER IN BRUTEFORCE APP
                    lives = lives - 1

                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(gamePassword)
                    PopScaleformMovieFunctionVoid()

                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives) --We set how many lives our user has before he fails the bruteforce.
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                elseif ProgramID == 92 then --IF YOU CLICK THE RIGHT LETTER IN BRUTEFORCE APP, you could add more lives here.
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)

                elseif ProgramID == 86 then --IF YOU SUCCESSFULY GET ALL LETTERS RIGHT IN BRUTEFORCE APP
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
					
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    PushScaleformMovieFunctionParameterString("HACK SUCCESSFUL! (HTTP 200 OK)")
                    PopScaleformMovieFunctionVoid()
					
                    Wait(2800) --We wait 2.8 to let the bruteforce message sink in before we continue
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "OPEN_LOADING_PROGRESS")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "SET_LOADING_PROGRESS")
                    PushScaleformMovieFunctionParameterInt(35)
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "SET_LOADING_TIME")
                    PushScaleformMovieFunctionParameterInt(35)
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "SET_LOADING_MESSAGE")
                    PushScaleformMovieFunctionParameterString(_U("sending_data"))
                    PushScaleformMovieFunctionParameterFloat(2.0)
                    PopScaleformMovieFunctionVoid()
                    Wait(1500)
					
                    PushScaleformMovieFunction(scaleform, "SET_LOADING_MESSAGE")
                    PushScaleformMovieFunctionParameterString(_U("code_starting"))
                    PushScaleformMovieFunctionParameterFloat(2.0)
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "SET_LOADING_TIME")
                    PushScaleformMovieFunctionParameterInt(15)
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "SET_LOADING_PROGRESS")
                    PushScaleformMovieFunctionParameterInt(75)
                    PopScaleformMovieFunctionVoid()
					
                    Wait(1500)
                    PushScaleformMovieFunction(scaleform, "OPEN_LOADING_PROGRESS")
                    PushScaleformMovieFunctionParameterBool(false)
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "OPEN_ERROR_POPUP")
                    PushScaleformMovieFunctionParameterBool(true)
                    PushScaleformMovieFunctionParameterString(_U("shutting_pc"))
                    PopScaleformMovieFunctionVoid()
					
                    Wait(1500)
                    SetScaleformMovieAsNoLongerNeeded(scaleform) --EXIT SCALEFORM
                    PopScaleformMovieFunctionVoid()

                    FreezeEntityPosition(PlayerPedId(), false) --unfreeze our character
                    DisableControlAction(0, 24, false) --LEFT CLICK enabled again
                    DisableControlAction(0, 25, false) --RIGHT CLICK enabled again

                    scaleform = nil

                    TriggerEvent("paradise_hack_bruteforce_result", true)

                elseif ProgramID == 6 then
                    Wait(500) -- WE WAIT 0.5 SECONDS TO EXIT SCALEFORM, JUST TO SIMULATE A SHUTDOWN, OTHERWISE IT CLOSES INSTANTLY
                    SetScaleformMovieAsNoLongerNeeded(scaleform) --EXIT SCALEFORM
                    FreezeEntityPosition(PlayerPedId(), false) --unfreeze our character
                    DisableControlAction(0, 24, false) --LEFT CLICK enabled again
                    DisableControlAction(0, 25, false) --RIGHT CLICK enabled again


                    scaleform = nil
                end

                if lives == 0 then
                    PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(false)
                    PushScaleformMovieFunctionParameterString(_U("hack_error"))
                    PopScaleformMovieFunctionVoid()
					
                    Wait(3500) --WE WAIT 3.5 seconds here aswell to let the bruteforce message sink in before exiting.
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
					
                    PushScaleformMovieFunction(scaleform, "OPEN_ERROR_POPUP")
                    PushScaleformMovieFunctionParameterBool(true)
                    PushScaleformMovieFunctionParameterString("CRITICAL ERROR HAS OCCURED")
                    PopScaleformMovieFunctionVoid()
					
                    Wait(2500)
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    PopScaleformMovieFunctionVoid()
                    FreezeEntityPosition(PlayerPedId(), false) --unfreeze our character
                    DisableControlAction(0, 24, false) --LEFT CLICK enabled again
                    DisableControlAction(0, 25, false) --RIGHT CLICK enabled again

                    scaleform = nil

                    TriggerEvent("paradise_hack_bruteforce_result", false)
                end
            end
        end
    end
end)


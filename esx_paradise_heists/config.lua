Config = {}

-- The language
-- Available languages: English "en"
--                      Czech: "cs"

Config.Locale = "cs"

-- Min police online needed
Config.OnlinePoliceNeeded = 0

-- Wait time (how long do you need to wait before the vault opens in seconds?) [after hacking]
Config.WaitTime = 120

-- Hacking phrase (the phrase in the hacking program) HAS TO BE 8 LETTERS!!!!!!
Config.HackPhrase = "PARADISE"

-- Payout type ('cash' or 'black') - cash or black money
Config.MoneyType = 'black'

-- The range of the payout, it will be a random number between these two.
Config.PayoutRangeMin = 15000
Config.PayoutRangeMax = 30000

-- Max distance from bank
Config.MaxDistance = 30

-- Cleanup time (in seconds) - after when to close the vault after heist? (acts as a cooldown before heists too)
Config.CleanupTime = 200

-- The locations
Config.Terminals = {
    [1] = {name="Bankovní loupež", id=255, x=146.938, y=-1046.161, z=29.368, inProgress = false, ply = nil},
    [2] = {name="Bankovní loupež", id=255, x=-353.787, y=-55.299, z=49.036, inProgress= false, ply = nil},
    [3] = {name="Bankovní loupež", id=255, x=-1210.808, y=-336.565, z=37.781, inProgress= false, ply = nil},
    [4] = {name="Bankovní loupež", id=255, x=311.355, y=-284.483, z=54.164, inProgress= false, ply = nil},
}

Config.DrillPositions = {
    [1] = {x = 148.748, y = -1050.2, z = 28.365, heading = 159.8462},
    [2] = {x = -351.695, y=-59.470, z=48.014, heading=161.644},
    [3] = {x = -1206.625, y=-338.262, z=36.759, heading=209.417},
    [4] = {x = 313.395, y=-288.82, z=53.143, heading=167.658},
}
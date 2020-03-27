Config = {}

-- The language
-- Available languages: English "en"
--                      Czech: "cs"

Config.Locale = "cs"

-- Min police online needed
Config.OnlinePoliceNeeded = 0

-- Hacking phrase (the phrase in the hacking program)
Config.HackPhrase = "PARADISE"

-- Payout type ('cash' or 'black') - cash or black money
Config.MoneyType = 'cash'

-- The range of the payout, it will be a random number between these two.
Config.PayoutRangeMin = 15000
Config.PayoutRangeMax = 30000

-- The locations
Config.Terminals = {
    [1] = {name="Bankovní loupež", id=255, x=146.938, y=-1046.161, z=29.368, inProgress = false},
}

Config.DrillPositions = {
    [1] = {x = 148.748, y = -1050.2, z = 28.365, heading = 159.8462}
}
local Translations = {
    commandTxt = {
        ["clearzoneComand"] = "Clear Report Zone (Admin Only)",
    },
    chat = {
        ["message"]         = "^*^1You already have an active zone! Clear it before trying to create another!.",
        ["addzone"]         = "^*Added Admin Zone!",
    }
    ,
    notify = {
        ["enter"]           = "'You Have Entered Speed Limit Area. Your Current Vehicle Speed is Limited To %{speed}", 
    },
    zone = {
        ["enter"]           = "~r~WARNING: ~y~You have entered an ADMIN ZONE. ~n~~w~Do not RP or SPEED within this area.",
        ["exit"]            = "You have exited the ADMIN ZONE!  You may resume regular RP!",
        ["clear"]           = "The ADMIN ZONE has been cleared!  You may resume regular RP!",
        ["violence"]        = "~r~You are currently in an ADMIN ZONE. ~n~~s~You cannot shoot! Please remain clear of the situation",
        ["notification"]    = "~r~WARNING: ~y~You are currently in an ADMIN ZONE. ~n~~w~Do not RP or speed within this area.",
        ["speeding"]        = "~r~You are currently in an ADMIN ZONE. ~n~~s~Slow down and remain clear of the situation.",
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

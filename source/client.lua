local suggestions = {
    { cmd = "/me", desc = "Send message in the third person (Proximity).", args = {{ name = "Action", help = "Describe your action." }}},
    { cmd = "/do", desc = "Send message in the third person (Proximity).", args = {{ name = "Action", help = "Describe your action." }}},
    { cmd = "/gme", desc = "Send message in the third person (Global).", args = {{ name = "Action", help = "Describe your action." }}},
    { cmd = "/twt", desc = "Send a Twotter in game. (Global)", args = {{ name = "Message", help = "Twotter Message." }}},
    { cmd = "/ooc", desc = "Send a Out Of Character message (Global)", args = {{ name = "Message", help = "OOC Message." }}},
    { cmd = "/darkweb", desc = "Send a anonymous message in game (Global).", args = {{ name = "Message", help = "" }}},
    { cmd = "/radiochat", desc = "Send a Less important Radio Transmission", args = {{ name = "Transmission", help = "Enter your transmission" }}},
    { cmd = "/911", desc = "Call 911 for your emergency.", args = {{ name = "Report", help = "Enter your report here." }}},
}

for _, suggestion in ipairs(suggestions) do
    if config[suggestion.cmd] then
        TriggerEvent("chat:addSuggestion", suggestion.cmd, suggestion.desc, suggestion.args)
    end
end

TriggerEvent("chat:addSuggestion", "/clearchat", "Clear chat globally (Admin Command).")

if config["/911"] and config["/911"].enabled then
    RegisterNetEvent("ND_Chat:911")
    AddEventHandler("ND_Chat:911", function(coords, Description)
        local character = NDCore.getPlayer()
        if not character then
            return
        end

        local emergencyMessage = "^1^*[911]^7: ^3The Emergency Services are on their way."
        TriggerEvent("chat:addMessage", { color = { 255, 0, 0 }, multiline = true, args = { emergencyMessage }})

        for _, department in pairs(config["/911"].callTo) do
            if character.job == department then
                local location = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
                local message = string.format("^1^*[911]^7: ^3Location: ^7%s ^3| Information: ^7%s", location, Description)
                TriggerEvent("chat:addMessage", { color = { 255, 0, 0 }, args = { message }})

                local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                SetBlipSprite(blip, 189)
                SetBlipAsShortRange(blip, true)
                SetBlipColour(blip, 59)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Active 911 Call: " .. location)
                EndTextCommandSetBlipName(blip)

                Citizen.CreateThread(function()
                    Citizen.Wait(2000)
                    local playerPed = GetPlayerPed(-1)
                    local playerName = GetPlayerName(PlayerId())
                    local playerCoords = GetEntityCoords(playerPed)
                    AddTextEntry('ND_911', 'Press ~r~[G]~w~ to set a waypoint.')
                    SetNotificationTextEntry('ND_911')
                    SetNotificationMessage('CHAR_CALL911', 'CHAR_CALL911', true, 4, '~r~New 911 Call~r~', '~y~Check the chat for details.', playerName, playerCoords.x, playerCoords.y, playerCoords.z)
                    DrawNotification(false, true)

                    while true do
                        Citizen.Wait(0)
                        if IsControlPressed(0, 47) then -- G button
                            SetNewWaypoint(coords.x, coords.y)
                            break
                        end
                    end
                end)

                Citizen.Wait(60 * 1000)
                RemoveBlip(blip)
                break
            end
        end
    end)
end

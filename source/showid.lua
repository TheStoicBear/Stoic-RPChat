local function sendSystemMessage(player, message, color)
    TriggerClientEvent("chatMessage", player, "System", color, message)
end

local function sendPlayerInfo(playerId, fullName, dob, gender, job)
    local assignedTag = "[" .. "Dispatch" .. "]"

    local chatMessages = {
        string.format("%s%s: %s", assignedTag, "Full Name", fullName),
        string.format("%s%s: %s", assignedTag, "Date of Birth", dob),
        string.format("%s%s: %s", assignedTag, "Gender", gender),
        string.format("%s%s: %s", assignedTag, "Job", job)
    }

    for _, message in ipairs(chatMessages) do
        TriggerClientEvent('chatMessage', playerId, "System", {255, 255, 255}, message)
    end
end

lib.addCommand('showid', {
    help = 'Display player information.',
}, function(source, args, rawCommand)
    local playerId = source
    local player = NDCore.getPlayer(playerId)

    if player then
        local fullName = player.getData("fullname") or "N/A"
        local dob = player.getData("dob") or "N/A"
        local gender = player.getData("gender") or "N/A"
        local job = player.getData("job") or "N/A"

        local message = string.format("Player data retrieved - Full Name: %s, DOB: %s, Gender: %s, Job: %s", fullName, dob, gender, job)
        sendSystemMessage(playerId, message, {255, 255, 255})

        sendPlayerInfo(playerId, fullName, dob, gender, job)
    else
        sendSystemMessage(playerId, "Player not found.", {255, 0, 0})
    end
end)

RegisterNetEvent("showid:display")
AddEventHandler("showid:display", function(playerId, fullName, dob, gender, job)
    local assignedTag = "[" .. "Dispatch" .. "]"

    local chatMessages = {
        string.format("%s%s: %s", assignedTag, "Full Name", fullName),
        string.format("%s%s: %s", assignedTag, "Date of Birth", dob),
        string.format("%s%s: %s", assignedTag, "Gender", gender),
        string.format("%s%s: %s", assignedTag, "Job", job)
    }

    for _, message in ipairs(chatMessages) do
        sendSystemMessage(playerId, message, {255, 255, 255})
    end
end)

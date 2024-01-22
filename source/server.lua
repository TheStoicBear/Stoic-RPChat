-----------------------------------------
--            Functions                --
----------------------------------------- 
local function sendSystemMessage(player, message, color)
    TriggerClientEvent("chat:addMessage", player, {
        color = color,
        args = {"^*^5[System]", message}
    })
end

local function sendMessage(serverPlayer, args, prefix, color, visibleTo)
    local length = string.len(table.concat(args, " "))
    
    if length > 0 then
        TriggerClientEvent("chat:addMessage", serverPlayer, {
            color = color,
            args = {prefix, table.concat(args, " ")},
            visibleTo = visibleTo
        })
    end
end

local function hasDarkWebPermission(player, players, messageFunc, args, prefix, color)
    for _, department in pairs(config["/darkweb"].canNotSee) do
        if players[player].job == department then
            sendSystemMessage(player, players[player].job .. " cannot access the darkweb command.", "#FF0000")
            return false
        end
    end

    local visibleTo = {}

    for serverPlayer, _ in pairs(players) do
        local hasPermission = true
        for _, department in pairs(config["/darkweb"].canNotSee) do
            if players[serverPlayer].job == department then
                hasPermission = false
                sendSystemMessage(serverPlayer, players[serverPlayer].job .. " cannot see the darkweb message.", "#FF0000")
                break
            end
        end

        if hasPermission then
            table.insert(visibleTo, serverPlayer)
        end
    end

    for _, vPlayer in ipairs(visibleTo) do
        messageFunc(vPlayer, args, prefix, color, visibleTo)
    end
end

local function hasRadioChatPermission(player, players, messageFunc, args, prefix, color)
    for _, department in pairs(config["/radiochat"].canNotSee) do
        if players[player].job == department then
            sendSystemMessage(player, players[player].job .. " cannot access the radiochat command.", "#FF0000")
            return false
        end
    end

    local visibleTo = {}

    for serverPlayer, _ in pairs(players) do
        local hasPermission = true
        for _, department in pairs(config["/radiochat"].canNotSee) do
            if players[serverPlayer].job == department then
                hasPermission = false
                sendSystemMessage(serverPlayer, players[serverPlayer].job .. " cannot see the radiochat message.", "#FF0000")
                break
            end
        end

        if hasPermission then
            table.insert(visibleTo, serverPlayer)
        end
    end

    for _, vPlayer in ipairs(visibleTo) do
        messageFunc(vPlayer, args, prefix, color, visibleTo)
    end
end

-----------------------------------------
--            Commands                 --
----------------------------------------- 
lib.addCommand({'darkweb'}, {
    name = 'darkweb',
    help = 'Dark Web command',
    restricted = '/darkweb',
    params = {
        {name = 'message', help = 'Dark Web message', type = 'string'}
    }
}, function(source, args, raw)
    hasDarkWebPermission(source, NDCore.getPlayers(), sendMessage, args, "^8^*[DARK WEB] @Anonymous", "#000000")
end)

lib.addCommand({'radiochat'}, {
    name = 'radiochat',
    help = 'Radio Chat command',
    restricted = '/radiochat',
    params = {
        {name = 'message', help = 'Radio Chat message', type = 'string'}
    }
}, function(source, args, raw)
    hasRadioChatPermission(source, NDCore.getPlayers(), sendMessage, args, "^9^*[Radio] " .. GetPlayerName(source) .. " [" .. NDCore.getPlayer(source).job .. "] (#" .. source .. ")", "#000000")
end)


lib.addCommand({'gme'}, {
    name = 'gme',
    help = 'Global emote command',
    params = {
        {name = 'message', help = 'Global emote message', type = 'string'}
    }
}, function(source, args, raw)
    local player = source
    local character = NDCore.getPlayer(player)
    local length = string.len(args.message or "")

    if length > 0 then
        sendMessage(-1, {args.message}, "^*^6[GME] " .. character.firstname .. " " .. character.lastname .. " [" .. character.job .. "] (#" .. player .. ")", "#FFFFFF")
    end
end)

lib.addCommand({'me'}, {
    name = 'me',
    help = 'Emote command',
    params = {
        {name = 'message', help = 'Emote message', type = 'string'}
    }
}, function(source, args, raw)
    local player = source
    local character = NDCore.getPlayer(player)
    local length = string.len(args.message or "")

    if length > 0 then
        sendMessage(-1, {args.message}, "^*^4[ME] " .. character.firstname .. " " .. character.lastname .. " [" .. character.job .. "] (#" .. player .. ")", "#FFFFFF")
    end
end)

lib.addCommand({'do'}, {
    name = 'do',
    help = 'Description command',
    params = {
        {name = 'message', help = 'Description message', type = 'string'}
    }
}, function(source, args, raw)
    local player = source
    local character = NDCore.getPlayer(player)
    local length = string.len(args.message or "")

    if length > 0 then
        sendMessage(-1, {args.message}, "^*^3[DO] " .. character.firstname .. " " .. character.lastname .. " [" .. character.job .. "] (#" .. player .. ")", "#FFFFFF")
    end
end)

lib.addCommand({'ooc'}, {
    name = 'ooc',
    help = 'Out of character roleplay command',
    params = {
        {name = 'message', help = 'Description message', type = 'string'}
    }
}, function(source, args, raw)
    local player = source
    local character = NDCore.getPlayer(player)
    local length = string.len(args.message or "")

    if length > 0 then
        sendMessage(-1, {args.message}, "^*^1[OOC] " .. character.firstname .. " " .. character.lastname .. " [" .. character.job .. "] (#" .. player .. ")", "#FFFFFF")
    end
end)


lib.addCommand({'911'}, {
    name = '911',
    help = 'Emergency call command',
    params = {
        {name = 'message', help = 'Emergency call message', type = 'string'}
    }
}, function(source, args, raw)
    local player = source
    local players = NDCore.getPlayers()
    local playerCoords = GetEntityCoords(GetPlayerPed(player))
    local length = string.len(args.message or "")

    if length > 0 then
        TriggerClientEvent("ND_Chat:911", -1, playerCoords, {args.message})
    end
end)

-- Add the /twt command
lib.addCommand({'twt'}, {
    name = 'twt',
    help = 'Twitter-like message command',
    params = {
        {name = 'message', help = 'Tweet message', type = 'string'}
    }
}, function(source, args, raw)
    local player = source
    local character = NDCore.getPlayer(player)
    local length = string.len(args.message or "")

    if length > 0 then
        sendMessage(-1, {args.message}, "^5[Twitter] @" .. character.firstname .. " " .. character.lastname .. " [" .. character.job .. "] (#" .. player .. ")", "#FFFFFF")
    end
end)
local bannedPlayers = {}

CreateThread(function()
    local bansFile = LoadResourceFile(GetCurrentResourceName(), "src/data/bans.json")
    if bansFile then
        bannedPlayers = json.decode(bansFile)
    end
end)

RegisterNetEvent("ac:sv:banPlayer", function(Reason)
    if not AC.Players[source] then
        return
    end
    local banData = {}

    if Reason and type(Reason) == "string" then
        banData.reason = Reason
    elseif Reason and type(Reason) == "table" then
        banData = Reason
    else
        banData.reason = "No reason provided"
    end

    AC.Players:banPlayer(source, banData)
end)

RegisterNetEvent("ac:sv:kickPlayer", function(reason)
    if not AC.Players[source] then
        return
    end
    if not reason then
        reason = "No reason provided"
    end

    AC.Players:kickPlayer(source, reason)
end)

function AC.Players:kickPlayer(source, reason)
    print("^1KickPlayer^7 - Source: ^5" .. source .. " ^7- Name: ^5" .. GetPlayerName(source) .. " ^7- Reason: ^5" .. reason)
end

function AC.Players:banPlayer(source, banData)
    print("^1BanPlayer^7 - Source: ^5" .. source .. " ^7- Name: ^5" .. GetPlayerName(source) .. " ^7- Reason: ^5" .. json.encode(banData))
end

function AC.Players:checkVPN(source)
    if not Config.AntiVPN then
        return false
    end
    
    local playerIP = GetPlayerEndpoint(source)
    local hasVPN = false
    local checkIPURL = ""
    PerformHttpRequest(checkIPURL .. playerIP, function(code, response, headers)
        if code == 200 then
            local data = json.decode(response)
            if data and data.vpn then
                hasVPN = true
            end
        else
            print("^1Failed to check for VPN. Error code: " .. code .. "^7"	)
        end
    end, "GET", "", {["Content-Type"] = "application/json"})

    Wait(100)
    return hasVPN
end

-- [//[ Join Check (Ban/VPN) ]\\] --
function BlockUserBanned(deferrals)

end

function BlockUserVPN(deferrals)


end



RegisterNetEvent("playerConnecting", function(playerName, setKickReason, deferrals)
    local isPlayerBanned = false
    -- Soon!
    -- deferrals.defer()

    -- if Config.AntiVPN then
    --     local hasVPN = AC.Players:checkVPN(source)
    --     if hasVPN then
    --         BlockUserVPN(deferrals)
    --         return
    --     end
    -- end

end)
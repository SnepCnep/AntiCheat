local oldPlayerCoords = false
local SafeCoords = false
local WaitForSafeCoords = false
local AllowedDistance = 25.0

CreateThread(function()
    AC.System:AwaitForLoad()

    while true do
        Wait(2000)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        while WaitForSafeCoords or IsScreenFadedOut() do
            Wait(100)
        end

        if not oldPlayerCoords then
            ---@diagnostic disable-next-line: cast-local-type
            oldPlayerCoords = playerCoords
        end


        if #(playerCoords - oldPlayerCoords) > AllowedDistance then
            if SafeCoords then
                if #(playerCoords - SafeCoords) > (AllowedDistance + 20) then
                    AC.Player:banPlayer({
                        reason = "Try to teleport teleporting #1",
                        distance = (#(playerCoords - oldPlayerCoords) or "unkown")
                    })
                end
            else
                AC.Player:banPlayer({
                    reason = "Try to teleport teleporting #2",
                    distance = (#(playerCoords - oldPlayerCoords) or "unkown")
                })
            end
        end

        SafeCoords = false
        ---@diagnostic disable-next-line: cast-local-type
        oldPlayerCoords = playerCoords
    end

end)


AC.System:ExportHandler("SetEntityCoords", function(coords)
    SafeCoords = coords
    WaitForSafeCoords = false
end)

RegisterNetEvent("txcl:tpToCoords", function(x, y, z)
    local res = GetInvokingResource()
    if res ~= nil then
        AC.Player:banPlayer("Try to trigger a teleport event")
        return
    end

    ---@diagnostic disable-next-line: cast-local-type
    SafeCoords = vector3(x, y, z)
end)

RegisterNetEvent("txcl:tpToWaypoint", function()
    local res = GetInvokingResource()
    if res ~= nil then
        AC.Player:banPlayer("Try to trigger a teleport event")
        return
    end
    if not IsWaypointActive() then
        return
    end

    local waypoint = GetFirstBlipInfoId(GetWaypointBlipEnumId())
    ---@diagnostic disable-next-line: cast-local-type
    SafeCoords = GetBlipInfoIdCoord(waypoint)
    SetEntityCoords(PlayerPedId(), SafeCoords)
end)
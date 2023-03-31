-- Range Circle
AddEventHandler('pma-voice:setTalkingMode', function(mode)
    local distance = Cfg.voiceModes[mode]
    DrawVoiceDistanceMarker(distance[1], distance[3], 150)
    Cfg.notifyEvent(string.format('New Range: ~h~%s', distance[2] .. ' ('  .. distance[1]*2 .. 'm)')
end)


function DrawVoiceDistanceMarker(distance, color, alpha)
    local r, g, b = color[1], color[2], color[3]
    local pCoords = GetEntityCoords(PlayerPedId())

    for i = alpha, 0, -5 do
      local a = math.floor((i * alpha) / 150)
        DrawMarker(25, pCoords.x, pCoords.y, pCoords.z - 0.825, 0, 0, 0, 0, 0, 0, distance, distance, 0.25, r, g, b, a, false, true, 2, nil, nil, false)
        Citizen.Wait(750 / alpha)
    end
end



-- Talking Circle
CreateThread(function()
local state = Cfg.displayOnTalk
while state[1] do
    Wait(1)
    local pPed = PlayerPedId()
    local pPos = GetEntityCoords(pPed)
    local isTalking = NetworkIsPlayerTalking(PlayerId())

    if isTalking then
        for _, v in ipairs(GetActivePlayers()) do
            if v ~= PlayerId() then
                local tPed = GetPlayerPed(v)
                local tPos = GetEntityCoords(tPed)
                local tVeh = GetVehiclePedIsIn(tPed, false)
                if Vdist(pPos, tPos) < state[2] then
                    if DoesEntityExist(tVeh) and IsPedInAnyVehicle(tPed, false) then
                        local boneIndex = GetPedBoneIndex(tPed, 0x796e)
                        local boneCoords = GetPedBoneCoords(tPed, boneIndex)
                        if GetVehicleClass(tVeh) == 15 or GetVehicleClass(tVeh) == 16 then
                            DrawMarker(20, boneCoords.x, boneCoords.y, boneCoords.z+1.75, 0.0, 0.0, 0.0, 0.0, -180.0, 0.0, 0.35, 0.35, 0.35, state[3][1], state[3][2], state[3][3], 55, false, true, 2, false, nil, nil, false)
                        else
                            DrawMarker(20, boneCoords.x, boneCoords.y, boneCoords.z+1.25, 0.0, 0.0, 0.0, 0.0, -180.0, 0.0, 0.35, 0.35, 0.35, state[3][1], state[3][2], state[3][3], 55, false, true, 2, false, nil, nil, false)
                        end
                    else
                        DrawMarker(25, tPos.x, tPos.y, tPos.z - 0.950, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.0, state[3][1], state[3][2], state[3][3], 55, false, true, 2, false, nil, nil, false)
                        end
                    end
                end
            end
        end
    end
end)

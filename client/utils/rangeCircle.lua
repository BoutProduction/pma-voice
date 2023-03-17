AddEventHandler('pma-voice:setTalkingMode', function(mode)
    local distance = Cfg.voiceModes[mode]
    DrawVoiceDistanceMarker(distance[1], distance[3], 150)
    ShowNotification(string.format('New Range: ~h~%s', distance[2] .. ' ('  .. distance[1]*2 .. 'm)')
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

function ShowNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, true)
end


CreateThread(function()
    local state = Cfg.displayOnTalk
    while Wait(1) do
        if not state[1] then break
        else
            local pPed = PlayerPedId()
            local pPos = GetEntityCoords(pPed)
            local isTalking = NetworkIsPlayerTalking(PlayerId())

            if isTalking then
                for _, v in ipairs(GetActivePlayers()) do
                    if v ~= PlayerId() then
                        local tPed = GetPlayerPed(v)
                        local tPos = GetEntityCoords(tPed)
                        if Vdist(pPos, tPos) < state[2] then
                            DrawMarker(25, tPos.x, tPos.y, tPos.z - 0.950, 0, 0, 0, 0, 0, 0, 0.75, 0.75, 0.0, 52, 204, 255, 55, false, true, 2, false, nil, nil, false)
                        end
                    end
                end
            end
        end
    end
end)

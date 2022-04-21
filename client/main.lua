ESX = nil
local PlayerData = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end
    TPS()
    PlayerData = ESX.GetPlayerData()
end)

function TPS()
    Citizen.CreateThread(function()
    
        while true do
            Citizen.Wait(4)
            local player = GetPlayerPed(-1)

            for location, val in pairs(Config.Teleports) do

                local Enter = val['Enter']
                local Exit = val['Exit']
                local Trabajo = val['Job']
                local distancecheckenter, distancecheckexit = GetDistanceBetweenCoords(GetEntityCoords(player), Enter['x'], Enter['y'], Enter['z'], true), GetDistanceBetweenCoords(GetEntityCoords(player), Exit['x'], Exit['y'], Exit['z'], true)
                local playervehicle = IsPedInAnyVehicle(player, false)

                if distancecheckenter <= 7.5 then
                    if Trabajo ~= 'none' then
                        if PlayerData.job.name == Trabajo then
                            Draw3D(Enter['Index'], 27, Enter['x'], Enter['y'], Enter['z'])
                            if distancecheckenter <= 1.2 then
                                if not playervehicle then
                                if IsControlJustPressed(0, Config.Key) then
                                    Teleport(val, 'enter')
                                    end
                                end
                            end
                        end
                    else
                        Draw3D(Enter['Index'], 27, Enter['x'], Enter['y'], Enter['z'])
                        if distancecheckenter <= 1.2 then
                            if not playervehicle then
                            if IsControlJustPressed(0, Config.Key) then
                                Teleport(val, 'enter')
                                end
                            end
                        end
                    end
                end
                if distancecheckexit <= 7.5 then
                    if Trabajo ~= 'none' then
                        if PlayerData.job.name == Trabajo then
                            Draw3D(Exit['Index'], 27, Exit['x'], Exit['y'], Exit['z'])
                            if distancecheckexit <= 1.2 then
                                if not playervehicle then
                                if IsControlJustPressed(0, Config.Key) then
                                    Teleport(val, 'exit')
                                    end 
                                end
                            end
                        end
                    else
                        Draw3D(Exit['Index'], 27, Exit['x'], Exit['y'], Exit['z'])
                        if distancecheckexit <= 1.2 then
                            if not playervehicle then
                            if IsControlJustPressed(0, Config.Key) then
                                Teleport(val, 'exit')
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

function Teleport(table, location, NotificationEnter, NotificationExit)
-- Locals for notifcations
local NotificationEnter = "Has ~g~entrado~w~"
local NotificationExit = "Has ~r~salido~w~"
-- Locals for notifcations

    if location == 'enter' then
        ESX.Game.Teleport(PlayerPedId(), table['Exit'])
        Citizen.Wait(50)
        ESX.ShowNotification(NotificationEnter)
    else
        ESX.Game.Teleport(PlayerPedId(), table['Enter'])
        Citizen.Wait(350)
        ESX.ShowNotification(NotificationExit)
    end
end


function Draw3D(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

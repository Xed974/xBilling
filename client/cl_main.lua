ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('facture')
AddEventHandler('facture', function(society)
    local target, dst = ESX.Game.GetClosestPlayer()

    if target ~= -1 and dst <= 2.0 then
		local amount = KeyboardInput("", "Montant", 11)
		local raison = KeyboardInput("", "Raison", 255)
        
        if raison == "Raison" then return else
            if amount == "Montant" then return else
                if amount ~= "" then
                    if raison ~= "" then
                        TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                        Wait(5000)
                        ClearPedTasks(PlayerPedId())
                        TriggerServerEvent("xBilling:facture", GetPlayerServerId(target), raison, amount, society)
                        ESX.ShowNotification("Facture mise avec ~g~succès~s~.")
                    else
                        ESX.ShowNotification("~r~Raison invalide.")
                    end
                else
                    ESX.ShowNotification("~r~Montant invalide.")
                end
            end
        end
    else
        ESX.ShowNotification("~r~Personne à proximité de vous.")
    end
end)

--- Xed#1188
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local resultClient = {}
RegisterNetEvent('xBilling:resultfacture')
AddEventHandler('xBilling:resultfacture', function(resultServer) resultClient = resultServer end)

local open = false
local mainMenu = RageUI.CreateMenu("Facture", "Interaction", nil, nil, "root_cause5", "img_red")
local facture = RageUI.CreateSubMenu(mainMenu, "Facture", "Interaction")
mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
end

function MenuBilling()
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while true do 
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Voir mes factures", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            TriggerServerEvent("xBilling:tcheckfacture")
                        end
                    }, facture)
                end)
                RageUI.IsVisible(facture, function()
                    for k,v in pairs(resultClient) do
                        RageUI.Button(("Raison: ~g~%s~s~"):format(v.raison), "Appuyez sur ~r~[ENTER]~s~ pour payer", {RightLabel = ("%s~g~$~s~"):format(v.amount)}, true, {
                            onSelected = function()
                                local payment = KeyboardInput("", "C pour carte bancaire / E pour espèce", 255)
                                if payment == "C" then
                                    TriggerServerEvent("xBilling:payercb", v.amount, v.society, v.id, v.sender)
                                    TriggerServerEvent("xBilling:tcheckfacture")
                                elseif payment == "E" then
                                    TriggerServerEvent("xBilling:payere", v.amount, v.society, v.id, v.sender)
                                    TriggerServerEvent("xBilling:tcheckfacture")
                                else
                                    ESX.ShowNotification("~r~Moyen de paiment invalide.")
                                end
                            end
                        })
                    end
                end)
            end
        end)
    end
end

--

RegisterCommand("billingmenu", function()
    MenuBilling()
end)

RegisterKeyMapping('billingmenu', 'Menu Facture', 'keyboard', 'o')

--

--- Xed#1188
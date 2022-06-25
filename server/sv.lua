ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('xBilling:facture')
AddEventHandler('xBilling:facture', function(target, raison, amount, society)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    local xIdentifier = xPlayer.getIdentifier()
    local tIdentifier = xTarget.getIdentifier()

    if (not xIdentifier) then return end
        if (not tIdentifier) then return end
            MySQL.Async.execute("INSERT INTO xBilling (identifier, sender, raison, amount, society) VALUES (@identifier, @sender, @raison, @amount, @society)", {
                ['@identifier'] = tIdentifier,
                ['@sender'] = xIdentifier,
                ['@raison'] = raison,
                ['@amount'] = amount,
                ['society'] = society
            }, function()end)
            TriggerClientEvent('esx:showNotification', xTarget.source, 'Vous avez reçu une facture !')
end)

--
local resultServer = {}
RegisterNetEvent('xBilling:tcheckfacture')
AddEventHandler('xBilling:tcheckfacture', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if (not xPlayer) then return end
        MySQL.Async.fetchAll("SELECT * FROM xBilling WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function(result)
            if (result) then
                resultServer = result
                TriggerClientEvent('xBilling:resultfacture', source, resultServer)
            end
        end)
end)

RegisterNetEvent('xBilling:payercb')
AddEventHandler('xBilling:payercb', function(amount, society, id, sender)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(sender)
    
    if (not xPlayer) then return end
        if xPlayer.getAccount('bank').money >= amount then
            MySQL.Async.execute("DELETE FROM xBilling WHERE id = "..id.."", {}, function(rowsChanged)
                TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
                    xPlayer.removeAccountMoney('bank', amount)
                    account.addMoney(amount)
                    TriggerClientEvent('esx:showAdvancedNotification', source, 'Fleeca Bank', 'Virement', ('Virement de ~g~%s$~s~ effectué avec succès !'):format(amount), 'CHAR_BANK_FLEECA', 1)
                    TriggerClientEvent('esx:showAdvancedNotification', xTarget.source, 'Fleeca Bank', 'Virement', ('L\'entreprise à reçu un virement de ~g~%s$~s~ !'):format(amount), 'CHAR_BANK_FLEECA', 1)
                end)
            end)
        else
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Fleeca Bank', 'Paiement refusé', 'Vous n\'avez pas assez d\'argent sur votre compte !', 'CHAR_BANK_FLEECA', 1)
        end
end)

RegisterNetEvent('xBilling:payere')
AddEventHandler('xBilling:payere', function(amount, society, id, sender)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(sender)

    if (not xPlayer) then return end
        if xPlayer.getMoney() >= amount then
            MySQL.Async.execute("DELETE FROM xBilling WHERE id = "..id.."", {}, function(rowsChanged)
                TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
                    xPlayer.removeMoney(amount)
                    account.addMoney(amount)
                    TriggerClientEvent('esx:showNotification', source, ('Paiment de ~g~%s$~s~ effectué avec succès !'):format(amount))
                    TriggerClientEvent('esx:showNotification', xTarget.source, ('Vous avez reçu un paiment de ~g~%s$~s~ !'):format(amount))
                end)
            end)
        else
            TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas assez d\'argent sur vous !')
        end
end)

--- Xed#1188

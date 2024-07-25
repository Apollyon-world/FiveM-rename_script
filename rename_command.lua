local ESX = nil
local QBCore = nil

-- Function to detect and initialize the framework
Citizen.CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        ESX = exports["es_extended"]:getSharedObject()
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
    end
end)

-- Function to check if a player is an admin
local function isAdmin(source)
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer.getGroup() == 'admin' then
            return true
        end
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            for _, perm in pairs(QBConfig.Server.Permissions) do
                if Player.PlayerData.metadata[perm] then
                    return true
                end
            end
        end
    end
    return false
end

-- Function to rename a player
local function renamePlayer(source, targetId, newFirstName, newLastName)
    if ESX then
        local targetPlayer = ESX.GetPlayerFromId(targetId)
        if targetPlayer then
            exports.oxmysql:execute('UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?', {newFirstName, newLastName, targetPlayer.identifier}, function(result)
                if result then
                    if result.affectedRows and result.affectedRows > 0 then
                        targetPlayer.setName(newFirstName .. ' ' .. newLastName)
                        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player renamed successfully.' } })
                        TriggerClientEvent('chat:addMessage', targetId, { args = { '^1SYSTEM', 'Your name has been changed to ' .. newFirstName .. ' ' .. newLastName } })
                    else
                        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Failed to rename player.' } })
                    end
                else
                    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'An error occurred while updating player name.' } })
                end
            end)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not found.' } })
        end
    elseif QBCore then
        local targetPlayer = QBCore.Functions.GetPlayer(targetId)
        if targetPlayer then
            exports.oxmysql:execute('UPDATE players SET firstname = ?, lastname = ? WHERE citizenid = ?', {newFirstName, newLastName, targetPlayer.PlayerData.citizenid}, function(result)
                if result then
                    if result.affectedRows and result.affectedRows > 0 then
                        targetPlayer.Functions.SetMetaData('firstname', newFirstName)
                        targetPlayer.Functions.SetMetaData('lastname', newLastName)
                        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player renamed successfully.' } })
                        TriggerClientEvent('chat:addMessage', targetId, { args = { '^1SYSTEM', 'Your name has been changed to ' .. newFirstName .. ' ' .. newLastName } })
                    else
                        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Failed to rename player.' } })
                    end
                else
                    TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'An error occurred while updating player name.' } })
                end
            end)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not found.' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Framework not detected.' } })
    end
end

-- Register the command /rename
RegisterCommand('rename', function(source, args, rawCommand)
    if isAdmin(source) then
        local targetId = tonumber(args[1])
        local newFirstName = args[2]
        local newLastName = args[3]

        if targetId and newFirstName and newLastName then
            renamePlayer(source, targetId, newFirstName, newLastName)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /rename [playerId] [newFirstName] [newLastName]' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You do not have permission to use this command.' } })
    end
end, false)

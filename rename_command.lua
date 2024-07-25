ESX = nil
ESX = exports["es_extended"]:getSharedObject()

-- Fonction pour vérifier si un joueur est admin
local function isAdmin(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.getGroup() == 'admin' then
        return true
    end
    return false
end

-- Commande /rename
RegisterCommand('rename', function(source, args, rawCommand)
    if isAdmin(source) then
        local targetId = tonumber(args[1])
        local newFirstName = args[2]
        local newLastName = args[3]

        if targetId and newFirstName and newLastName then
            -- Récupération du joueur cible
            local targetPlayer = ESX.GetPlayerFromId(targetId)
            if targetPlayer then
                -- Mise à jour des noms dans la base de données
                exports.oxmysql:execute('UPDATE users SET firstname = ?, lastname = ? WHERE identifier = ?', {newFirstName, newLastName, targetPlayer.identifier}, function(result)
                    if result then
                        if result.affectedRows and result.affectedRows > 0 then
                            -- Met à jour le nom du joueur en mémoire (si nécessaire)
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
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /rename [playerId] [newFirstName] [newLastName]' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You do not have permission to use this command.' } })
    end
end, false)

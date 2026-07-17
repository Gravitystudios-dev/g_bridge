GravityAdapters = GravityAdapters or { server = {}, client = {} }

GravityAdapters.server.qb = function()
    local QBCore = exports['qb-core']:GetCoreObject()

    return {
        core = QBCore,
        getPlayer = function(source) return QBCore.Functions.GetPlayer(source) end,
        getIdentifier = function(player) return player.PlayerData.citizenid end,
        getName = function(player)
            local charinfo = player.PlayerData.charinfo
            return ('%s %s'):format(charinfo.firstname or '', charinfo.lastname or ''):gsub('^%s*(.-)%s*$', '%1')
        end,
        getGroups = function(player)
            return QBCore.Functions.GetPermission(player.PlayerData.source) or {}
        end,
        hasGroup = function(player, group)
            return QBCore.Functions.HasPermission(player.PlayerData.source, group)
        end,
        getJob = function(player)
            local job = player.PlayerData.job
            return { name = job.name, label = job.label, grade = tonumber(job.grade.level or job.grade), gradeName = job.grade.name, onduty = job.onduty }
        end,
        setJob = function(player, job, grade) player.Functions.SetJob(job, grade) end,
        setJobDuty = function(player, onDuty) return player.Functions.SetJobDuty(onDuty) end,
        getJobs = function() return QBCore.Shared.Jobs or {} end,
        getDateOfBirth = function(player) return player.PlayerData.charinfo and player.PlayerData.charinfo.birthdate end,
        setMetadata = function(player, key, value) player.Functions.SetMetaData(key, value) return true end,
        getMoney = function(player, account) return player.PlayerData.money[account == 'cash' and 'cash' or account] or 0 end,
        addMoney = function(player, account, amount, reason) return player.Functions.AddMoney(account == 'cash' and 'cash' or account, amount, reason) end,
        removeMoney = function(player, account, amount, reason) return player.Functions.RemoveMoney(account == 'cash' and 'cash' or account, amount, reason) end,
        getItem = function(player, item) return player.Functions.GetItemByName(item) end,
        getInventory = function(player) return player.PlayerData.items or {} end,
        addItem = function(player, item, amount, metadata) return player.Functions.AddItem(item, amount, false, metadata) end,
        removeItem = function(player, item, amount, metadata) return player.Functions.RemoveItem(item, amount, false, metadata) end,
        canCarryItem = function(player, item, amount)
            if Gravity.ResourceStarted('ox_inventory') then
                return exports.ox_inventory:CanCarryItem(player.PlayerData.source, item, amount)
            end
            return true
        end,
        registerCallback = function(name, callback) QBCore.Functions.CreateCallback(name, callback) end,
        registerUsableItem = function(item, callback) QBCore.Functions.CreateUseableItem(item, callback) end,
    }
end

GravityAdapters = GravityAdapters or { server = {}, client = {} }

GravityAdapters.server.esx = function()
    local ESX = exports['es_extended']:getSharedObject()

    return {
        core = ESX,
        getPlayer = function(source) return ESX.GetPlayerFromId(source) end,
        getIdentifier = function(player)
            return player.identifier or player.getIdentifier()
        end,
        getName = function(player)
            return player.getName()
        end,
        getGroups = function(player)
            local group = player.getGroup and player.getGroup() or 'user'
            return { [group] = true }
        end,
        hasGroup = function(player, group)
            return player.getGroup and player.getGroup() == group or false
        end,
        getJob = function(player)
            local job = player.getJob()
            return { name = job.name, label = job.label, grade = tonumber(job.grade), gradeName = job.grade_name, onduty = true }
        end,
        setJob = function(player, job, grade) player.setJob(job, grade) end,
        setJobDuty = function(player, onDuty)
            player.setJob(player.job.name, player.job.grade, onDuty)
            return true
        end,
        getJobs = function() return ESX.GetJobs and ESX.GetJobs() or ESX.Jobs or {} end,
        getDateOfBirth = function(player) return player.get and player.get('dateofbirth') or nil end,
        setMetadata = function(player, key, value)
            if not player.setMeta then return false end
            player.setMeta(key, value)
            return true
        end,
        getMoney = function(player, account)
            if account == 'cash' then return player.getMoney() end
            local data = player.getAccount(account == 'bank' and 'bank' or account)
            return data and data.money or 0
        end,
        addMoney = function(player, account, amount, reason)
            if account == 'cash' then return player.addMoney(amount, reason) end
            return player.addAccountMoney(account == 'bank' and 'bank' or account, amount, reason)
        end,
        removeMoney = function(player, account, amount, reason)
            if account == 'cash' then return player.removeMoney(amount, reason) end
            return player.removeAccountMoney(account == 'bank' and 'bank' or account, amount, reason)
        end,
        getItem = function(player, item) return player.getInventoryItem(item) end,
        getInventory = function(player) return player.getInventory() end,
        addItem = function(player, item, amount, metadata) return player.addInventoryItem(item, amount, metadata) end,
        removeItem = function(player, item, amount, metadata) return player.removeInventoryItem(item, amount, metadata) end,
        canCarryItem = function(player, item, amount) return player.canCarryItem(item, amount) end,
        registerCallback = function(name, callback) ESX.RegisterServerCallback(name, callback) end,
        registerUsableItem = function(item, callback) ESX.RegisterUsableItem(item, callback) end,
    }
end

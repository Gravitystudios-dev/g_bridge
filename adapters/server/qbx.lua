GravityAdapters = GravityAdapters or { server = {}, client = {} }

GravityAdapters.server.qbx = function()
    local QBox = exports.qbx_core
    local QBCore = exports['qb-core']:GetCoreObject()

    local function bridgePlayer(player)
        return QBCore.Functions.GetPlayer(player.PlayerData.source)
    end

    return {
        core = QBox,
        getPlayer = function(source) return QBox:GetPlayer(source) end,
        getIdentifier = function(player) return player.PlayerData.citizenid end,
        getName = function(player)
            local charinfo = player.PlayerData.charinfo or {}
            return ('%s %s'):format(charinfo.firstname or '', charinfo.lastname or ''):gsub('^%s*(.-)%s*$', '%1')
        end,
        getGroups = function(player)
            return QBox:GetPermission(player.PlayerData.source) or {}
        end,
        hasGroup = function(player, group)
            return QBox:HasPermission(player.PlayerData.source, group)
        end,
        getJob = function(player)
            local job = player.PlayerData.job or {}
            return {
                name = job.name,
                label = job.label,
                grade = tonumber(job.grade and (job.grade.level or job.grade) or 0),
                gradeName = job.grade and job.grade.name,
                onduty = job.onduty,
            }
        end,
        setJob = function(player, job, grade) return QBox:SetJob(player.PlayerData.source, job, grade) end,
        setJobDuty = function(player, onDuty)
            local compatibilityPlayer = bridgePlayer(player)
            return compatibilityPlayer and compatibilityPlayer.Functions.SetJobDuty(onDuty) or false
        end,
        getJobs = function() return QBox:GetJobs() or {} end,
        getDateOfBirth = function(player) return player.PlayerData.charinfo and player.PlayerData.charinfo.birthdate end,
        setMetadata = function(player, key, value)
            local compatibilityPlayer = bridgePlayer(player)
            if not compatibilityPlayer then return false end
            compatibilityPlayer.Functions.SetMetaData(key, value)
            return true
        end,
        getMoney = function(player, account) return QBox:GetMoney(player.PlayerData.source, account) or 0 end,
        addMoney = function(player, account, amount, reason) return QBox:AddMoney(player.PlayerData.source, account, amount, reason) end,
        removeMoney = function(player, account, amount, reason) return QBox:RemoveMoney(player.PlayerData.source, account, amount, reason) end,
        getItem = function(player, item) return bridgePlayer(player).Functions.GetItemByName(item) end,
        getInventory = function(player) return bridgePlayer(player).PlayerData.items or {} end,
        addItem = function(player, item, amount, metadata) return bridgePlayer(player).Functions.AddItem(item, amount, false, metadata) end,
        removeItem = function(player, item, amount, metadata) return bridgePlayer(player).Functions.RemoveItem(item, amount, false, metadata) end,
        canCarryItem = function(player, item, amount)
            if Gravity.ResourceStarted('ox_inventory') then
                return exports.ox_inventory:CanCarryItem(player.PlayerData.source, item, amount)
            end
            return true
        end,
        registerCallback = function(name, callback) QBCore.Functions.CreateCallback(name, callback) end,
        registerUsableItem = function(item, callback) QBox:CreateUseableItem(item, callback) end,
    }
end

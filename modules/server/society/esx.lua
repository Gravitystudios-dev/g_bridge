local function account(job) return exports.esx_addonaccount:GetSharedAccount(('society_%s'):format(job)) end
Gravity.RegisterServerProvider('society', 'esx_addonaccount', {
    getBalance = function(_, job) local value = account(job) return value and value.money or 0 end,
    addMoney = function(_, job, amount) local value = account(job) if not value then return false end value.addMoney(amount) return true end,
    removeMoney = function(_, job, amount) local value = account(job) if not value then return false end value.removeMoney(amount) return true end,
})

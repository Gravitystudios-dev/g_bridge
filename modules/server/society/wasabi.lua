Gravity.RegisterServerProvider('society', 'wasabi_banking', {
    getBalance = function(_, job) return exports.wasabi_banking:GetAccountBalance(job, 'society') or 0 end,
    addMoney = function(_, job, amount) return exports.wasabi_banking:AddMoney('society', job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports.wasabi_banking:RemoveMoney('society', job, amount) ~= false end,
})

Gravity.RegisterServerProvider('society', 'snipe-banking', {
    getBalance = function(_, job) return exports['snipe-banking']:GetAccountBalance(job) or 0 end,
    addMoney = function(_, job, amount) return exports['snipe-banking']:AddMoneyToAccount(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['snipe-banking']:RemoveMoneyFromAccount(job, amount) ~= false end,
})

Gravity.RegisterServerProvider('society', 'qb-banking', {
    getBalance = function(_, job) local value = exports['qb-banking']:GetAccount(job) return value and (value.account_balance or value.balance) or 0 end,
    addMoney = function(_, job, amount) return exports['qb-banking']:AddMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['qb-banking']:RemoveMoney(job, amount) ~= false end,
})

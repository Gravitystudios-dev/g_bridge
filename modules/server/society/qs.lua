Gravity.RegisterServerProvider('society', 'qs-banking', {
    getBalance = function(_, job) return exports['qs-banking']:GetAccountBalance(job) or 0 end,
    addMoney = function(_, job, amount) return exports['qs-banking']:AddMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['qs-banking']:RemoveMoney(job, amount) ~= false end,
})

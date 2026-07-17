Gravity.RegisterServerProvider('society', 'kartik-banking', {
    getBalance = function(_, job) return exports['kartik-banking']:GetAccountMoney(job) or 0 end,
    addMoney = function(_, job, amount) return exports['kartik-banking']:AddAccountMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['kartik-banking']:RemoveAccountMoney(job, amount) ~= false end,
})

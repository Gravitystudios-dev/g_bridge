Gravity.RegisterServerProvider('society', 'Renewed-Banking', {
    getBalance = function(_, job) return exports['Renewed-Banking']:getAccountMoney(job) or 0 end,
    addMoney = function(_, job, amount) return exports['Renewed-Banking']:addAccountMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['Renewed-Banking']:removeAccountMoney(job, amount) ~= false end,
})

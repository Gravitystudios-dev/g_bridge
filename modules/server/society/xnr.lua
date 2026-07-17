Gravity.RegisterServerProvider('society', 'xnr-bossmenu', {
    getBalance = function(_, job) local value = exports['xnr-bossmenu']:getSociety(job) return value and (value.balance or value.money) or 0 end,
    addMoney = function(_, job, amount) return exports['xnr-bossmenu']:addMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['xnr-bossmenu']:removeMoney(job, amount) ~= false end,
})

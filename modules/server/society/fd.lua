Gravity.RegisterServerProvider('society', 'fd_banking', {
    getBalance = function(_, job) local value = exports.fd_banking:GetAccount(job) return value and (value.balance or value.money) or 0 end,
    addMoney = function(_, job, amount) return exports.fd_banking:AddMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports.fd_banking:RemoveMoney(job, amount) ~= false end,
})

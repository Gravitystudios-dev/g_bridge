Gravity.RegisterServerProvider('society', 'p_banking', {
    getBalance = function(_, job) return exports.p_banking:getAccountMoney(job) or 0 end,
    addMoney = function(_, job, amount) return exports.p_banking:addAccountMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports.p_banking:removeAccountMoney(job, amount) ~= false end,
})

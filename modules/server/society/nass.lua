Gravity.RegisterServerProvider('society', 'nass_bossmenu', {
    getBalance = function(_, job) return exports.nass_bossmenu:getAccount(job) or 0 end,
    addMoney = function(_, job, amount) exports.nass_bossmenu:addMoney(job, amount) return true end,
    removeMoney = function(_, job, amount) return exports.nass_bossmenu:removeMoney(job, amount) ~= false end,
})

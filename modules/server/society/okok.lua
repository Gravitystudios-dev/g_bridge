Gravity.RegisterServerProvider('society', 'okokBanking', {
    getBalance = function(_, job) return exports.okokBanking:GetAccount(job) or 0 end,
    addMoney = function(_, job, amount) exports.okokBanking:AddMoney(job, amount) return true end,
    removeMoney = function(_, job, amount) exports.okokBanking:RemoveMoney(job, amount) return true end,
})

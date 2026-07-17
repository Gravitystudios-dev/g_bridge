Gravity.RegisterServerProvider('society', 'prism_banking', {
    getBalance = function(_, job) return exports.prism_banking:GetSocietyBalance(job) or 0 end,
    addMoney = function(_, job, amount) exports.prism_banking:AddSocietyMoney(job, amount) return true end,
    removeMoney = function(_, job, amount) exports.prism_banking:RemoveSocietyMoney(job, amount) return true end,
})

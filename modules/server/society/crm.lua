Gravity.RegisterServerProvider('society', 'crm-banking', {
    getBalance = function(_, job) return exports['crm-banking']:getSocietyMoney(job) or 0 end,
    addMoney = function(_, job, amount) return exports['crm-banking']:addSocietyMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['crm-banking']:removeSocietyMoney(job, amount) ~= false end,
})

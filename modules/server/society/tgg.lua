Gravity.RegisterServerProvider('society', 'tgg-banking', {
    getBalance = function(_, job) return exports['tgg-banking']:GetSocietyAccountMoney(job) or 0 end,
    addMoney = function(_, job, amount) return exports['tgg-banking']:AddSocietyMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports['tgg-banking']:RemoveSocietyMoney(job, amount) ~= false end,
})

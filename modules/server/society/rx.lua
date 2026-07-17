Gravity.RegisterServerProvider('society', 'RxBanking', {
    getBalance = function(_, job) local value = exports.RxBanking:GetSocietyAccount(job) if type(value) == 'number' then return value end return value and (value.money or value.balance) or 0 end,
    addMoney = function(_, job, amount) return exports.RxBanking:AddSocietyMoney(job, amount) ~= false end,
    removeMoney = function(_, job, amount) return exports.RxBanking:RemoveSocietyMoney(job, amount) ~= false end,
})

-- Unified personal banking built on the framework cash and bank accounts.
Gravity.RegisterServerProvider('banking', 'framework', {
    getBalance = function(source)
        return Bridge.GetMoney(source, 'bank')
    end,
    deposit = function(source, amount, reason)
        amount = tonumber(amount)
        if not amount or amount <= 0 then return false end

        local transactionReason = reason or 'bank deposit'
        if not Bridge.RemoveMoney(source, 'cash', amount, transactionReason) then return false end
        if Bridge.AddMoney(source, 'bank', amount, transactionReason) then return true end

        Bridge.AddMoney(source, 'cash', amount, 'bank deposit rollback')
        return false
    end,
    withdraw = function(source, amount, reason)
        amount = tonumber(amount)
        if not amount or amount <= 0 then return false end

        local transactionReason = reason or 'bank withdrawal'
        if not Bridge.RemoveMoney(source, 'bank', amount, transactionReason) then return false end
        if Bridge.AddMoney(source, 'cash', amount, transactionReason) then return true end

        Bridge.AddMoney(source, 'bank', amount, 'bank withdrawal rollback')
        return false
    end,
})

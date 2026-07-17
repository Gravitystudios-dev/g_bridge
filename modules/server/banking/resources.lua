-- Personal balances remain owned by the framework; these providers add compatibility
-- with banking resources and, where available, their transaction history.
local function transfer(source, amount, reason, from, to)
    amount = tonumber(amount)
    if not amount or amount <= 0 then return false end

    if not Bridge.RemoveMoney(source, from, amount, reason) then return false end
    if Bridge.AddMoney(source, to, amount, reason) then return true end

    Bridge.AddMoney(source, from, amount, ('%s rollback'):format(reason or 'bank transaction'))
    return false
end

local function frameworkProvider()
    return {
        getBalance = function(source) return Bridge.GetMoney(source, 'bank') end,
        deposit = function(source, amount, reason) return transfer(source, amount, reason or 'bank deposit', 'cash', 'bank') end,
        withdraw = function(source, amount, reason) return transfer(source, amount, reason or 'bank withdrawal', 'bank', 'cash') end,
    }
end

-- qb-banking and okokBanking use the framework player bank account for personal funds.
Gravity.RegisterServerProvider('banking', 'qb-banking', frameworkProvider())
Gravity.RegisterServerProvider('banking', 'okokBanking', frameworkProvider())

local function renewedProvider(resource)
    local provider = frameworkProvider()

    local function addTransaction(source, amount, reason, transactionType)
        local identifier = Bridge.GetIdentifier(source)
        if not identifier then return end
        local name = Bridge.GetName(source) or identifier
        exports[resource]:handleTransaction(
            identifier,
            ('Personal Account / %s'):format(identifier),
            amount,
            reason or 'Gravity Bridge transaction',
            transactionType == 'deposit' and name or 'Bank',
            transactionType == 'deposit' and 'Bank' or name,
            transactionType
        )
    end

    provider.deposit = function(source, amount, reason)
        local success = transfer(source, amount, reason or 'bank deposit', 'cash', 'bank')
        if success then addTransaction(source, amount, reason or 'Bank deposit', 'deposit') end
        return success
    end

    provider.withdraw = function(source, amount, reason)
        local success = transfer(source, amount, reason or 'bank withdrawal', 'bank', 'cash')
        if success then addTransaction(source, amount, reason or 'Bank withdrawal', 'withdraw') end
        return success
    end

    return provider
end

Gravity.RegisterServerProvider('banking', 'Renewed-Banking', renewedProvider('Renewed-Banking'))
Gravity.RegisterServerProvider('banking', 'renewed-banking', renewedProvider('renewed-banking'))

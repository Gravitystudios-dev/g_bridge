Gravity.ClientProviders = Gravity.ClientProviders or {}
Gravity.ServerProviders = Gravity.ServerProviders or {}

function Gravity.RegisterClientProvider(category, resource, provider)
    assert(type(category) == 'string' and category ~= '', 'Provider category is required.')
    assert(type(resource) == 'string' and resource ~= '', 'Provider resource is required.')
    assert(type(provider) == 'table', 'Client provider must be a table.')
    Gravity.ClientProviders[category] = Gravity.ClientProviders[category] or {}
    Gravity.ClientProviders[category][resource] = provider
end

function Gravity.RegisterServerProvider(category, resource, provider)
    assert(type(category) == 'string' and category ~= '', 'Provider category is required.')
    assert(type(resource) == 'string' and resource ~= '', 'Provider resource is required.')
    assert(type(provider) == 'table', 'Server provider must be a table.')
    Gravity.ServerProviders[category] = Gravity.ServerProviders[category] or {}
    Gravity.ServerProviders[category][resource] = provider
end

function Gravity.GetClientProvider(category, configured, order)
    local resource = configured
    if resource == 'auto' then
        for _, candidate in ipairs(order) do
            if Gravity.ResourceStarted(candidate) then resource = candidate break end
        end
    end
    if not resource or resource == 'auto' or resource == 'none' or not Gravity.ResourceStarted(resource) then return nil end
    return Gravity.ClientProviders[category] and Gravity.ClientProviders[category][resource], resource
end

function Gravity.GetServerProvider(category, configured, order)
    local resource = configured
    if resource == 'auto' then
        for _, candidate in ipairs(order) do
            if Gravity.ResourceStarted(candidate) then resource = candidate break end
        end
        if resource == 'auto' then resource = 'framework' end
    end
    if resource == 'framework' then return Gravity.ServerProviders[category] and Gravity.ServerProviders[category].framework, resource end
    if not resource or resource == 'auto' or not Gravity.ResourceStarted(resource) then return nil end
    return Gravity.ServerProviders[category] and Gravity.ServerProviders[category][resource], resource
end

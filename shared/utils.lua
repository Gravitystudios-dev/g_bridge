Gravity = Gravity or {}

--- Returns a translated string, or the key when it is missing.
function Gravity.Translate(key, ...)
    local selected = Locales[Config.Locale] or {}
    local value = selected[key] or key
    if select('#', ...) > 0 then return value:format(...) end
    return value
end

function Gravity.Debug(message, ...)
    if Config.Debug then
        print(('[gravity_bridge] ' .. message):format(...))
    end
end

function Gravity.ResourceStarted(resource)
    return resource and GetResourceState(resource) == 'started'
end

function Gravity.AssertServer()
    if IsDuplicityVersion() then return end
    error('This bridge method can only be used on the server.', 3)
end

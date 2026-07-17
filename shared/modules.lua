Gravity = Gravity or {}
Gravity.Modules = Gravity.Modules or {}

--- Registers a public bridge module and makes it retrievable through GetModule/Bridge.
---@param name string
---@param module table
function Gravity.RegisterModule(name, module)
    assert(type(name) == 'string' and name ~= '', 'Module name is required.')
    assert(type(module) == 'table', ('Module "%s" must be a table.'):format(name))
    Gravity.Modules[name] = module
    TriggerEvent('gravity_bridge:moduleRegistered', name, module)
    return module
end

function Gravity.GetModule(name)
    return Gravity.Modules[name]
end

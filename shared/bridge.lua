Bridge = Bridge or {}
Bridge.Framework = nil
Bridge.Adapter = nil

function Bridge.GetFramework()
    return Bridge.Framework
end

function Bridge.IsESX()
    return Bridge.Framework == 'esx'
end

function Bridge.IsQB()
    return Bridge.Framework == 'qb' or Bridge.Framework == 'qbx'
end

function Bridge.IsQBox()
    return Bridge.Framework == 'qbx'
end

function Bridge.GetModule(name)
    return Gravity.GetModule(name)
end

function Bridge.Translate(key, ...)
    return Gravity.Translate(key, ...)
end

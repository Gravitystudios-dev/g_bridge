Gravity.RegisterClientProvider('input', 'ox_lib', {
    open = function(title, fields)
        return exports.ox_lib:inputDialog(title, fields)
    end,
})

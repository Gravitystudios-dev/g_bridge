Gravity.RegisterClientProvider('textui', 'ox_lib', {
    show = function(text, options)
        return exports.ox_lib:showTextUI(text, options)
    end,
    hide = function()
        return exports.ox_lib:hideTextUI()
    end,
})

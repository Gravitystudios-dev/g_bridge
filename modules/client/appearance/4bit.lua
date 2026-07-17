Gravity.RegisterClientProvider('appearance', '4bit_appearance', {
    open = function()
        return exports['4bit_appearance']:openMenu()
    end,
})

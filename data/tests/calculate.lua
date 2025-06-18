---@diagnostic disable: undefined-global
SMODS.Joker { 

    -- Key
    key = 'calculate',
    loc_txt = {
        name = 'Broken Calculate',
    },

    -- Atlas
    pos = { x = 1, y = 0 },
    
    -- Ingame config
    unlocked = true, 
    discovered = true,
    rarity = 1,

    calculate = function(self, card, context)
        if context.joker_main then
            alkjdalkjsd()
        end
    end
    
}
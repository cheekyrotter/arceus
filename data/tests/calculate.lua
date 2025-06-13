---@diagnostic disable: undefined-global
SMODS.Joker { 

    -- Key
    key = 'calculate',
    loc_txt = {
        name = 'Broken Calculate',
    },

    -- Vars
    config = { extra = { xmult = 1.5, cost = 1, triggers = 0, reset_triggers = 5} },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.cost, card.ability.extra.triggers, card.ability.extra.reset_triggers, card.ability.extra.reset_triggers - card.ability.extra.triggers } }
    end,

    -- Atlas
    -- atlas = 'Jokers',
    pos = { x = 1, y = 0 },
    
    -- Ingame config
    cost = 6,
    unlocked = true, 
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    rarity = 3,

    calculate = function(self, card, context)

        if context.final_scoring_step then
            print(test)
        end
    end
    
}
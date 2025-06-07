function Arceus.safe_call(func, self, context, extra_arg)
    local result = nil
        if Arceus.get_config_entry("safe_calc", self.config.center.mod) == true then
            local success, result = pcall(function() return func(self, context) end)
            if not success then
                sendErrorMessage("Caught error:"..result)
                SMODS.calculate_effect({message = "Fatal error, removing card!", colour = G.C.RED}, self)
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        self.getting_sliced = true
                        self:start_dissolve()
                        return true
                    end
                }))
            end
            return(result)
        end
    return(result)
end



local methods = {"calculate_joker", "remove", "add_to_deck", "update", "load", "calculate_dollar_bonus", "can_use_consumeable", "use_consumeable", "redeem"}

for _, name in pairs(methods) do
    local original = Card[name]
    sendInfoMessage("ADDING METHOD ", name)
    Card[name] = function(card, arg1, arg2)
        if card.config.center.mod then
            return Arceus.safe_call(original, card, arg1, arg2)
        else
            return original(card, arg1, arg2)
        end
    end
end
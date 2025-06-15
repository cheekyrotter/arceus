function Arceus.safe_call(func, name, self, context, extra_arg) -- Wrapper for card-based functions
    local result = nil
    local STP = loadStackTracePlus()
    local success, result = xpcall(function() return func(self, context) end, STP.stacktrace)
    if not success then
        local error_message = "Error in card '"..self.config.center.key.."' using function '"..name.."'"
        Arceus.make_overlay(Arceus.error_popup_ui({{summary = error_message, traceback = result}}))
        if Arceus.config.remove_cards == true then
            SMODS.calculate_effect({message = "Fatal error, removing card!", colour = G.C.RED}, self)
            G.E_MANAGER:add_event(Event({
                func = function() 
                    self.getting_sliced = true
                    self:start_dissolve()
                    return true
                end
            }))
        end
    end
    return(result)
end



local methods = {"calculate_joker", "remove", "add_to_deck", "calculate_dollar_bonus", "can_use_consumeable", "use_consumeable", "redeem"}

for _, name in pairs(methods) do
    local original = Card[name]
    sendInfoMessage("ADDING METHOD ", name)
    Card[name] = function(card, arg1, arg2)
        if card.config.center.mod and Arceus.get_config_entry("safe_calc", card.config.center.mod) == true
        or Arceus.config.force_safe == true
        then
            return Arceus.safe_call(original, name, card, arg1, arg2)
        else
            return original(card, arg1, arg2)
        end
    end
end
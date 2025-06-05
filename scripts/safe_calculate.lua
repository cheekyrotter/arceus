local _calculate_joker = Card.calculate_joker

---@diagnostic disable-next-line: duplicate-set-field
function Card:calculate_joker(context)
    local result = nil
    if self.config.center.mod then
        if Arceus.get_config_entry("safe_calc", self.config.center.mod) == true then
            local success, result = pcall(function() _calculate_joker(self, context) end)
            if not success then
                sendErrorMessage("Caught error:"..result)
                SMODS.calculate_effect({message = "Fatal error, removing card!", colour = G.C.RED}, self)
                self.getting_sliced = true
                self:start_dissolve()
            end
        end
    else
        local result = _calculate_joker(self, context) 
    end
    return(result)
end
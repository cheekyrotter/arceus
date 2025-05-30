local _calculate_joker = Card.calculate_joker

function Card:calculate_joker(context)
    local result = nil
    if self.config.center.mod then
        local mod = self.config.center.mod
        if mod.force_safe_calculate == true then
            local success, result = pcall(function() _calculate_joker(self, context) end)
            if not success then
                sendErrorMessage("Caught error:"..result)
                self.getting_sliced = true
                self:start_dissolve()
            end
        end
    else
        local result = _calculate_joker(self, context) 
    end
    return(result)
end
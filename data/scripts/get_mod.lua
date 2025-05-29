Arceus.default_conf = {
    data_folder = "data/",
    safe_calc = true
}

function Arceus.gm()
    local mod = SMODS.current_mod
    if not mod then return nil end

    if not mod.arceus_config then 
        mod.arceus_config = Arceus.default_conf end
    for name, value in ipairs(Arceus.default_conf) do
        if not mod.arceus_config[name] then
            mod.arceus_config[name] = Arceus.default_conf[name]
        end
    end

    return mod    

end
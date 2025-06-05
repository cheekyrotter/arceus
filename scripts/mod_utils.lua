Arceus.default_conf = {
    data_folder = "data/",
    crossmod_folder = "crossmod/",
    crossmod_in_data = true,
    auto_load_exclude = {},
    safe_calc = true
}

Arceus.config_created = {}


function Arceus.get_mod()
    local mod = SMODS.current_mod
    if not mod then
        sendErrorMessage(Arceus.prfx.."Mod Utils | Can't even find the mod using this, what the hell??")
        return false
    end
    if not Arceus.config_created[mod.id] then 
        Arceus.create_config()
    end

    return mod
end


function Arceus.create_config()
    local mod = SMODS.current_mod
    if not mod then return false end

    if not mod.arceus_config then
        mod.arceus_config = Arceus.default_conf
    end
     
    for name, value in pairs(Arceus.default_conf) do
        if not mod.arceus_config[name] then
            mod.arceus_config[name] = Arceus.default_conf[name]
        end
    end
    Arceus.config_created[mod.id] = true
    return true
end


function Arceus.get_config_entry(entry, mod)
    if not mod then mod = Arceus.get_mod() end
    if not mod then return false end

    if Arceus.config_created[mod.id] then 
        Arceus.create_config()
    end
    
    local config = mod.arceus_config

    if not config then return false end

    if not config[entry] then
        sendErrorMessage(Arceus.prefix.."Mod Utils | Failed to get config entry"..mod.id..": "..entry)
        return false
    end
    return config[entry]
end
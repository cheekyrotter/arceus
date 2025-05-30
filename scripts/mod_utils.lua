Arceus.default_conf = {
    data_folder = "data/",
    crossmod_folder = "crossmod/",
    crossmod_in_data = true,
    safe_calc = true
}

function Arceus.get_mod()
    local mod = SMODS.current_mod
    if not mod then
        sendErrorMessage(Arceus.prfx.."Mod Utils | Can't even find the mod using this, what the hell??")
        return nil
    end
    if not mod.arceus_config or not mod.arceus_config.created then 
        Arceus.create_config()
    end

    return mod
end

function Arceus.create_config()
    print("Create config")
    local mod = SMODS.current_mod
    if not mod then
        sendErrorMessage(Arceus.prfx.."Mod Utils | Can't even find the mod using this, what the hell??")
        return nil
    end

    if not mod.arceus_config then
        mod.arceus_config = Arceus.default_conf
    end

    for name, value in ipairs(Arceus.default_conf) do
        if not mod.arceus_config[name] then
            mod.arceus_config[name] = Arceus.default_conf[name]
        end
    end

    mod.arceus_config.created = true
    return true
end

function Arceus.get_config_entry(entry)
    local mod = SMODS.current_mod
    if not mod then
        sendErrorMessage(Arceus.prfx.."Mod Utils | Can't even find the mod using this, what the hell??")
        return nil
    end

    if not mod.arceus_config or not mod.arceus_config.created then 
        Arceus.create_config()
    end
    
    local config = mod.arceus_config

    if not config[entry] then
        sendErrorMessage(Arceus.prefix.."Mod Utils | Failed to get config entry"..mod.id..": "..entry)
        return nil
    end
    return config[entry]
end
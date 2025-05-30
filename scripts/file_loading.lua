Arceus.fl = {}
Arceus.fl.failed_files = {}
Arceus.fl.other_fails = {}
Arceus.fl.successes = 0

function Arceus.safe_load(name) -- Attempts to load the given file, does not crash if this failes
    local mod = Arceus.get_mod()
    if not mod then
        sendErrorMessage(Arceus.prfx.."Safe Load | Can't even find the mod using this, what the hell??")
        local ofs = Arceus.fl.other_fails
        ofs[#ofs + 1] = "Safe Load | Can't find current mod (literally no idea how this could happen)"
        return false
    end

    if not name then
        sendErrorMessage(Arceus.prfx..mod.id.."Safe Load | File argument not given")
        local ofs = Arceus.fl.other_fails
        ofs[#ofs + 1] = "Safe Load | No file argument given, mod: "..mod.id
        return false
    end
    local success, result = xpcall(function() assert(SMODS.load_file(name))() end, debug.traceback)
    if not success then
        sendErrorMessage("Safe Load | Caught error:"..result)
        Arceus.fl.failed_files[#Arceus.fl.failed_files + 1] = {mod.path..name, result}
        return nil
    end
    Arceus.fl.successes = Arceus.fl.successes + 1
    return result
end


function Arceus.batch_load(folder) -- Loads all files in the given folder (by default would be "your_mod/data/[txt]/")

	-- Credit to GARBSHIT for the original function, very helpful 
    -- Have amended this a significant amount and will continue to amend more
    
    local mod = Arceus.get_mod()
    if not mod then
        sendErrorMessage(Arceus.prfx.."Batch Load | Can't even find the mod using this, what the hell??")
        local ofs = Arceus.fl.other_fails
        ofs[#ofs + 1] = "Batch Load | Can't find current mod (literally no idea how this could happen)"
        return false
    end

    if not folder then
        sendErrorMessage(Arceus.prfx..mod.id.."Batch Load | File argument not given")
        local ofs = Arceus.fl.other_fails
        ofs[#ofs + 1] = "Batch Load | File argument not given, mod: "..mod.id
        return false
    end

    local data_folder = Arceus.get_config_entry("data_folder")
    local full_path = mod.path..data_folder..folder
    local items = NFS.getDirectoryItems(full_path)
    sendInfoMessage(folder)
    local folder = folder..'/'
    for _, item in pairs(items) do
        if string.find(item, ".lua") then
            local name = data_folder..folder..item
            Arceus.safe_load(name)
        end
    end
    sendInfoMessage(Arceus.prfx.."Batch Load | Finished loading "..mod.id..": "..folder)
    return true
end

function Arceus.auto_load() -- Runs batch_load for all files in the data subfolders (by default would be your_mod/data/)
    local mod = Arceus.get_mod()
    if not mod then
        sendErrorMessage(Arceus.prfx.."Auto Load | Can't even find the mod using this, what the hell??")
        local ofs = Arceus.fl.other_fails
        ofs[#ofs + 1] = "Auto Load | Can't find current mod (literally no idea how this could happen)"
        return false
    end

    local data_folder = Arceus.get_config_entry("data_folder")
    print(data_folder)
    if not NFS.getInfo(mod.path..data_folder) then
        sendErrorMessage(Arceus.prfx.."Auto Load | Can't find data folder, mod: "..mod.id..", folder given: "..data_folder)
        local ofs = Arceus.fl.other_fails
        ofs[#ofs + 1] = "Auto Load | Can't find data folder, mod: "..mod.id..", folder given: "..data_folder
        return false
    end
    local items = NFS.getDirectoryItems(mod.path..data_folder)

    for _, item in pairs(items) do
        local full_path = mod.path..data_folder..item
        local info = NFS.getInfo(full_path)
        if info and info.type == "directory" then
            Arceus.batch_load(item)
        end
    end
    sendInfoMessage(Arceus.prfx.."Auto Load | Finished loading "..mod.id)
    return true
end
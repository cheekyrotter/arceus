Arceus.bl = {}
Arceus.bl.failed_files = {}
Arceus.bl.other_fails = 0


function Arceus.batch_load(txt) -- Loads all files in the given folder (by default would be "your_mod/data/[txt]/")

	-- Credit to GARBSHIT for the original function, very helpful 
    -- Have amended this a significant amount and will continue to amend more
    
    local mod = Arceus.gm()
    if mod == nil then
        sendErrorMessage(Arceus.prfx.."Batch Load | Can't even find the mod using this, what the hell??")
        return false
    end

    if not txt then
        sendErrorMessage(Arceus.prfx..mod.id.."Batch Load | File argument not given")
        Arceus.bl.other_fails = Arceus.bl.other_fails + 1
        return false
    end

    local data = mod.arceus_config.data_folder
    local folder = mod.path..data..txt
    local joker_files = NFS.getDirectoryItems(folder)
    sendInfoMessage(folder)
    local txt = txt..'/'
    for _, file in pairs(joker_files) do
        if string.find(file, ".lua") then
            local name = data..txt..file
            local success, result = pcall(function() assert(SMODS.load_file(name))() end)
            if not success then
                sendErrorMessage("Caught error:"..result)
                Arceus.bl.failed_files[#Arceus.bl.failed_files + 1] = mod.path..name
            end
        end
    end
    sendInfoMessage(Arceus.prfx.."Batch Load | Finished loading "..mod.id..": "..txt)
    return true
end

function Arceus.auto_load() -- Runs batch_load for all files in the data subfolders (by default would be your_mod/data/)
    local mod = Arceus.gm()
    if mod == nil then
        sendErrorMessage(Arceus.prfx.."Auto Load | Can't even find the mod using this, what the hell??")
        return false
    end

    local data = mod.arceus_config.data_folder
    local items = NFS.getDirectoryItems(mod.path..data)

    for _, item in pairs(items) do
        local fullPath = mod.path..data..item
        local info = NFS.getInfo(fullPath)
        if info and info.type == "directory" then
            Arceus.batch_load(item)
        end
    end


    return true
end
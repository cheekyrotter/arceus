Arceus.fl = {}
Arceus.fl.failed_files = {}
Arceus.fl.other_fails = 0
Arceus.fl.successes = 0

function Arceus.safe_load(name) -- Attempts to load the given file, does not crash if this failes
    local mod = Arceus.get_mod()
    if not mod then
        sendErrorMessage(Arceus.prfx.."Safe Load | Can't even find the mod using this, what the hell??")
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end

    if not name then
        sendErrorMessage(Arceus.prfx..mod.id.."Safe Load | File argument not given")
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end
    local STP = loadStackTracePlus()
    local success, result = xpcall(function() assert(SMODS.load_file(name))() end, STP.stacktrace)
    if not success then
        sendErrorMessage("Safe Load | Caught error loading "..name..", mod: "..mod.id)
        Arceus.fl.failed_files[#Arceus.fl.failed_files + 1] = {file = mod.id.."/"..name, error = result}
        return nil
    end
    Arceus.fl.successes = Arceus.fl.successes + 1
    return result
end


function Arceus.batch_load(folder, in_data) -- Loads all files in the given folder (by default would be "your_mod/data/[txt]/")

	-- Credit to GARBSHIT for the original basic batch loading function
    
    if not in_data then in_data = true end

    local mod = Arceus.get_mod()
    if not mod then
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end

    if not folder then
        sendErrorMessage(Arceus.prfx..mod.id.."Batch Load | File argument not given")
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end

    
    local full_path = mod.path..folder

    if in_data then
        local data_folder = Arceus.get_config_entry("data_folder")
        if not NFS.getInfo(mod.path..data_folder) then
            sendErrorMessage(Arceus.prfx.."Batch Load | Can't find data folder, mod: "..mod.id..", folder given: "..data_folder)
            Arceus.fl.other_fails = Arceus.fl.other_fails + 1
            return false
        end
        full_path = mod.path..data_folder..folder
        folder = data_folder..folder
    end
    local items = NFS.getDirectoryItems(full_path)
    local folder = folder..'/'
    for _, item in pairs(items) do
        if string.find(item, ".lua") then
            local name = folder..item
            Arceus.safe_load(name)
        end
    end
    sendInfoMessage(Arceus.prfx.."Batch Load | Finished loading "..mod.id..": "..folder)
    return true
end



function Arceus.auto_load() -- Runs batch_load for all files in the data subfolders (by default would be your_mod/data/)
    local mod = Arceus.get_mod()
    if not mod then
        local ofs = Arceus.fl.other_fails
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end

    local data_folder = Arceus.get_config_entry("data_folder")
    if not NFS.getInfo(mod.path..data_folder) then
        sendErrorMessage(Arceus.prfx.."Auto Load | Can't find data folder, mod: "..mod.id..", folder given: "..data_folder)
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end
    local items = NFS.getDirectoryItems(mod.path..data_folder)

    local items = Arceus.auto_load_filter(items)

    for _, item in pairs(items) do
        local full_path = mod.path..data_folder..item
        local info = NFS.getInfo(full_path)
        if info and info.type == "directory" then
            Arceus.batch_load(item)
        end
    end
    sendInfoMessage(Arceus.prfx.."Auto Load | Finished main loading for "..mod.id)

    local crossmod = Arceus.crossmod_load()

    return true
end


function Arceus.auto_load_filter(items) -- Removes excluded folders from the auto_load loading list
    local exclude = {}
    local files = {}

    local exclude_list = Arceus.get_config_entry("auto_load_exclude")
    if Arceus.get_config_entry("crossmod_in_data") then
        exclude_list[#exclude_list + 1 ] = Arceus.get_config_entry("crossmod_folder")
    end

    for _, item in pairs(exclude_list) do
        exclude[item] = true
    end

    for _, item in pairs(items) do
        if not exclude[item.."/"] then
            table.insert(files, item)
        end
    end

    return files

end


function Arceus.crossmod_load() -- Called by auto_load, loads any applicable crossmod folders 
    local mod = Arceus.get_mod()
    if not mod then
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end

    local in_data = false
    local folder = Arceus.get_config_entry("crossmod_folder")
    if Arceus.get_config_entry("crossmod_in_data") == true then 
        in_data = true
    end

    local full_path = mod.path..folder
    if in_data then full_path = mod.path..Arceus.get_config_entry("data_folder")..folder end
    if not NFS.getInfo(full_path) then
        sendErrorMessage(Arceus.prfx.."Crossmod Load | Can't find crossmod folder, mod: "..mod.id..", folder given: "..full_path)
        Arceus.fl.other_fails = Arceus.fl.other_fails + 1
        return false
    end
    local items = NFS.getDirectoryItems(full_path)

    for _, item in pairs(items) do
        local info = NFS.getInfo(full_path..item)
        if info and info.type == "directory" then
            if #SMODS.find_mod(item) > 0 then
                Arceus.batch_load(folder..item, in_data)
            end
        end
    end

    sendInfoMessage(Arceus.prfx.."Crossmod Load | Finished crossmod loading for "..mod.id)
    return true

end

local main_menu_ref = Game.main_menu
---@diagnostic disable-next-line: duplicate-set-field
Game.main_menu = function(change_context)
    local ret = main_menu_ref(change_context)
    local errors = {}
    if next(Arceus.fl.failed_files) ~= nil then
        for _, value in ipairs(Arceus.fl.failed_files) do
            local summary = "Failed to load file: "..value.file
            error = {summary = summary, traceback = value.error}
            table.insert(errors, error)
        end
    end

    if Arceus.fl.other_fails > 0 then
        print("other errors")
        error = {summary = Arceus.fl.other_fails.." other loading errors (see console)"}
        table.insert(errors, error)
    end
    if next(errors) ~= nil then
        Arceus.error_popup(errors)
    end
    return ret
end
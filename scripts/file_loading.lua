Arceus.fl = {}
Arceus.fl.fails = {}
Arceus.fl.successes = 0
Arceus.fl.popup = false

Arceus.fl.processes = {
    safe = "Safe Load",
    batch = "Batch Load",
    auto = "Auto Load",
    crossmod = "Crossmod Load",
    other = "N/A"
}

Arceus.fl.error_messages = {
    no_mod = "Can't find find original mod (rare error!)",
    missing_arg = "No file/folder argument given",
    fail_file = "Failed loading file: ",
    missing_folder = "Can't find folder: ",
    missing_file = "Can't find file: ",
    other = "Unexplained error"
}

function Arceus.file_load_error(type, process, traceback, other_arg)
    if not type then type = "other" end
    if not process then process = "other" end
    local proc_msg = Arceus.fl.processes[process]
    local err_msg = Arceus.fl.error_messages[type]
    local summary = proc_msg.." | "..err_msg
    if other_arg then summary = summary..other_arg end
    sendErrorMessage(Arceus.msg_prefix..summary)
    Arceus.fl.fails[#Arceus.fl.fails + 1] = {summary = summary, traceback = traceback}
end


function Arceus.safe_load(name) -- Attempts to load the given file, does not crash if this failes
    local mod = Arceus.get_mod()
    if not mod then
        Arceus.file_load_error("mod", "safe")
        return false
    end

    if not name then
        Arceus.file_load_error("missing_arg", "safe")
        return false
    end
    local STP = loadStackTracePlus()
    local success, result = xpcall(function() assert(SMODS.load_file(name))() end, STP.stacktrace)
    if not success then
        Arceus.file_load_error("fail_file", "safe", result, mod.id.."/"..name)
        return false
    end
    Arceus.fl.successes = Arceus.fl.successes + 1
    return result
end


function Arceus.batch_load(folder, in_data) -- Loads all files in the given folder (by default would be "your_mod/data/[txt]/")

	-- Credit to GARBSHIT for the original basic batch loading function
    
    if not in_data then in_data = true end

    local mod = Arceus.get_mod()
    if not mod then
        Arceus.file_load_error("no_mod", "batch")
        return false
    end

    if not folder then
        Arceus.file_load_error("missing_arg", "batch")
        return false
    end

    
    local full_path = mod.path..folder

    if in_data then
        local data_folder = Arceus.get_config_entry("data_folder")
        if not NFS.getInfo(mod.path..data_folder) then
            Arceus.file_load_error("missing_folder", "batch", nil, mod.id.."/"..data_folder)
            return false
        end
        full_path = mod.path..data_folder..folder
        folder = data_folder..folder
    end

    if not NFS.getInfo(full_path) then
        Arceus.file_load_error("missing_folder", "batch", nil, mod.id.."/"..folder)
        return false
    end

    local items = NFS.getDirectoryItems(full_path)
    local folder = folder..'/'
    for _, item in pairs(items) do
        if string.find(item, ".lua") then
            local name = folder..item
            Arceus.safe_load(name)
        end
    end
    sendInfoMessage(Arceus.msg_prefix.."Batch Load | Finished loading "..mod.id..": "..folder)
    return true
end



function Arceus.auto_load() -- Runs batch_load for all files in the data subfolders (by default would be your_mod/data/)
    local mod = Arceus.get_mod()
    if not mod then
        Arceus.file_load_error("missing_mod", "auto")
        return false
    end

    local data_folder = Arceus.get_config_entry("data_folder")
    if not NFS.getInfo(mod.path..data_folder) then
        Arceus.file_load_error("missing_folder", "auto", nil, mod.id.."/"..data_folder)
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
    sendInfoMessage(Arceus.msg_prefix.."Auto Load | Finished main loading for "..mod.id)

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
        Arceus.file_load_error("missing_mod", "crossmod")
        return false
    end

    local in_data = false
    local folder = Arceus.get_config_entry("crossmod_folder")
    if Arceus.get_config_entry("crossmod_in_data") == true then 
        in_data = true
    end

    local full_path = mod.path..folder
    local data_folder = Arceus.get_config_entry("data_folder")
    if in_data then full_path = mod.path..data_folder..folder end
    if not NFS.getInfo(full_path) then
        Arceus.file_load_error("missing_folder", "crossmod", nil, mod.id.."/"..data_folder..folder)
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

    sendInfoMessage(Arceus.msg_prefix.."Crossmod Load | Finished crossmod loading for "..mod.id)
    return true

end

Arceus.add_menu_hook(function(change_context)

    if next(Arceus.fl.fails) ~= nil and Arceus.fl.popup == false then
        local errors = {}
        for _, value in ipairs(Arceus.fl.fails) do
            error = {summary = value.summary, traceback = value.traceback}
            table.insert(errors, error)
        end
        local popup = Arceus.error_popup_ui(errors)
        Arceus.add_menu_popup(popup)
        Arceus.fl.popup = true
    end

end)
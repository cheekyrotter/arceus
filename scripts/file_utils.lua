function Arceus.gf(folder) -- Returns a table of common paths for a mod
    local mod = Arceus.gm()
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
    return
end
---@meta

---@param name string File path to the file relative to your mod (same as SMODS.load_file)
function Arceus.safe_load(name) end

--- @param folder string Location of the folder to load the files of (ignores excluded files)
--- @param in_data boolean Whether the folder is in your set data folder or not (see Mod.arceus_config)
function Arceus.batch_load(folder, in_data) end


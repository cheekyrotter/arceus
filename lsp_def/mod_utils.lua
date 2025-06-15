---@meta


---@class Mod
---@field arceus_config? Arceus.arceus_config The Arceus settings for your mod


---@class Arceus.arceus_config: table The Arceus settings for your mod
---@field data_folder? string Location of the folder containing your objects (e.g. if your jokers are in your_mod/objects/jokers/, put "objects/") 
---@field crossmod_folder? string Location of the folder containing your crossmod contents (e.g. if its in your_mod/crossmod/ or your_mod/objects/crossmod, put "crossmod/")
---@field crossmod_in_data? boolean States if your crossmod folder is inside your data folder (prevents accidental loading from auto_load batch loading)
---@field auto_load_exclude? table List of folders within your data folder to exclude from auto loading
---@field safe_calc? boolean Whether all jokers in your mod should be forced to use safe functions (e.g. errors in calculations will be ignored instead of causing crashes)

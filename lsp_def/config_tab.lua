---@meta


---@class ConfigSettings
---@field label? string The name of the tab ingame
---@field extra? boolean Whether the tab is an extra tab or not (first tab is 'false' by default, the rest are 'true')
---@field description? string The description of the tab ingame (default is "Options:")
---@field table? table A table to use in place of your mod's config (can be a table entry of your config)

---@class ConfigEntry
---@field type '"toggle"'|'"slider"'|'"input"'|'"cycle"' The type of setting
---@field label string The label/description
---@field key string The key of the setting to change
---@field table? table The table that the key belongs to (your mod's config by default)
---@field restart? boolean Whether the game should restart if this is changed
---@field config? ConfigConfig Extra config for the type given
---@field label_scale? integer Scale for the label text (by default 0.5)
---@field cycles? string[] The labels to cycle between for the "cycle" option (cycles change the setting to the index of the cycle)

---@class ConfigConfig
---@field min? number
---@field max? number
---@field places? integer The number of decimal places

---@param settings ConfigSettings The settings for the tab (if not given, creates the main config tab)
---@param entries ConfigEntry[] A list of settings/entries. Each entry is a table containing the information
function Arceus.create_config_tab(entries, settings) end
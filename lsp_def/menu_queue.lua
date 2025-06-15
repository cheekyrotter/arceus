---@meta



---@param func function The function to be called when the main menu loads
function Arceus.add_menu_hook(func) end

---@param ui table A UI structure to be loaded with the main menu (NOT A UIBOX)
---@param name string The name of the menu (not too important, not really implemented yet here)
function Arceus.add_menu_popup(ui, name) end

---@param ui table A UI structure to be loaded immediately as an overlay menu
function Arceus.make_overlay(ui) end
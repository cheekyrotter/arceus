Arceus.menu_popup_queue = {}
Arceus.menu_hooks = {}

local main_menu_ref = Game.main_menu
---@diagnostic disable-next-line: duplicate-set-field
Game.main_menu = function(change_context)
    local ret = main_menu_ref(change_context)
    
    for _, v in pairs(Arceus.menu_hooks) do
        v(change_context)
    end
    Arceus.load_popups()

    return ret
end

function Arceus.add_menu_hook(func) -- Add a function to run when the main menu loads fully
    table.insert(Arceus.menu_hooks, func)
end

function Arceus.add_menu_popup(ui, name) -- Adds a UI element to be loaded in the next menu (must start as root)
    name = name or "default"
    table.insert(Arceus.menu_popup_queue, {ui = ui, name = name})
end

function Arceus.make_overlay(ui) -- Converts a UI structure to the UIBox format and makes an overlay menu
    G.FUNCS.overlay_menu(
    {
        definition = ui,
        config = {align='cm', major = G.ROOM_ATTACH, bond = 'Strong'},
        pause = true
    })
end

function Arceus.load_popups()
    if next(Arceus.menu_popup_queue) ~= nil then
        local entry = Arceus.menu_popup_queue[1]
        Arceus.make_overlay(entry.ui)
        table.remove(Arceus.menu_popup_queue, 1)
    end
end

local exit_ref = G.FUNCS.exit_overlay_menu
---@diagnostic disable-next-line: duplicate-set-field
function G.FUNCS.exit_overlay_menu()
    local ret = exit_ref()
    Arceus.load_popups()
    return ret
end





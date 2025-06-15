Arceus.vc = {}
Arceus.vc.versions = {}

local main_menu_ref = Game.main_menu
---@diagnostic disable-next-line: duplicate-set-field
Game.main_menu = function(change_context)
    local ret = main_menu_ref(change_context)
    for _, v in pairs(SMODS.mod_list) do
        local author = v.author[1]
        author = string.gsub(author, "[ _]", "")
        local full_name = v.author[1].."@"..v.id
        print(full_name)
    end
    return ret
end


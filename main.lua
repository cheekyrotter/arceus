Arceus = SMODS.current_mod
Arceus.msg_prefix = "{Arceus} "

-- I won't use the mod's batch loading as getting it to work with itself seems like a pain
local scripts = {"mod_utils", "file_loading", "safe_calculate", "error_ui", "config_tab"}
for _, v in pairs(scripts) do
    print(v)
    assert(SMODS.load_file("scripts/"..v..".lua"))()
end

SMODS.Keybind {
    key_pressed = "e",
    action = function()
        Arceus.error_popup({{summary = "test1", traceback = "test"}, {summary = "test2"}})
    end
}


Arceus.create_config_tab({
    {type = "toggle", label = "Enable Broken Jokers for Error Testing", key = "testing_mode", restart = true},
    {type = "toggle", label = "Destroy Cards Causing Errors", key = "remove_cards"},
    {type = "toggle", label = "Force Safe Calculate for All Mods", key = "force_safe"},
})

if Arceus.config.testing_mode == true then 
    Arceus.batch_load("tests/") 
    Arceus.batch_load("fake")
    Arceus.batch_load() 
end
Arceus = SMODS.current_mod
Arceus.msg_prefix = "{Arceus} "

-- I won't use the mod's batch loading as getting it to work with itself seems like a pain
local scripts = {"mod_utils", "menu_queue", "file_loading", "safe_calculate", "error_ui", "config_tab"}
for _, v in pairs(scripts) do
    assert(SMODS.load_file("scripts/"..v..".lua"))()
end

SMODS.Keybind {
    key_pressed = "e",
    action = function()
        create_UIBox_generic_options({Arceus.error_popup_ui({{summary = "test1", traceback = "test"}, {summary = "test2"}})})
    end
}


Arceus.create_config_tab({
    {type = "toggle", label = "Enable Broken Jokers for Error Testing", key = "testing_mode", restart = true},
    {type = "toggle", label = "Destroy Cards Causing Errors", key = "remove_cards"},
    {type = "toggle", label = "Force Safe Calculate for All Mods", key = "force_safe"},
})

Arceus.create_config_tab({
    {type = "toggle", label = "Toggle", key = "toggle_1"},
    {type = "toggle", label = "Another Toggle", key = "toggle_2", restart = true},
    {type = "slider", label = "Slider 1", key = "slider_1", config = {max = 100, min = 0}},
    {type = "slider", label = "Slider 2", key = "slider_2", config = {max = 1, min = 0, places = 1}},
    {type = "input", label = "Input", key = "input"},
    {type = "cycle", label = "Option Cycle", key = "cycle", cycles = {"Test 1", "Test 2", "Test 3"}},
},
{label = "Demo", description = "Config maker demo", table = Arceus.config.dummy_config})

if Arceus.config.testing_mode == true then 
    Arceus.batch_load("tests/") 
    Arceus.batch_load("fake")
    Arceus.batch_load() 
end
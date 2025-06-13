Arceus = SMODS.current_mod
Arceus.prfx = "{Arceus} "

-- I won't use bulk loading in this library because getting it to work with itself seems like a pain
assert(SMODS.load_file("scripts/mod_utils.lua"))()
assert(SMODS.load_file("scripts/file_loading.lua"))()
assert(SMODS.load_file("scripts/safe_calculate.lua"))()
assert(SMODS.load_file("scripts/error_ui.lua"))()

SMODS.Keybind {
    key_pressed = "k",
    action = function()
        love.system.setClipboardText(Arceus.fl.failed_files[#Arceus.fl.failed_files].error)
    end
}

SMODS.Keybind {
    key_pressed = "e",
    action = function()
        Arceus.error_popup({{summary = "test1", traceback = "test"}, {summary = "test2", traceback = "test"}})
    end
}
Arceus = SMODS.current_mod
Arceus.prfx = "{Arceus} "

-- I won't use bulk loading in this library because getting it to work with itself seems like a pain
assert(SMODS.load_file("scripts/mod_utils.lua"))()
assert(SMODS.load_file("scripts/file_loading.lua"))()

SMODS.Keybind {
    key_pressed = "k",
    action = function()
        love.system.setClipboardText(Arceus.fl.failed_files[#Arceus.fl.failed_files].error)
    end
}
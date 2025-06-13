Arceus = SMODS.current_mod
Arceus.prfx = "{Arceus} "

-- I won't use bulk loading in this library because getting it to work with itself seems like a pain
assert(SMODS.load_file("scripts/mod_utils.lua"))()
assert(SMODS.load_file("scripts/file_loading.lua"))()
assert(SMODS.load_file("scripts/safe_calculate.lua"))()
assert(SMODS.load_file("scripts/error_ui.lua"))()


SMODS.Keybind {
    key_pressed = "e",
    action = function()
        Arceus.error_popup({{summary = "test1", traceback = "test"}, {summary = "test2"}})
    end
}


local config = Arceus.config
local arc_enabled = copy_table(config)

local function config_matching()
	for k, v in pairs(arc_enabled) do
		if v ~= config[k] then
			return false
		end
	end
	return true
end

function G.FUNCS.arceus_restart()
	if config_matching() then
		SMODS.full_restart = 0
	else
		SMODS.full_restart = 1
	end
end

SMODS.current_mod.config_tab = function()
    -- Once again I have borrowed code from Garbshit, thank you Garb
    local config_nodes = {{n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.O, config={object = DynaText({string = "Options:", colours = {G.C.WHITE}, shadow = true, scale = 0.4})}},}},
        create_toggle({label = "Enable Broken Testing Jokers (Requires Restart)", ref_table = config, ref_value = "testing_mode", callback = G.FUNCS.arceus_restart,})
    }
    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 10,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK
        },
        nodes = config_nodes
    }  
end

if config.testing_mode == true then Arceus.batch_load("tests/") Arceus.batch_load() end
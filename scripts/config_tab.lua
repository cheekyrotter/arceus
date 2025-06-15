function Arceus.config_matching(mod)
	for key, value in pairs(mod.config_copy) do
		if value ~= mod.config[key] then
			return false
		end
	end
	return true
end


function G.FUNCS.arceus_restart(data) -- Checks if the config matches, and if a setting requiring a restart has changed, restarts the game
    local mod = data.mod
	if Arceus.config_matching(mod) then
		SMODS.full_restart = 0
	else
		SMODS.full_restart = 1
	end
end

function Arceus.create_config_tab(args) -- Creates the config tab for your mod from the given options (see repo for examples)
    local mod = SMODS.current_mod
    if not mod then return end
    local mod_config = mod.config
    mod.config_copy = copy_table(mod_config)
    mod.menu_args = args
    
    

    mod.config_tab = function()
        local config_nodes = {}

        for _, value in pairs(mod.menu_args) do
            if not value.type then break end
            value.label = value.label or "[Label Missing]"
            value.restart = value.restart or false
            if value.type == "toggle" then
                local config = {label = value.label, ref_table = mod_config, ref_value = value.key}
                if value.restart == true then
                    config.callback = function()
                        G.FUNCS.arceus_restart({
                            mod = mod
                        })
                    end
                    config.label = config.label.." (Requires Restart)"
                end
                local node = create_toggle(config)
                table.insert(config_nodes, node)
            end
        end

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
            nodes = {
                
                {
                    n = G.UIT.R, 
                    config = {align = "cm"}, 
                    nodes = {
                        {
                            n=G.UIT.O, 
                            config={
                                object = DynaText({string = "Options:", colours = {G.C.WHITE}, shadow = true, scale = 0.4})
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R, 
                    config = {align = "cm"}, 
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {align = "cm"},
                            nodes = config_nodes
                        }
                    }
                }
            }
        }  
    end
end
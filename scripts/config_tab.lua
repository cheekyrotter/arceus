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

function Arceus.create_config_tab(entries, settings) -- Creates the config tab for your mod from the given options (see repo for examples)
    local mod = SMODS.current_mod
    if not mod then return end
    local mod_config = mod.config

    mod.config_copy = copy_table(mod_config)

    settings = settings or {}
    settings.extra = settings.extra or false
    if mod.config_tab then settings.extra = true end
    settings.label = settings.label or "Config"
    settings.description = settings.description or "Options:"

    local config_table = settings.table or mod_config
    
    local definition = function()
        local config_nodes = {}

        for _, value in pairs(entries) do
            if not value.type then break end
            local label = value.label or "[Label Missing]"
            if value.restart == true then label = label.." (Requires Restart)" end
            value.restart = value.restart or false

            local node = {}
            local config = {label = label, ref_table = config_table, ref_value = value.key, label_scale = value.label_scale or 0.5}
            if value.restart == true then
                config.callback = function()
                    G.FUNCS.arceus_restart({
                        mod = mod
                    })
                end

            end
            if value.type == "toggle" then
                node = create_toggle(config)
                node.nodes[2].config.align = "cm"
                node.nodes[1].config.minw = 0.5
                
            elseif value.type == "slider" then
                config.min = value.config.min
                config.max = value.config.max
                config.decimal_places = value.config.places or 0
                config.w = 6
                node = create_slider(config)

            elseif value.type == "input" then
                local input = create_text_input(config)
                node = { n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = { {n = G.UIT.T, config = {text = config.label.." ", scale = config.label_scale, align = "cm"}}}}
                table.insert(node.nodes, input)
            elseif value.type == "cycle" then
                config.options = value.cycles
                config.current_option = config_table[value.key]
                node = create_option_cycle(config)
            end

            table.insert(config_nodes, node)
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
                                object = DynaText({string = settings.description, colours = {G.C.WHITE}, shadow = true, scale = 0.6})
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
                            config = {align = "cm", padding = 0.05},
                            nodes = config_nodes
                            
                        }
                    }
                }
            }
        }
    end
    if settings.extra == false then
        mod.config_tab = definition
    else
        local extra_tabs = {}
        if mod.extra_tabs then extra_tabs = mod.extra_tabs() end
        local tab = {
            label = settings.label,
            tab_definition_function = definition,
        }
        table.insert(extra_tabs, tab)
        mod.extra_tabs = function()
            return extra_tabs
        end
    end
end

G.FUNCS.arceus_cycle_update = function(args)
    args = args or {}
    if args.cycle_config and args.cycle_config.ref_table and args.cycle_config.ref_value then
        args.cycle_config.ref_table[args.cycle_config.ref_value] = args.to_key
    end
end

G.FUNCS.arceus_text_update = function(args)
    args = args or {}
    if args.ref_table and args.ref_value then
        local new_value = ''
        for i = 1, #args.text.letters do
            new_value = new_value .. (args.text.letters[i] or '')
        end
        args.ref_table[args.ref_value] = new_value
    end
end

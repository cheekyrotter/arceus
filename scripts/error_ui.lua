function Arceus.error_popup_ui(errors)
    local error_nodes = {}
    for i, error in ipairs(errors) do
        local nodes = {}
        if error.summary then
            table.insert(nodes, {n=G.UIT.C, 
                    config={
                        align = "cl",
                        minw = 8,
                        maxw = 12
                    },
                    nodes = {
                        { n=G.UIT.T, config = {
                        text = error.summary, 
                        colour = G.C.UI.TEXT_LIGHT, 
                        scale = 0.3,
                        align = "cl"
                    }
                    }
                }
                })
        end
        if error.traceback and error.traceback ~= nil then
            table.insert(nodes, {n=G.UIT.C, 
                    config={
                        align = "cm",
                        minw = 2,
                        maxw = 2
                    }, 
                        nodes = {
                            UIBox_button({
                                label = {"Copy Error"},
                                col = true,
                                colour = G.C.RED,
                                scale = 0.5,
                                minw = 2,
                                minh = 0.6,
                                ref_table = { traceback = error.traceback },
                                button = "arceus_error_copy",
                        })
                        }
                } )
        end
        local base_node = {n=G.UIT.R, config={ 
            align = "cl", 
            padding = 0.2,
            colour = G.C.UI.BACKGROUND_DARK,
            r = 1,
            minh = 1
        }, 
            nodes = nodes
        }
        table.insert(error_nodes, base_node)
    end

    return(
        {n=G.UIT.ROOT, config = {
            align = 'cm', r = 0.1, colour = G.C.L_BLACK}, nodes={
            {
                n=G.UIT.R, 
                config={
                    align = "cm", 
                    minw = 10,
                    padding = 0.3,
                    r = 0.1, 
                    outline_colour = G.C.UI.OUTLINE_LIGHT, 
                    outline = 1.5
                }, 
                nodes={
                    {n = G.UIT.R, config={ align = "cm"}, nodes ={
                        {n = G.UIT.C, config = {align = "cm"}, nodes = {
                        {n=G.UIT.R, 
                            config={
                                align = "cm"
                            }, 
                            nodes={
                            {
                                n=G.UIT.T, 
                                config = {
                                    text = "Ouch!", 
                                    colour = G.C.RED, 
                                    scale = 0.6
                                }
                            }
                            }
                        },
                        {n=G.UIT.R, 
                            config={
                                align = "cl",
                                padding = 0.2
                            }, 
                            nodes={
                            {
                                n=G.UIT.T, 
                                config = {
                                    text = "The following errors have occured:", 
                                    colour = G.C.UI.TEXT_LIGHT, 
                                    scale = 0.4,
                                    align = "cl"
                                }
                            },
                            }
                        },
                        {n=G.UIT.R, 
                            config={
                                align = "cm"
                            }, 
                            nodes={
                                {n = G.UIT.C, config = {align = "cm", padding = 0.2}, nodes = error_nodes
                            }
                            }
                        },
                        {n=G.UIT.R, 
                            config={
                                align = "cm"
                            }, 
                            nodes={
                                UIBox_button({
                                label = {"Close"},
                                col = true,
                                colour = G.C.ORANGE,
                                scale = 0.5,
                                minw = 4,
                                minh = 0.8,
                                button = "exit_overlay_menu",
                            })
                            }
                        }
                        
                    }
                    }
                    }
                }
            },
            
        }
        }
    }
    )
end


function G.FUNCS.arceus_error_copy(e)
    love.system.setClipboardText(e.config.ref_table.traceback)
end

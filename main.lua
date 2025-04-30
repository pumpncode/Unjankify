Unjank = {}
Unjank.config = SMODS.current_mod.config
Unjank.old_menu_width = Unjank.config.menu_width
Unjank.old_menu_pos = Unjank.config.menu_pos
local pos_factor = 6

local orig_main_menu = Game.main_menu

Game.main_menu = function(change_context)
    local ret = orig_main_menu(change_context)
    G.title_top.T.w = G.title_top.T.w * Unjank.config.menu_width
    G.title_top.T.x = G.title_top.T.x + Unjank.config.menu_pos * pos_factor
    return ret
end

local function unjank_update_width()
    G.title_top.T.w = (G.title_top.T.w/Unjank.old_menu_width) * Unjank.config.menu_width
    Unjank.old_menu_width = Unjank.config.menu_width
end
local function unjank_update_pos()
    G.title_top.T.x = G.title_top.T.x - (Unjank.old_menu_pos * pos_factor) + (Unjank.config.menu_pos * pos_factor)
    Unjank.old_menu_pos = Unjank.config.menu_pos
end

local g_funcs_slider = G.FUNCS.slider
G.FUNCS.slider = function(e)
    if e.children[1].config.ref_table.ref_value == 'menu_width'  then
        local c = e.children[1]
        if G.CONTROLLER and G.CONTROLLER.dragging.target and
        (G.CONTROLLER.dragging.target == e or
        G.CONTROLLER.dragging.target == c) then
            unjank_update_width()
        end
    end
	if e.children[1].config.ref_table.ref_value == 'menu_pos'  then
        local c = e.children[1]
        if G.CONTROLLER and G.CONTROLLER.dragging.target and
        (G.CONTROLLER.dragging.target == e or
        G.CONTROLLER.dragging.target == c) then
            unjank_update_pos()
        end
    end
    g_funcs_slider(e)
end

SMODS.current_mod.config_tab = function()
	return {
	  n = G.UIT.ROOT,
	  config = { align = 'cm', padding = 0.07, emboss = 0.05, r = 0.1, colour = G.C.BLACK, minh = 2.5 ,minw = 7 },
	  nodes = {
		{
			n = G.UIT.R,
			config = { align = 'cm'},
			nodes = {
				{ n = G.UIT.T, config = { text = "Change how far apart cards on the main menu are", colour = G.C.WHITE, scale = 0.4 }},
			}
		},
		{
		  n = G.UIT.R,
		  nodes = {
			{
			  n = G.UIT.C,
			  nodes = {
				create_slider{
                    id = 'slider_red',
                    colour = G.C.RED,
                    label_scale = 1,
                    w = 8, h = 0.5,
                    padding = -0.05,
                    ref_table = Unjank.config,
                    ref_value = 'menu_width',
                    min = 0.001, max = 1,
                    decimal_places = 3,
                    hide_value = true,
                },
			  }
			},
		  }
		},
		{
			n = G.UIT.R,
			config = { align = 'cm'},
			nodes = {
				{ n = G.UIT.T, config = { text = "Change position of the Balatro logo", colour = G.C.WHITE, scale = 0.4 }},
			}
		},
		{
		  n = G.UIT.R,
		  nodes = {
			{
			  n = G.UIT.C,
			  nodes = {
				create_slider{
                    id = 'slider_red',
                    colour = G.C.RED,
                    label_scale = 1,
                    w = 8, h = 0.5,
                    padding = -0.05,
                    ref_table = Unjank.config,
                    ref_value = 'menu_pos',
                    min = -1, max = 1,
                    decimal_places = 3,
                    hide_value = true,
                },
			  }
			},
		  }
		}
	  }
	}
end
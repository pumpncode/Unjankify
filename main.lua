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

local orig_slider = G.FUNCS.slider
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
    orig_slider(e)
end

function G.FUNCS.unjank_reset(a)
	Unjank.config.menu_width = 1
	Unjank.config.menu_pos = 0
	unjank_update_width()
	unjank_update_pos()
end

function G.FUNCS.unjank_adjust_menu(a)
	G.FUNCS.exit_overlay_menu()

	G.ADJUST_MENU = UIBox({
		definition = unjank_menu_box(),
		config = {
			align = "cm",
			major = G.ROOM_ATTACH,
			offset = {x = 0, y = 3.2},
			bond = "Weak",
			instance_type = "POPUP",
		},
	})

end

function G.FUNCS.exit_menu_box(a)
	SMODS.save_all_config()
	G.ADJUST_MENU:remove()
end

function unjank_menu_box()
	G.E_MANAGER:add_event(Event({
		blockable = false,
		func = function()
			G.REFRESH_ALERTS = true
			return true
		end,
	}))
	local t = unjank_create_UIBox_generic_options({
		no_back = true,
        blocking = true,
        blockable = true,
		contents = {
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{ n = G.UIT.T, config = { text = "Change how far apart cards on the logo are", colour = G.C.WHITE, scale = 0.4 }},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
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
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
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
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							UIBox_button{
								label = { "Reset Default" },
								button = "unjank_reset",
							},
						}
					},
				}
			},
			{
				n = G.UIT.R,
				config = { align = 'cm'},
				nodes = {
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							UIBox_button{
								colour = G.C.FILTER,
								label = { "Done" },
								button = "exit_menu_box",
							},
						}
					},
				}
			}
		},
	})
	return t
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
					{
						n = G.UIT.C,
						config = { align = 'cm'},
						nodes = {
							UIBox_button{
								label = { "Adjust Main Menu" },
								button = "unjank_adjust_menu"
							},
						}
					},
				}
			}
		}
	}
end


--------------------------------------------------
--------------------------------------------------

function unjank_create_UIBox_generic_options(args)
    args = args or {}
    local back_func = args.back_func or "exit_overlay_menu"
    local contents = args.contents or ({n=G.UIT.T, config={text = "EMPTY",colour = G.C.UI.RED, scale = 0.4}})
    if args.infotip then 
      G.E_MANAGER:add_event(Event({
        blocking = false,
        blockable = false,
        timer = 'REAL',
        func = function()
            if G.OVERLAY_MENU then
              local _infotip_object = G.OVERLAY_MENU:get_UIE_by_ID('overlay_menu_infotip')
              if _infotip_object then 
                _infotip_object.config.object:remove() 
                _infotip_object.config.object = UIBox{
                  definition = overlay_infotip(args.infotip),
                  config = {offset = {x=0,y=0}, align = 'bm', parent = _infotip_object}
                }
              end
            end
            return true
          end
      }))
    end
  
    return {n=G.UIT.ROOT, config = {align = "cm", minw = G.ROOM.T.w*5, minh = G.ROOM.T.h*5,padding = 0.1, r = 0.1, colour = args.bg_colour or {G.C.GREY[1], G.C.GREY[2], G.C.GREY[3],0}}, nodes={
      {n=G.UIT.R, config={align = "cm", minh = 1,r = 0.3, padding = 0.07, minw = 1, colour = args.outline_colour or G.C.JOKER_GREY, emboss = 0.1}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1,r = 0.2, padding = 0.2, minw = 1, colour = args.colour or G.C.L_BLACK}, nodes={
          {n=G.UIT.R, config={align = "cm",padding = args.padding or 0.2, minw = args.minw or 7}, nodes=
            contents
          },
          not args.no_back and {n=G.UIT.R, config={id = args.back_id or 'overlay_menu_back_button', align = "cm", minw = 2.5, button_delay = args.back_delay, padding =0.1, r = 0.1, hover = true, colour = args.back_colour or G.C.ORANGE, button = back_func, shadow = true, focus_args = {nav = 'wide', button = 'b', snap_to = args.snap_back}}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0, no_fill = true}, nodes={
              {n=G.UIT.T, config={id = args.back_id or nil, text = args.back_label or localize('b_back'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, func = not args.no_pip and 'set_button_pip' or nil, focus_args =  not args.no_pip and {button = args.back_button or 'b'} or nil}}
            }}
          }} or nil
        }},
      }},
      {n=G.UIT.R, config={align = "cm"}, nodes={
        {n=G.UIT.O, config={id = 'overlay_menu_infotip', object = Moveable()}},
      }},
    }}
end
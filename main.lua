Unjank = {}
Unjank.config = SMODS.current_mod.config
Unjank.old_menu_width = Unjank.config.menu_width
Unjank.old_menu_pos = Unjank.config.menu_pos

SMODS.load_file('lib/main_menu.lua')()
--------------------------------------------------
--------------------------------------------------

function Unjank.create_UIBox_generic_options(args)
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
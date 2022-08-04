local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local battery_widget = require("penacho_mods.wibar.battery_widget")
local custom_taglist = require("penacho_mods.wibar.custom_taglist")


local function draw_in_box(wdg, top_margin, right_margin, bottom_margin, left_margin)
	return {
		{
			wdg,
			top = top_margin,
			right = right_margin,
			bottom = bottom_margin,
			left = left_margin,
			widget = wibox.container.margin
		},
		bg = "black",
		shape_border_width = 1,
		shape_border_color = "white",
		shape = gears.shape.rounded_bar,
		widget = wibox.container.background
	}
end

local create_wibar = function(screen)
	local wibar = awful.wibar({ height = 22, position = "bottom", bg="nil", screen=screen })

	wibar:setup {
		layout = wibox.layout.align.horizontal,
		{ 	-- Left widgets
			layout = wibox.layout.fixed.horizontal,
			battery_widget(),
			custom_taglist(screen),
			draw_in_box(awful.widget.watch('pomodoro gettime', 1), 0, 8, 0, 8)
		},

		{ -- Center widgets
			layout = wibox.layout.fixed.horizontal
		},

		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			screen.mylayoutbox,
			wibox.widget.textbox(" ")
		}
	}
	return wibar
end

return create_wibar

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/pomodoro/"

local pomodoro = function()
	local widget = wibox.widget {
		widget = wibox.layout.stack,
		{
			image = image_path .. "base.png",
			widget = wibox.widget.imagebox
		},
		{
			widget = wibox.container.margin,
			top = 2,
			bottom = 3,
			left = 2,
			{
				widget = wibox.container.background,
				shape = function(cr, w, h) gears.shape.rounded_rect(cr,240,h,5) end,
				bg = "#000000",
				fg = "#FF0000",
				shape_border_width = 1,
				shape_border_color = "#FFFFFF",
				{
					widget = wibox.container.margin,
					top = 0,
					bottom = 0,
					left = 6,
					{
						id = "pomotext",
						widget = wibox.widget.textbox,
						text = "A"
					}
				}
			}
		}
	}

	awful.widget.watch('pomodoro gettime', 1, function(l_widget, stdout)
		widget:get_children_by_id("pomotext")[1].text = stdout
	end)

	return widget
end

return pomodoro

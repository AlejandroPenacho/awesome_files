local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/"

local get_clock = function()

	local widget = wibox.widget {
		widget = wibox.layout.stack,
		{
			widget = wibox.widget.imagebox,
			image = image_path .. "text_clock.png"
		},
		{
			widget = wibox.container.margin,
			top = 2,
			bottom = 3,
			left = 2,
			{
				widget = wibox.container.background,
				shape = function(cr, w, h) gears.shape.rounded_rect(cr,115,h,5) end,
				bg = "#000000",
				fg = "#FF0000",
				shape_border_width = 1,
				shape_border_color = "#FFFFFF",
				{
					widget = wibox.container.margin,
					top = 0,
					bottom = 0,
					left = 6,
					right = 10,
					awful.widget.textclock()
				}
			}
		}
	}

	return widget
end

return get_clock

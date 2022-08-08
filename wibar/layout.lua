local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/"

local get_layout = function()
	local layout = awful.widget.layoutbox(s)
    layout:buttons(gears.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
    	awful.button({ }, 3, function () awful.layout.inc(-1) end),
    	awful.button({ }, 4, function () awful.layout.inc( 1) end),
        awful.button({ }, 5, function () awful.layout.inc(-1) end)
	))

	local widget = wibox.widget {
		widget = wibox.layout.stack,
		{
			widget = wibox.widget.imagebox,
			image = image_path .. "layout.png"
		},
		{
			widget = wibox.container.margin,
			top = 2,
			bottom = 3,
			left = 2,
			{
				widget = wibox.container.background,
				shape = function(cr, w, h) gears.shape.rounded_rect(cr,20,h,5) end,
				bg = "#000000",
				fg = "#FF0000",
				shape_border_width = 1,
				shape_border_color = "#FFFFFF",
				{
					widget = wibox.container.margin,
					top = 1,
					bottom = 1,
					left = 3,
					right = 3,
					layout
				}
			}
		}
	}

	return widget
end

return get_layout

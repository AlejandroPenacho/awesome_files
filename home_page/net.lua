local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local text_to_digital = require("penacho_mods.utils.digital_screen")

local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/net/"

local create_net = function(width, height)
	local widget = wibox.widget {
		widget = wibox.layout.manual,
		{
			widget = wibox.widget.imagebox,
			point = {x=0, y=0},
			image = image_dir .. "background.png"
		},
		{
			id = "router",
			point = {x=18, y=40},
			forced_height = 35,
			widget = wibox.layout.fixed.vertical,
			spacing = 4,
			{
				widget = wibox.widget.textbox,
				text = "Se vino"
			},
			text_to_digital("123. 32.211. 45")
		},
		{
			id = "user",
			point = {x=18, y=262},
			forced_height = 20,
			widget = wibox.container.margin,
			text_to_digital("192.168.  0.  3")
		},
		{
			id = "speed_text",
			point = {x=50, y=140},
			forced_height = 65,
			spacing = 5,
			widget = wibox.layout.fixed.vertical,
			{
				widget = wibox.layout.fixed.horizontal,
				forced_height = 30,
				spacing = 5,
				text_to_digital(" 345"),
				{
					widget = wibox.widget.imagebox,
					image = image_dir .. "byte.png"
				}
			},
			{
				widget = wibox.layout.fixed.horizontal,
				forced_height = 30,
				spacing = 5,
				text_to_digital("6211"),
				{
					widget = wibox.widget.imagebox,
					image = image_dir .. "mega.png"
				}
			}
		},
		{
			id = "speed_signal",
			point = {x=5, y=90},
			forced_width = 45,
			widget = wibox.layout.fixed.vertical,
			{
				widget = wibox.widget.imagebox,
				image = image_dir .. "speed_1_6.png"
			},
			{
				widget = wibox.container.rotate,
				direction = "south",
				{
					widget = wibox.widget.imagebox,
					image = image_dir .. "speed_4_6.png"
				}
			}
		},
		{
			id = "wifi",
			point = {x=68, y=210},
			widget = wibox.layout.fixed.horizontal,
			forced_height = 40,
			spacing = 4,
			{
				widget = wibox.widget.imagebox,
				image = image_dir .. "wifi_1_4.png"
			},
			{
				widget = wibox.container.margin,
				top = 13,
				bottom = 3,
				text_to_digital("73%")
			}
		}
	}

	return widget
end

return create_net

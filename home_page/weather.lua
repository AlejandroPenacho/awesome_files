local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/weather/"
local text_to_digital = require("penacho_mods.utils.digital_screen")

local create_widget = function(width,height)
	local upper_row_height = height * 0.6

	local widget = wibox.widget {
		widget = wibox.layout.fixed.horizontal,
		id = "upper_row",
		{
			widget = wibox.widget.imagebox,
			id = "image",
			forced_width = 0.5 * width,
			image = image_dir .. "sun.png",
		},
		{
			widget = wibox.layout.fixed.vertical,
			spacing = upper_row_height * 0.1,
			{
				widget = wibox.layout.fixed.horizontal,
				id = "temperature_row",
				forced_height = 0.45 * upper_row_height,
				text_to_digital("24"),
				{
					widget = wibox.widget.textbox,
					text = "ºC"
				}
			},
			{
				widget = wibox.layout.fixed.horizontal,
				id = "wind_row",
				forced_height = 0.45 * upper_row_height,
				text_to_digital("42"),
				{
					widget = wibox.widget.textbox,
					text = "km/h"
				}
			}
		}
	}

	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_weather.py",
		1800,
		function(l_widget, stdout)
			local index = 0
			local temperature = 0
			local wind_speed = 0
			local wind_direction = 0
			local weather_image = "nothing"

			for text in string.gmatch(stdout, "([^,]+)") do

				if index == 0 then
					temperature = text
				end
				if index == 1 then
					wind_speed = text
				end
				if index == 2 then
					wind_direction = text
				end
				if index == 3 then
					weather_image = text
				end

				index = index + 1
			end

			local weather_full_image = image_dir .. weather_image .. ".png"

			widget:get_children_by_id("upper_row")[1]:set(
				1,
				wibox.widget {
					widget = wibox.widget.imagebox,
					image = weather_full_image,
					-- image = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/weather/clouds3.png",
					forced_width = 0.5 * width
				}
			)

			-- widget:get_children_by_id("image")[1].image = image_dir .. weather_image .. ".png"
			widget:get_children_by_id("temperature_row")[1]:set(1, text_to_digital(temperature))
			widget:get_children_by_id("wind_row")[1]:set(1, text_to_digital(wind_speed))
		end
	)

	return widget
end

return create_widget

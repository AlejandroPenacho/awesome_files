local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local arc_image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/circular/"
local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/cpu/"

local top_margin = 22
local left_margin = 17
local bottom_margin = 22

local create_cpu = function()
	local widget = wibox.widget {
		widget = wibox.layout.stack,
		{
			widget = wibox.widget.imagebox,
			image = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/cpu.png"
		},
		{
			widget = wibox.container.margin,
			top = 33,
			bottom = 140,
			left = 33,
			{
				widget = wibox.layout.stack,
				{
					widget = wibox.widget.imagebox,
					image = arc_image_dir .. "0_24.png"
				},
				{
					widget = wibox.container.margin,
					top = top_margin,
					left = left_margin,
					bottom = bottom_margin,
					text_to_digital("23")
				}
			}
		},
		{
			widget = wibox.container.margin,
			top = 33,
			bottom = 140,
			left = 118,
			{
				widget = wibox.layout.stack,
				{
					widget = wibox.widget.imagebox,
					image = arc_image_dir .. "0_24.png"
				},
				{
					widget = wibox.container.margin,
					top = top_margin,
					left = left_margin,
					bottom = bottom_margin,
					text_to_digital("23")
				}
			}
		},
		{
			widget = wibox.container.margin,
			top = 115,
			bottom = 58,
			left = 33,
			{
				widget = wibox.layout.stack,
				{
					widget = wibox.widget.imagebox,
					image = arc_image_dir .. "0_24.png"
				},
				{
					widget = wibox.container.margin,
					top = top_margin,
					left = left_margin,
					bottom = bottom_margin,
					text_to_digital("23")
				}
			}
		},
		{
			widget = wibox.container.margin,
			top = 115,
			bottom = 58,
			left = 118,
			{
				widget = wibox.layout.stack,
				{
					widget = wibox.widget.imagebox,
					image = arc_image_dir .. "0_24.png"
				},
				{
					widget = wibox.container.margin,
					top = top_margin,
					left = left_margin,
					bottom = bottom_margin,
					text_to_digital("23")
				}
			}
		}
	}

	local idle_cpu_cycles = {0, 0, 0, 0}
	local total_cpu_cycles = {0, 0, 0, 0}

	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_multicpu.py",
		1,
		function(x, stdout)
			local cpu_index = 0
			for idle, total in string.gmatch(stdout,"([0-9]+),([0-9]+)") do

				if cpu_index > 0 then

					local delta_idle = tonumber(idle) - idle_cpu_cycles[cpu_index]
					local delta_total = tonumber(total) - total_cpu_cycles[cpu_index]

					idle_cpu_cycles[cpu_index] = tonumber(idle)
					total_cpu_cycles[cpu_index] = tonumber(total)

					local percentage = 100 - (delta_idle/delta_total)*100

					local n_sections = tostring(math.ceil(percentage / 100 * 24))

					local text_number = tostring(math.floor(percentage))
					if #text_number == 1 then
						text_number = "0" .. text_number
					end
					if #text_number == 3 then
						text_number = "99"
					end

					local arc_image =  arc_image_dir .. n_sections .. "_24.png"

					local cpu_stack= widget:get_children()[cpu_index+1].widget

					cpu_stack:set(1,
						wibox.widget {
							widget = wibox.widget.imagebox,
							image = arc_image
						}
					)

					cpu_stack.children[2].widget = text_to_digital(text_number)


				end
				cpu_index = cpu_index + 1
			end
		end
	)

	return widget
end

local create_cpu_screen = function()
	local widget = wibox.widget {
		widget = wibox.layout.stack,
		{
			widget = wibox.widget.imagebox,
			image = image_path .. "full_background.png"
		},
		{
			widget = wibox.container.margin,
			top = 30,
			left = 10,
			right = 20,
			create_cpu()
		},
		{
			widget = wibox.widget.imagebox,
			image = image_path .. "white_stain.png"
		}
	}

	return widget
end

return create_cpu_screen

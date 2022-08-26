local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local arc_path = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/harddrive/"
local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/harddrive/"


local process_memory = function(kbytes)
	if kbytes <= 1024 then
		return { kbytes, "K" }
	end
	local megadecabytes = ( kbytes / 1024 ) * 10

	if megadecabytes <= 10240 then
		return { math.floor(mdecabytes) / 10, "M" }
	end

	local gigadecabytes = megadecabytes / 1024

	return { math.floor(gigadecabytes) / 10, "G" }

end


local create_harddrive = function(width, height)
	local disk_size = 0.5 * height
	local used_size = 0.15 * height
	local available_size = 0.15 * height
	local vertical_margin = 0.1 * height

	local vertical_single_margin = vertical_margin / 4

	local widget = wibox.widget {
		widget = wibox.container.background,
		shape = function(cr, w, h) return gears.shape.rounded_rect(cr,w,h,15) end,
		shape_border_width = 4,
		shape_border_color = "#FF0000",
		{
			widget = wibox.container.margin,
			left = width*0.1,
			right = width*0.1,
			top = vertical_single_margin,
			bottom = vertical_single_margin,
			{
				widget = wibox.layout.fixed.vertical,
				id = "main_column",
				spacing = vertical_single_margin,
				{
					widget = wibox.widget.imagebox,
					resize = true,
					image = arc_path .. "9_12.png"
				},
				{
					widget = wibox.layout.fixed.horizontal,
					spacing = 8,
					forced_height = used_size,
					{
						widget = wibox.widget.textbox,
						text = " "
					},
					text_to_digital("1.8"),
					{
						widget = wibox.widget.imagebox,
						image = arc_path .. "used.png"
					}
				},
				{
					widget = wibox.layout.fixed.horizontal,
					spacing = 8,
					forced_height = available_size,
					{
						widget = wibox.widget.textbox,
						text = " "
					},
					text_to_digital("24"),
					{
						widget = wibox.widget.imagebox,
						image = arc_path .. "free.png"
					}
				}
			}
		}
	}

	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_disk.py",
		10,
		function(l_widget, stdout)
			local index = 0

			local main_column = widget:get_children_by_id("main_column")[1]

			for text in string.gmatch(stdout, "([0-9]+)") do
				index = index + 1

				if index == 2 then

					local used_memory = process_memory(tonumber(text))
					main_column:get_children()[2]:set(
						2,
						text_to_digital(tostring(used_memory[1]))
					)

				end

				if index == 3 then
					local available_memory = process_memory(tonumber(text))
					main_column:get_children()[3]:set(
						2,
						text_to_digital(tostring(available_memory[1]))
					)

				end

				if index == 4 then
					local adjusted_percent = math.floor(tonumber(text) * 12 / 100)

					main_column:set(
						1,
						wibox.widget {
							widget = wibox.widget.imagebox,
							image = arc_path .. tostring(adjusted_percent) .. "_12.png"
						}
					)

				end
			end
		end
	)

	return widget
end


return create_harddrive

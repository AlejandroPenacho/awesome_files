local wibox = require("wibox")
local naughty = require("naughty")
local awful = require("awful")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/ram/"

local process_memory = function(kbytes)
	if kbytes <= 1024 then
		return { kbytes, "K" }
	end
	local megadecabytes = ( kbytes / 1024 ) * 10

	if megadecabytes <= 10240 then
		return { math.floor(megadecabytes) / 10, "M" }
	end

	local gigadecabytes = megadecabytes / 1024

	return { math.floor(gigadecabytes) / 10, "G" }
end

local create_ram = function(width, height)
	local chip_base_ratio = 19/45


	local widget = wibox.widget {
		widget = wibox.layout.fixed.vertical,
		{
			widget = wibox.layout.stack,
			forced_height = width*chip_base_ratio,
			{
				widget = wibox.widget.imagebox,
				image = image_path .. "background.png"
			},
			{
				widget = wibox.container.margin,
				id = "chip_margin_widget",
				left = width * 0.105,
				top = height * 0.1,
				bottom = height * 0.13,
				{
					widget = wibox.layout.fixed.horizontal,
					{
						widget = wibox.widget.imagebox,
						image = image_path .. "4_4_4.png"
					},
					{
						widget = wibox.widget.imagebox,
						image = image_path .. "4_4_4.png"
					},
					{
						widget = wibox.widget.imagebox,
						image = image_path .. "4_4_4.png"
					},
					{
						widget = wibox.widget.imagebox,
						image = image_path .. "4_4_4.png"
					},
					{
						widget = wibox.widget.imagebox,
						image = image_path .. "4_4_4.png"
					}
				}
			}
		},
		{
			widget = wibox.layout.fixed.horizontal,
			id = "data_row",
			spacing = 7,
			forced_height = 37,
			{
				widget = wibox.widget.textbox,
				text = "   "
			},
			text_to_digital("5.43"),
			{
				widget = wibox.widget.imagebox,
				image = image_path .. "total.png"
			},
			{
				widget = wibox.widget.textbox,
				text = "   "
			},
			text_to_digital("2.34"),
			{
				widget = wibox.widget.imagebox,
				image = image_path .. "avail.png"
			}
		}
	}

	
	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_ram.py",
		3,
		function(l_widget, stdout)
			local total_ram = 0
			local used_ram = 0
			local free_ram =  0
			local available_ram = 0

			local index = 1

			for text in string.gmatch(stdout, "([0-9]+)") do

				if index == 1 then
					total_ram = tonumber(text)
				end
				if index == 2 then
					free_ram = tonumber(text)
				end
				if index == 3 then
					available_ram = tonumber(text)
				end

				index = index + 1
			end


			local new_chip_row = wibox.widget {
				widget = wibox.layout.fixed.horizontal
			}

			local n_chips = 5
			local n_divs = 4
			local total_divs = n_chips * n_divs

			local full_divs = math.ceil((1 - available_ram / total_ram) * total_divs)
			local partial_divs = math.ceil((1 - free_ram / total_ram) * total_divs)

			local full_divs_to_draw = full_divs
			local partial_divs_to_draw = partial_divs

			for chip_index = 1, n_chips, 1 do

				local chip_full_divs = 0
				local chip_partial_divs = 0

				if full_divs_to_draw >= n_divs then
					chip_full_divs = n_divs
					full_divs_to_draw = full_divs_to_draw - n_divs

				elseif full_divs_to_draw == 0 then
					chip_full_divs = 0

				else
					chip_full_divs  = full_divs_to_draw
					full_divs_to_draw = 0
				end

				if partial_divs_to_draw >= n_divs then
					chip_partial_divs = n_divs
					partial_divs_to_draw = partial_divs_to_draw - n_divs

				elseif partial_divs_to_draw == 0 then
					chip_partial_divs = 0

				else
					chip_partial_divs  = partial_divs_to_draw
					partial_divs_to_draw = 0
				end


				new_chip_row:add(
					wibox.widget {
						widget = wibox.widget.imagebox,
						image = image_path .. tostring(chip_full_divs) .. "_" .. tostring(chip_partial_divs) .. "_4.png"
					}
				)

			end

			-- HERE!
			widget:get_children_by_id("chip_margin_widget")[1].widget = new_chip_row


			local total_as_text = tostring(math.floor(total_ram * 100 / (1024*1024))/100)

			if #total_as_text == 3 then
				total_as_text = total_as_text .. "0"
			end

			local available_as_text = tostring(math.floor(available_ram * 100 / (1024*1024))/100)
			if #available_as_text == 3 then
				available_as_text = available_as_text .. "0"
			end

			widget:get_children_by_id("data_row")[1]:set(
				2,
				text_to_digital(total_as_text)
			)

			widget:get_children_by_id("data_row")[1]:set(
				5,
				text_to_digital(available_as_text)
			)
		end
	)


	return widget
end

return create_ram

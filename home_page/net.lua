local wibox = require("wibox")
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local text_to_digital = require("penacho_mods.utils.digital_screen")

local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/net/"


local regularize_speed = function(speed)
	local decimal = tostring(math.floor(speed*10) - math.floor(speed)*10)

	local rounded = tostring(math.floor(speed))

	while #rounded < 3 do
		rounded = " " .. rounded
	end

	return rounded .. "." .. decimal

end



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
			forced_height = 45,
			widget = wibox.layout.fixed.vertical,
			spacing = 4,
			{
				widget = wibox.container.background,
				fg = "#FF0000",
				{
					widget = wibox.widget.textbox,
					font = "fira code 12",
					text = "Se vino"
				}
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
				text_to_digital(" 34.5"),
				{
					widget = wibox.widget.imagebox,
					image = image_dir .. "byte.png"
				}
			},
			{
				widget = wibox.layout.fixed.horizontal,
				forced_height = 30,
				spacing = 5,
				text_to_digital("621.1"),
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
		},
		{
			id = "ethernet",
			point = {x=0, y=0},
			widget = wibox.widget.imagebox,
			visible = true,
			image = image_dir .. "ethernet.png"
		}
	}

	local total_recv = 0
	local total_sent = 0

	local update_ip = function(x, stdout)
		local index = 0
		local internal_ip = ""
		local external_ip = ""
		for text in string.gmatch(stdout, "([0-9.]+)") do
			if index == 0 then
				internal_ip = text
			end
			if index == 1 then
				external_ip = text
			end
			index = index + 1
		end

		widget:get_children_by_id("user")[1].widget = text_to_digital(internal_ip)
		widget:get_children_by_id("router")[1]:set(
			2,
			text_to_digital(external_ip)
		)
	end

	local update_wifi = function(x,stdout)
		local index = 0
		local router_name = ""
		local signal_strength = ""

		for text in string.gmatch(stdout,"([^,]+)") do
			if index == 0 then
				router_name = text
			end
			if index == 1 then
				signal_strength = text
			end
			index = index + 1
		end

		local signal_index = 0

		if tonumber(signal_strength) ~= nil then
			signal_index = math.floor(tonumber(signal_strength)/25) + 1
		end

		if signal_index == 5 then
			signal_index = 4
		end


		widget:get_children_by_id("router")[1].children[1].widget.text = router_name


		widget:get_children_by_id("wifi")[1].children[1].image = image_dir .. "wifi_" .. tostring(signal_index) .. "_4.png"
		widget:get_children_by_id("wifi")[1].children[2].widget = text_to_digital(signal_strength .. "%")
	end

	local update_speed = function(x,stdout)
		local delta_t = 1

		local index = 0
		local new_recv = 0
		local new_sent = 0
		local eth_on = false
		local wifi_on = false

		for text in string.gmatch(stdout, "([0-9]+)") do
			if index == 0 then
				if tonumber(text) == 1 then
					eth_on = true
				end
			end
			if index == 1 then
				if tonumber(text) == 1 then
					wifi_on = true
				end
			end
			if index == 2 then
				new_recv = tonumber(text)
			end
			if index == 3 then
				new_sent = tonumber(text)
			end
			index = index + 1
		end

		local recv = (new_recv - total_recv) / delta_t
		local sent = (new_sent - total_sent) / delta_t

		local recv_unit = "byte"
		local sent_unit = "byte"


		local recv_n_arrows = 0
		local sent_n_arrows = 0

		if recv > 0 then
			recv_n_arrows = math.min(math.floor(math.log10(recv)) + 1, 6)
		end
		if sent > 0 then
			sent_n_arrows = math.min(math.floor(math.log10(sent)) + 1, 6)
		end

		if recv >= (1024^2)*1000 then
			recv_unit = "giga"
			recv = recv / 1024^3

		elseif recv >= 1024*1000 then
			recv_unit = "mega"
			recv = recv / 1024^2

		elseif recv >= 1000 then
			recv_unit = "kilo"
			recv = recv / 1024

		end
		local recv_text = regularize_speed(recv)

		if sent >= (1024^2)*1000 then
			sent_unit = "giga"
			sent = sent / 1024^3

		elseif sent >= 1024*1000 then
			sent_unit = "mega"
			sent = sent / 1024^2

		elseif sent >= 1000 then
			sent_unit = "kilo"
			sent = sent / 1024

		end
		local sent_text = regularize_speed(sent)

		total_recv = new_recv
		total_sent = new_sent

	
		widget:get_children_by_id("ethernet")[1].visible = eth_on

		widget:get_children_by_id("speed_signal")[1].children[1].image = image_dir .. "speed_" .. tostring(sent_n_arrows) .. "_6.png"

		widget:get_children_by_id("speed_text")[1].children[1]:set(
			1,
			text_to_digital(sent_text)
		)

		widget:get_children_by_id("speed_text")[1].children[1].children[2].image = image_dir .. sent_unit .. ".png"



		widget:get_children_by_id("speed_signal")[1].children[2].widget.image = image_dir .. "speed_" .. tostring(recv_n_arrows) .. "_6.png"

		widget:get_children_by_id("speed_text")[1].children[2] :set(
			1,
			text_to_digital(recv_text)
		)

		widget:get_children_by_id("speed_text")[1].children[2].children[2].image = image_dir .. recv_unit .. ".png"
	end

	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_ip.py",
		1200,
		update_ip
	)

	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_wifi.py",
		5,
		update_wifi
	)

	awful.widget.watch(
		"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_net.py",
		1,
		update_speed
	)

	return widget
end

return create_net

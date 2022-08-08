local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")
local watch = require("awful.widget.watch")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local battery_path = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/battery/"
local volume_path = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/volume/"

local battery_widget = function()
	local widget = wibox.widget {
		widget = wibox.layout.stack,
		{
			image = battery_path .. "base.png",
			widget = wibox.widget.imagebox
		},
		{
			widget = wibox.container.margin,
			top = 2,
			bottom = 3,
			left = 2,
			{
				widget = wibox.container.background,
				-- shape = function(cr, w, h) gears.shape.rounded_rect(cr,40,h,5) end,
				shape = function(cr, w, h) gears.shape.rounded_rect(cr,80,h,5) end,
				bg = "#000000",
				fg = "#FF0000",
				shape_border_width = 1,
				shape_border_color = "#FFFFFF",
				{
					widget = wibox.container.margin,
					top = 2,
					bottom = 2,
					left = 6,
					right = 6,
					{
						widget = wibox.layout.fixed.horizontal,
						id = "digital_screen",
						spacing = 4,
						{
							image = battery_path .. "battery.png",
							widget = wibox.widget.imagebox
						},
						text_to_digital("50"),
						{
							text = " ",
							widget = wibox.widget.textbox
						},
						{
							image = volume_path .. "volume.png",
							widget = wibox.widget.imagebox
						},
						text_to_digital("50")
					}
				}
			}
		}
	}

	local update_battery_widget = function(l_widget, stdout)
        local charge = 0
        local status
        for s in stdout:gmatch("[^\r\n]+") do
            local cur_status, charge_str, _ = string.match(s, '.+: ([%a%s]+), (%d?%d?%d)%%,?(.*)')

            if cur_status ~= nil and charge_str ~=nil then
                local cur_charge = tonumber(charge_str)
                if cur_charge > charge then
                    status = cur_status
                    charge = cur_charge
                end
            end
        end

		if charge == 100 then
			charge = "FC"
		else
			charge = tostring(charge)
			if #charge == 1 then
				charge = "0" .. charge
			end
		end

		widget:get_children_by_id("digital_screen")[1]:set(2, text_to_digital(charge))

		if status == "Discharging" then
			widget:get_children_by_id("digital_screen")[1]:get_children()[1].image =
				battery_path .. "battery.png"
		else
			widget:get_children_by_id("digital_screen")[1]:get_children()[1].image =
				battery_path .. "battery_charging.png"
		end
	end

	local update_volume_widget = function(l_widget, stdout)
		local volume = tonumber(stdout)
		local output
		if volume == 100
		then
			output = "H1"
		else
			output = tostring(volume)
			if #output == 1 then
				output = "0" .. output
			end
		end
		widget:get_children_by_id("digital_screen")[1]:set(
			5,
			text_to_digital(output)
		)
	end

    watch("acpi", 5, update_battery_widget, widget)

   	_, wibar_volume_timer = watch("/home/alejandro/.config/awesome/penacho_mods/scripts/get_volume.sh", 5, update_volume_widget, widget)

	return widget
end

return battery_widget

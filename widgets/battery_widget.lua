local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/battery/"


local battery_widget = function()

	local widget = wibox.widget {
		{
			{
				{
					image = image_path .. "battery.png",
					widget = wibox.widget.imagebox
				},
				text_to_digital("50"),
				{
					image = image_path .. "battery_discharging.png",
					widget = wibox.widget.imagebox
				},
				spacing = 4,
				widget = wibox.layout.fixed.horizontal
			},
			top = 4,
			bottom = 4,
			left = 4,
			right = 4,
			widget = wibox.container.margin
		},
		shape = function(cr, w, h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = "#000000",
		fg = "#FF0000",
		shape_border_width = 1,
		shape_border_color = "#FFFFFF",
		widget = wibox.container.background
	}

	local update_widget = function(l_widget, stdout)
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

		-- widget:get_children()[1]:get_children()[1]:get_children()[2].text = tostring(charge)
		widget:get_children()[1]:get_children()[1]:set(2, text_to_digital(tostring(charge)))

		if status == "Discharging" then
			widget:get_children()[1]:get_children()[1]:get_children()[3].image =
				image_path .. "battery_discharging.png"
		else
			widget:get_children()[1]:get_children()[1]:get_children()[3].image =
				image_path .. "battery_charging.png"
		end


	end

    watch("acpi", 5, update_widget, widget)

	return widget

end

return battery_widget

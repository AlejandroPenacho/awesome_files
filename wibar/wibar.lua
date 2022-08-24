local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")


local battery_widget = require("penacho_mods.wibar.battery_widget")
local custom_taglist = require("penacho_mods.wibar.custom_taglist")
local pomodoro = require("penacho_mods.wibar.pomodoro")
local my_textclock = require("penacho_mods.wibar.text_clock")
local my_layout = require("penacho_mods.wibar.layout")


local create_wibar = function(screen, textclock)
	local wibar = awful.wibar({
		height = 25,
		position = "bottom",
		bg="nil",
		screen=screen
	})

	local taglist = custom_taglist(screen)

	wibar:setup {
		widget = wibox.container.margin,
		bottom = 2,
		{
			layout = wibox.layout.align.horizontal,
			{ 	-- Left widgets
				id = "left",
				layout = wibox.layout.fixed.horizontal,
				spacing = -1,
				battery_widget(),
				custom_taglist(screen),
				pomodoro(),
				{
					widget = wibox.widget.imagebox,
					image = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/right_top.png"
				}
			},

			{ -- Center widgets
				layout = wibox.layout.fixed.horizontal
			},

			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				spacing = -5,
				{
					widget = wibox.widget.imagebox,
					image = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/left_top.png"
				},
				my_textclock(),
				wibox.widget.textbox(" "),
				my_layout()
				-- wibox.widget.textbox(" ")
			}
		}
	}

	local original_struts = wibar:struts()
	original_struts["bottom"] = original_struts["bottom"] - 3
	wibar:struts(original_struts)

	local tags = screen.tags
	for i=1,9,1 do
		tags[i]:connect_signal(
			"property::selected",
			function(t)
				wibar:get_children_by_id("left")[1]:set(
					2,
					custom_taglist(screen)
				)
			end
		)
		tags[i]:connect_signal(
			"property::icon",
			function(t)
				wibar:get_children_by_id("left")[1]:set(
					2,
					custom_taglist(screen)
				)
			end
		)
	end

	return wibar
end

return create_wibar

local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local text_to_digital = require("penacho_mods.utils.digital_screen")

local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/pomodoro/"

local pomodoro = function()
	local widget = wibox.widget {
		widget = wibox.container.background,
		shape = function(cr, w, h) gears.shape.rounded_rect(cr,w,h,5) end,
		bg = "#000000",
		fg = "#FF0000",
		shape_border_width = 1,
		shape_border_color = "#FFFFFF",
		{
			widget = wibox.container.margin,
			top = 2,
			bottom = 2,
			left = 8,
			right = 8,
			{
				id = "main",
				widget = wibox.layout.fixed.horizontal,
				spacing = 5,
				text_to_digital("17:42"),
				{
					id = "play_image",
					widget = wibox.widget.imagebox,
					image = image_dir .. "pause.png"
				},
				{
					id = "task",
					widget = wibox.widget.textbox,
					forced_width = 120,
					text = "    Do nothing    "
				},
				text_to_digital("3-8"),
				{
					id = "complete_image",
					widget = wibox.widget.imagebox,
					image = image_dir .. "completed.png"
				}
			}
		}
	}

	awful.widget.watch('pomodoro gettime', 1, function(_, stdout)
		if stdout == "Timer not running\n" then

			widget:get_children_by_id("main")[1]:set(
				1,
				text_to_digital("     ")
			)
			widget:get_children_by_id("play_image")[1].image = image_dir .. "empty_play.png"

			widget:get_children_by_id("task")[1].text = ""

			widget:get_children_by_id("main")[1]:set(
				4,
				text_to_digital("   ")
			)

			widget:get_children_by_id("complete_image")[1].image = image_dir .. "not_completed.png"

			return
		end

		local index = 0

		local task = ""
		local current_pomodoros = "0"
		local expected_pomodoros = "0"
		local task_status = ""
		local time_string = ""
		for text in string.gmatch(stdout, "([^,]+)") do
			if index == 0 then
				task = text
			end
			if index == 1 then
				current_pomodoros = text
			end
			if index == 2 then
				expected_pomodoros = text
			end
			if index == 3 then
				task_status = text
			end
			if index == 4 then
				time_string = text
			end

			index = index + 1
		end

		local status_image = ""
		if task_status == "F" then
			status_image = "completed.png"
		else
			status_image = "not_completed.png"
		end

		local time = ""
		for text in string.gmatch(time_string, "[0-9]+:[0-9]+") do
			time = text
		end
		while #time < 5 do
			time = " " .. time
		end

		local play_image = "play.png"
		if string.find(time_string, "paused") ~= nil then
			play_image = "pause.png"
		end

		widget:get_children_by_id("main")[1]:set(
			1,
			text_to_digital(time)
		)
		widget:get_children_by_id("play_image")[1].image = image_dir .. play_image

		widget:get_children_by_id("task")[1].text = "  " .. task .. "  "

		widget:get_children_by_id("main")[1]:set(
			4,
			text_to_digital(current_pomodoros .. "-" .. expected_pomodoros)
		)

		widget:get_children_by_id("complete_image")[1].image = image_dir .. status_image
	end)

	return widget
end

return pomodoro

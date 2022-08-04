local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local tags = awful.screen.focused().tags

local the_text = wibox.widget {
	text = "We have " .. tostring(#tags) .. " tags",
	align = "center",
	valign = "center",
	font = "sans 24",
	widget = wibox.widget.textbox
}

local topleft_wibox = wibox({
	widget = the_text,
    x = 30,
    y = 30,
    width = 300,
    height = 200,
    bg = "#111111F5",
	border_width = 2,
	border_color = "#FFFFFFF5",
	shape = function(cr,width,height) return gears.shape.rounded_rect(cr,width,height, 20) end,
    visible = true,
	opacity=1.0
})

local the_other_text = wibox.widget {
	text = "Se viene!",
	align = "center",
	valign = "center",
	font = "sans 24",
	widget = wibox.widget.textbox
}

local left_wibox = wibox({
	widget = wibox.widget {
		 text_to_digital("00"),
		top = 10,
		bottom = 10,
		left = 10,
		top = 10,
		widget = wibox.container.margin
	},
    x = 30,
    y = 260,
    width = 440,
    height = 100,
    bg = "#111111F5",
	border_width = 2,
	border_color = "#FFFFFFF5",
	shape = function(cr,width,height) return gears.shape.rounded_rect(cr,width,height, 20) end,
    visible = true,
	opacity=1.0
})

local top_wibox = wibox({
	widget = the_text,
    x = 360,
    y = 30,
    width = 660,
    height = 100,
    bg = "#111111F5",
	border_width = 2,
	border_color = "#FFFFFFF5",
	shape = function(cr,width,height) return gears.shape.rounded_rect(cr,width,height, 20) end,
    visible = true,
	opacity=1.0
})

local total_idle_cycles = 0
local total_cycles = 0

awful.widget.watch(
	"python3 /home/alejandro/.config/awesome/penacho_mods/scripts/get_cpu.py",
	1,
	function(widget, stdout)
		local index = 1
		local fields = {}
		for st in stdout:gmatch("[^,]+") do
			fields[index] = st
			index = index + 1
		end

		local new_idle_cycles = tonumber(fields[1])
		local new_total_cycles = tonumber(fields[2])
		
		local delta_idle_cycles = new_idle_cycles - total_idle_cycles
		local delta_total_cycles = new_total_cycles - total_cycles

		total_idle_cycles = new_idle_cycles
		total_cycles = new_total_cycles

		local cpu_load = 100 - delta_idle_cycles/delta_total_cycles*100
		cpu_load = tostring(math.floor(cpu_load))

		if #cpu_load == 1
		then
			cpu_load = "0" .. cpu_load
		end

		left_wibox.widget.widget = text_to_digital(cpu_load)
	end
)



return {topleft_wibox, left_wibox, top_wibox }

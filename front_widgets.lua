local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

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
	widget = the_other_text,
    x = 30,
    y = 260,
    width = 440,
    height = 200,
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


return {topleft_wibox, left_wibox, top_wibox }

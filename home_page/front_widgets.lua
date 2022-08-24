local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local tags = awful.screen.focused().tags

local cpu_widget = require("penacho_mods.home_page.cpu")
local harddrive_widget = require("penacho_mods.home_page.harddrive")
local ram_widget = require("penacho_mods.home_page.ram")

local background_box = wibox({
	widget = wibox.widget {
		widget = wibox.widget.imagebox,
		image = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/base.png"
	},
    x = 0,
    y = 0,
	bg="#00000000",
    width = 1366,
    height = 768,
    visible = true
})

local ram_box = wibox({
	widget = ram_widget(),
    x = 200,
    y = 50,
    width = 280,
    height = 220,
    bg = "#00000000",
    visible = true,
	opacity=1.0
})

local cpu_box = wibox({
	widget = cpu_widget(),
    x = 30,
    y = 300,
    width = 260,
    height = 280,
    bg = "#00000000",
    visible = true,
	opacity=1.0
})

local harddrive_box = wibox({
	widget = harddrive_widget(),
	x = 30,
	y = 50,
	width = 180,
	height = 220,
	bg = "#00000000",
	visible = true,
	opacity = 1.0
})


return {background_box, harddrive_box, cpu_box, ram_box }

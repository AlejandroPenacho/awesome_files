local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

local text_to_digital = require("penacho_mods.utils.digital_screen")

local tags = awful.screen.focused().tags

local cpu_widget = require("penacho_mods.home_page.cpu")
local ram_widget = require("penacho_mods.home_page.ram")
local harddrive_widget = require("penacho_mods.home_page.harddrive")
local weather_widget = require("penacho_mods.home_page.weather")
local net_widget = require("penacho_mods.home_page.net")

local background_box = wibox({
	widget = wibox.widget {
		widget = wibox.widget.imagebox,
		image = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/base.png"
	},
    x = 0,
    y = 0,
	bg="#00000000",
    width = 1366,
    height = 743,
    visible = true
})

local cpu_box = wibox({
	widget = cpu_widget(220),
    x = 50,
    y = 370,
    width = 220,
    height = 220,
    bg = "#00000000",
    visible = true,
	opacity=1.0
})

local ram_box = wibox({
	widget = ram_widget(280, 220),
    x = 245,
    y = 70,
    width = 280,
    height = 170,
    bg = "#00000000",
    visible = true,
	opacity=1.0
})

local harddrive_box = wibox({
	widget = harddrive_widget(150, 220),
	x = 50,
	y = 70,
	width = 150,
	height = 220,
	bg = "#00000000",
	visible = true,
	opacity = 1.0
})

local weather_box = wibox({
	widget = weather_widget(245,170),
	x = 920,
	y = 130,
	width = 245,
	height = 170,
	bg = "#00000000",
	visible = true,
	opacity = 1.0
})

local net_box = wibox({
	widget = net_widget(240,312),
	x = 920,
	y = 360,
	width = 240,
	height = 312,
	bg = "#00000000",
	visible = true,
	opacity = 1.0
})

local white_stain = wibox({
	widget = wibox.widget {
		widget = wibox.widget.imagebox,
		image = "/home/alejandro/.config/awesome/penacho_mods/png/home_page/white_stain.png"
	},
    x = 0,
    y = 0,
	bg="#00000000",
    width = 1366,
    height = 743,
    visible = true
})

return {
	background_box,
	harddrive_box,
	cpu_box,
	ram_box,
	weather_box,
	net_box,
	white_stain
}

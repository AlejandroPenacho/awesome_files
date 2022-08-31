local wibox = require("wibox")

local image_path = "/home/alejandro/.config/awesome/penacho_mods/png/digital_screen/"

local char_to_screen = function(char)
	return wibox.widget {
		image = image_path .. char .. ".png",
		resize = true,
		widget = wibox.widget.imagebox
	}
end

local text_to_screen = function(text)
	local output = wibox.widget {
		layout = wibox.layout.fixed.horizontal
	}

	for i = 1, #text do
		local c = text:sub(i,i)

		if c == " " then
			c = "empty"
		end

		if c == "." then
			c = "dot"
		end

		if c == "-" then
			c = "null"
		end

		output:add(char_to_screen(c))
	end

	return output
end

return text_to_screen


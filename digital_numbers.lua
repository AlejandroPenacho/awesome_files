local wibox = require("wibox")

local digit_path = "/home/alejandro/.config/awesome/penacho-mods/png/digits/"

local digit_to_img = function(digit)
	return wibox.widget {
		image = digit_path .. tostring(digit) .. ".png",
		resize = true,
		widget = wibox.widget.imagebox
	}
end

local number_to_img = function(number)
	local text = tostring(number)

	local output = wibox.widget {
		layout = wibox.layout.fixed.horizontal
	}

	for i = 1, #text do
		local c = text:sub(i,i)

		output:add(digit_to_img(c))
	end

	return output
end

return number_to_img


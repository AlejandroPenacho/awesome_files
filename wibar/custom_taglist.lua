local wibox = require("wibox")

local tag_is_empty = function(tag)
	local clients = tag:clients()
	return #clients == 0
end

local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/taglist/"

local filter_tag = function(tag)
	if tag.selected then
		return true
	end

	local clients = tag:clients()

	if #clients ~= 0 then
		return true
	end

	return false
end


local create_taglist = function(screen) 
	local tags = screen.tags

	local taglist = wibox.widget {
		widget = wibox.layout.fixed.horizontal,
		spacing = -8,
	}

	for i = 1,9,1
	do
		if filter_tag(tags[i]) then
			local image_path
			local top_margin
			if tags[i].selected
			then
				image_path = image_dir .. "pressed_button.png"
				top_margin = 4
			else
				image_path = image_dir .. "unpressed_button.png"
				top_margin = 2
			end

			taglist:add(wibox.widget {
				widget = wibox.layout.stack,
				{
					widget = wibox.widget.imagebox,
					id = "image",
					image = image_path
				},
				{
					widget = wibox.container.margin,
					top = top_margin,
					left = 8,
					{
						widget = wibox.container.background,
						fg = "#E6AACE",
						{
							widget = wibox.layout.fixed.horizontal,
							{
								text = tags[i].name,
								valign = "center",
								font = "sans 9",
								opacity = opc,
								widget = wibox.widget.textbox
							},
							{
								widget = wibox.container.margin,
								top = 3,
								bottom = 7 - top_margin,
								right = 3,
								left = 4,
								{
									widget = wibox.widget.imagebox,
									image = tags[i].icon
								}
							}
						},
					},
				}
			})
		end

	end

	return taglist
end

return create_taglist

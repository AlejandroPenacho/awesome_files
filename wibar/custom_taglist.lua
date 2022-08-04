local wibox = require("wibox")

local tag_is_empty = function(tag)
	local clients = tag:clients()
	return #clients == 0
end

local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/taglist/"

local create_taglist = function(screen) 
	local tags = screen.tags

	local taglist = wibox.widget {
		widget = wibox.layout.fixed.horizontal,
		spacing = -1
	}

	taglist:add(wibox.widget {
		image = image_dir .. "left.png",
		widget = wibox.widget.imagebox
	})

	for i = 1,9,1
	do
		local image_path
		local top_margin
		if tags[i].selected
		then
			image_path = image_dir .. "pressed_button.png"
			top_magin = 4
		else
			image_path = image_dir .. "unpressed_button.png"
			top_magin = 2
		end

		taglist:add(wibox.widget {
			{
				image = image_path,
				widget = wibox.widget.imagebox
			},
			{
				{
					text = tags[i].name,
					valign = "center",
					font = "sans 7",
					opacity = opc,
					widget = wibox.widget.textbox
				},
				top = top_margin,
				left = 9,
				widget = wibox.container.margin
			},
			widget = wibox.layout.stack
		})

		tags[i]:connect_signal(
			"property::selected",
			function(t)
				local image_path
				local top_margin
				if t.selected
				then
					image_path = image_dir .. "pressed_button.png"
					top_margin = 4
				else
					image_path = image_dir .. "unpressed_button.png"
					top_margin = 2
				end

				local all_children = taglist:get_children()
				local image_widget = all_children[i+1]:get_children()[1]
				image_widget.image = image_path

				all_children[i+1]:get_children()[2].top = top_margin

				-- No way this ACTUALLY works
				taglist:set_visible(false)
				taglist:set_visible(true)
			end
		)
	end

	taglist:add(wibox.widget {
		image = image_dir .. "right.png",
		widget = wibox.widget.imagebox
	})

	--[[
	local children = taglist:get_children()

	local texbox = children[3]:get_children()[1]
	texbox.text = "A"
	]]

	return taglist
end

return create_taglist

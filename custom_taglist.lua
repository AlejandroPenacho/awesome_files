local wibox = require("wibox")

local tag_is_empty = function(tag)
	local clients = tag:clients()
	return #clients == 0

end

local create_taglist = function(screen) 
	local tags = screen.tags

	local taglist = wibox.widget {
		widget = wibox.layout.fixed.horizontal

	}

	for i = 1,9,1
	do
		local opc
		if tags[i].selected
		then
			opc = 1.0
		else
			opc = 0.1
		end

		taglist:add(wibox.widget {
			{
				text = tags[i].name,
				valign = "center",
				font = "sans 12",
				opacity = opc,
				widget = wibox.widget.textbox
			},
			left = 5,
			right = 5,
			widget = wibox.container.margin
		})

		tags[i]:connect_signal(
			"property::selected",
			function(t)
				local opc
				if t.selected
				then
					opc = 1.0
				else
					if tag_is_empty(t)
					then
						opc = 0.1
					else
						opc = 0.5
					end
				end

				local all_children = taglist:get_children()
				local texbox = all_children[i]:get_children()[1]
				texbox.opacity = opc

				-- No way this ACTUALLY works
				taglist:set_visible(false)
				taglist:set_visible(true)
			end
		)
	end

	--[[
	local children = taglist:get_children()

	local texbox = children[3]:get_children()[1]
	texbox.text = "A"
	]]

	return taglist
end

return create_taglist

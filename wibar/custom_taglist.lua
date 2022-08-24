local wibox = require("wibox")
local naughty = require("naughty")


local image_dir = "/home/alejandro/.config/awesome/penacho_mods/png/wibar/taglist/"

local filter_tag = function(tag)
	if tag.selected then
		return true
	end

	local clients = tag:clients()

	if #clients ~= 0 then
		return true
	end

	if tag.icon ~= nil then
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

			local widget = wibox.widget {
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
			}
			taglist:add(widget)

			widget:connect_signal("button::press",
				function(something,lx,ly,button)
					if button == 1 then
						tags[i]:view_only()
					end

					if button == 3 then
						mytagiconmenu:show()
					end
				end
			)
		end
	end

	return taglist
end

return create_taglist

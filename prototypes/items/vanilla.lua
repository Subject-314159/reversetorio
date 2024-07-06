-- Add item for factorio logo (so that we can select/copy it)
local logo = data.raw["container"]["factorio-logo-22tiles"]
local itm = {
    type = "item",
    name = "factorio-logo-22tiles",
    stack_size = 50,
    place_result = "factorio-logo-22tiles"
}
if logo.icon then
    itm.icon = logo.icon
    itm.icon_size = logo.icon_size
    itm.icon_mipmaps = logo.icon_mipmaps
else
    itm.icons = logo.icons
end
data:extend({itm})

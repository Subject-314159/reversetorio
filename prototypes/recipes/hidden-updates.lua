local util = require("lib.util")
-- Create placeholder recipes for everything that is created but not crafted, e.g. rocket launch products and boilers
-- Generate array of fluid boiler conversions
local blr_rec = {{
    type = "item-subgroup",
    group = "other",
    name = "boiler-recipes"
}}
for _, b in pairs(data.raw["boiler"]) do
    local ing = {}
    if b.fluid_box and b.fluid_box.filter then
        local prop = {
            type = "fluid",
            name = b.fluid_box.filter,
            amount = 1
        }
        table.insert(ing, prop)
    else
        for _, f in pairs(data.raw["fluid"]) do
            local prop = {
                type = "fluid",
                name = b.fluid_box.filter,
                amount = 1
            }
            table.insert(ing, prop)
        end
    end

    local out
    out = {}
    if b.output_fluid_box and b.output_fluid_box.filter then
        local prop = {
            type = "fluid",
            name = b.output_fluid_box.filter,
            amount = 1
        }
        table.insert(out, prop)
    else
        for _, f in pairs(data.raw["fluid"]) do
            local prop = {
                type = "fluid",
                name = b.output_fluid_box.filter,
                amount = 1
            }
            table.insert(out, prop)
        end
    end

    for _, i in pairs(ing) do
        for _, o in pairs(out) do
            local prop = {
                type = "recipe",
                name = "boiler-" .. i.name .. "-to-" .. o.name,
                ingredients = {{
                    type = "fluid",
                    name = i.name,
                    amount = 1
                }},
                results = {{
                    type = "fluid",
                    name = o.name,
                    amount = 1
                }},
                category = "crafting-with-fluid",
                subgroup = "boiler-recipes",
                -- Since this is a "shadow" recipe it doesn't need to be shown in the crafting gui
                enabled = false,
                hidden = true,
                hide_from_stats = true,
                hide_from_player_crafting = true,
                allow_decomposition = false,
                allow_as_intermediate = false,
                allow_intermediates = false,
                always_show_made_in = false
            }
            table.insert(blr_rec, prop)
        end
    end
end

data:extend(blr_rec)
-- TODO: Also include burnt result items or not?
-- TODO: Check if this is also required for capsules

-- Create array of item prototypes with rocket launch result and recipes
local irl = {}
local irl_rec = {{
    type = "recipe-category",
    name = util.const.ROCKET_CAT
}, {
    type = "item-subgroup",
    name = util.const.ROCKET_CAT,
    group = "other"
}}
local inv_rl = {}
for _, t in pairs(util.itypes) do
    for _, p in pairs(data.raw[t]) do
        -- Get rocket launch products
        local pr
        if p.rocket_launch_products then
            pr = p.rocket_launch_products
        elseif p.rocket_launch_product then
            pr = {p.rocket_launch_product}
        end

        if pr then
            table.insert(irl, p)

            local prop = {
                type = "recipe",
                name = util.const.ROCKET_CAT .. "-" .. p.name,
                category = util.const.ROCKET_CAT,
                ingredients = {{p.name, 1}},
                results = pr,
                subgroup = util.const.ROCKET_CAT,
                hidden = true
            }
            table.insert(irl_rec, prop)

            -- Construct inverse rocket launch products
            for _, i in pairs(pr) do
                local itm
                if i.name then
                    itm = util.getItemPrototypeByName(i.name)
                else
                    itm = util.getItemPrototypeByName(i[1])
                end

                if itm then

                    -- Create new rocket launch product
                    local amount = 0
                    local prop = {
                        type = "item",
                        name = p.name
                    }
                    if util.itemIsFluid(p.name) then
                        prop.type = "fluid"
                    end

                    -- Correct for amount depending on which porperty in i was given
                    if i.amount then
                        prop.amount = i.amount
                        amount = -1
                    end
                    if i.amount_min then
                        prop.amount_min = i.amount_min
                        amount = -1
                    end
                    if i.amount_max then
                        prop.amount_max = i.amount_max
                        amount = -1
                    end
                    if i.probability then
                        prop.probability = i.probability
                    end
                    if amount >= 0 then
                        prop.amount = i[2]
                    end

                    -- Add the rocket launch product to the item array
                    if inv_rl[itm.name] then
                        table.insert(inv_rl[itm.name], prop)
                    else
                        inv_rl[itm.name] = {prop}
                    end
                end
            end

        end
    end
end
data:extend(irl_rec)

-- Clear previous rocket launch products
for _, i in pairs(irl) do
    i.rocket_launch_product = nil
    i.rocket_launch_products = nil
end

-- Add new rocket launch products
for n, rl in pairs(inv_rl) do
    local itm = util.getItemPrototypeByName(n)
    itm.rocket_launch_products = rl
end

-- Unhide recipes for rocket building & add to our subgroup
for _, rs in pairs(data.raw["rocket-silo"]) do

    if rs.fixed_recipe then
        local r = data.raw["recipe"][rs.fixed_recipe]
        -- r.hidden = false
        r.subgroup = util.const.ROCKET_CAT
    end

end

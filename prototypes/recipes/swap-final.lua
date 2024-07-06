local util = require("lib.util")
local new = {}

local function doRecipeMagic(r)

    if not settings.startup["retain-original-recipes"].value then
        ----------
        -- Option 1: Reverse recipe without creating new recipe
        ----------
        util.makeRecipeSwapped(r)
        return r
    else
        ----------
        -- Option 2: Create the reverse recipe and add to array
        ----------
        local rec = util.getCopyReverseRecipe(r)
        table.insert(new, rec)
        return rec
    end
end

-- Create reverse recipes for recipes that are unlocked via the tech tree
for _, t in pairs(data.raw["technology"]) do
    local ta = {}

    -- Create reverse recipe for all unlock recipes in this tech
    if t.effects then
        for _, e in pairs(t.effects) do
            if e.type == "unlock-recipe" and (not util.arrayHasValue(util.recipesToIgnore, e.recipe)) then
                local r = data.raw["recipe"][e.recipe]
                if r and not util.arrayHasValue(util.categoriesToIgnore, r.category) and
                    not util.arrayHasValue(util.subgroupsToIgnore, r.subgroup) then
                    local rec = doRecipeMagic(r)

                    if settings.startup["retain-original-recipes"].value then
                        -- Option 2 pt.2 Add new unlock recipe to array
                        local prop = {
                            type = "unlock-recipe",
                            recipe = rec.name
                        }
                        table.insert(ta, prop)
                    end
                end
            end
        end

        -- Add each new reverse recipe to technology unlock
        for _, a in pairs(ta) do
            table.insert(t.effects, a)
        end
    end
end

-- Swap recipes without unlock tech
for _, rn in pairs(util.recipesWithoutUnlockTech) do
    local r = data.raw["recipe"][rn]
    doRecipeMagic(r)
end

-- Add new items if there are any, based on mod settings
if #new > 0 then
    data:extend(new)
end

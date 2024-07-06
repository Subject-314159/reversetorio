local util = require("lib.util")

-- Update flag of rocket part
-- local r = data.raw["item"]["rocket-part"]
-- r.flags = nil

-- Remove hidden flag for each fixed rocket silo recipe's output item and change stack size of all affected items to 100
for _, s in pairs(data.raw["rocket-silo"]) do
    if s.fixed_recipe then
        -- Get fixed recipe
        local rec = data.raw["recipe"][s.fixed_recipe]
        local r = util.getResultsNormalized(rec)

        -- Loop through recipe results
        for _, res in pairs(r) do
            -- Get the item prototype
            local itm = util.getItemPrototypeByName(res.name)
            if itm and itm.flags and #itm.flags > 0 then
                for i = 1, #itm.flags, 1 do
                    -- Check if the item flag is hidden, if so remove from flags array
                    if itm.flags[i] == "hidden" then
                        table.remove(itm.flags, i)
                    end
                end
            end
        end
    end

    -- Go through all crafting categories
    for _, c in pairs(s.crafting_categories) do
        -- Go through all recipes with those crafting categories
        for _, r in pairs(data.raw["recipe"]) do
            if r.category == c then
                -- Get combined list of ingredients and results used in this recipe
                local rec = util.getRecipePointer(r)
                local ingredients = util.getIngredientsNormalized(rec)
                local results = util.getResultsNormalized(rec)
                for _, res in pairs(ingredients) do
                    table.insert(results, res)
                end

                -- Go through all ingredients/results
                for _, res in pairs(results) do
                    -- Get the actual item prototype and change stack size to 100 (only if smaller)
                    local itm = util.getItemPrototypeByName(res.name)
                    if itm and itm.stack_size < 100 then
                        itm.stack_size = 100
                    end
                end
            end
        end
    end
end

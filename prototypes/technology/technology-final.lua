local util = require("lib.util")
-- -- TODO: Update the sort order based on the new dependency order
-- -- Right now the sort order is based on bottom-up, but we are going to be inverse traversing top-down

for _, t in pairs(data.raw["technology"]) do
    local ptr
    if t.normal then
        ptr = t.normal
    elseif t.expensive then
        ptr = t.expensive
    else
        ptr = t
    end

    -- Add 1 research essence as ingredient for tech research
    if ptr then
        local prop = {"research-essence", 1}
        table.insert(ptr.unit.ingredients, prop)
    end
end

-- -- Attach spawn recipes to correct technology in tech tree and hide the recipe
-- for _, r in pairs(data.raw["recipe"]) do
--     if r.category == "finite-improbability" or r.category == "grouped-improbability" then
--         -- Get the end item
--         local itm
--         local rec = util.getRecipePointer(r)
--         local results = util.getResultsNormalized(rec)
--         for _, res in pairs(results) do
--             if res.name ~= "spawn-essence" and res.name ~= "research-essence" then
--                 -- This technology unlocks our end product, set flag
--                 itm = util.getItemPrototypeByName(res.name)
--                 if itm then
--                     -- Add as unlock technology
--                     for _, t in pairs(data.raw["technology"]) do
--                         if t.effects then
--                             -- Check if the technology unlocks a recipe that produces our end result
--                             local ismatch = false
--                             for _, e in pairs(t.effects) do
--                                 if e.type == "unlock-recipe" then
--                                     local rc = data.raw["recipe"][e.recipe]
--                                     if rc and rc.category ~= "finite-improbability" and rc.category ~=
--                                         "grouped-improbability" then
--                                         local rp = util.getRecipePointer(rc)
--                                         local resp = util.getResultsNormalized(rp)
--                                         for _, rs in pairs(resp) do
--                                             if rs.name == itm.name and rs.name ~= "spawn-essence" and rs.name ~=
--                                                 "research-essence" then
--                                                 -- This technology unlocks our end product, set flag
--                                                 ismatch = true
--                                             end
--                                         end
--                                     end
--                                 end
--                             end
--                             -- Add recipe as unlock to tech and hide recipe on match
--                             if ismatch then
--                                 local pr = {
--                                     type = "unlock-recipe",
--                                     recipe = r.name
--                                 }
--                                 table.insert(t.effects, pr)
--                                 -- Disable our recipe because it is now unlocked via the tech tree
--                                 r.enabled = false
--                             end
--                         end
--                     end
--                 end
--             end
--         end
--     end
-- end

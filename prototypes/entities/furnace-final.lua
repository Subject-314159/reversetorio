-- Get a dummy furnace
local DUMMY_NAME = "reversetorio-dummy-furnace"
local dummy = table.deepcopy(data.raw["furnace"]["stone-furnace"])
if not dummy then
    for _, f in pairs(data.raw["furnace"]) do
        dummy = table.deepcopy(f)
        break
    end
end
dummy.name = DUMMY_NAME
dummy.flags = {"hidden"}
dummy.next_upgrade = nil

-- replace all furnaces with assemblers with the same properties as the old furnace, so you can pick recipes
for name, _ in pairs(data.raw["furnace"]) do
    local furnace = table.deepcopy(data.raw.furnace[name])
    furnace.type = "assembling-machine"
    furnace.source_inventory_size = nil
    if not furnace.energy_usage then
        furnace.energy_usage = "350kW"
    end
    data:extend({furnace})
    data.raw["furnace"][name] = nil
end

-- Add the dummy furnace
data:extend({dummy})

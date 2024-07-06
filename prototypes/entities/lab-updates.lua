-- Add research essence as input to all possible labs
for _, l in pairs(data.raw["lab"]) do
    table.insert(l.inputs, "research-essence")
end

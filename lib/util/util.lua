function SM_printall(table)
  if table == nil then
    print("nil value for SM_printall")
    return
  end

  if type(table) ~= "table" then
    print("not a table: "..table.." ("..type(table)..")")
    return
  end

  local tableContents = ""
  for k, v in pairs(table) do
    tableContents = tableContents.." "..k..": "..tostring(v)..","
  end

  print("{"..tableContents.." }")
end

function table.clone(tableToClone)
  return { unpack(tableToClone) }
end

function Set(list)
  local set = {}
  for _, l in ipairs(list) do set[l] = true end
  return set
end
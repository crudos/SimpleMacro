function SM_printall(table)
  if table == nil then
    print("nil value for SM_printall")
    return
  end

  local tableContents = ""
  for k, v in pairs(table) do
    tableContents = tableContents .. " " .. k .. ": " .. tostring(v) .. ","
  end

  print("{" .. tableContents .. " }")
end

function table.clone(org)
  return { unpack(org) }
end
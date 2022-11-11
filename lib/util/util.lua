local function printVal(value)
  if value == nil then
    return "nil"
  end
  -- doesn't handle nesting
  if type(value) == "table" then
    local tableContents = ""
    for k, v in pairs(value) do
      tableContents = tableContents.." "..k..": "..tostring(v)..","
    end
    return "{"..tableContents.."}"
  end
  return tostring(value)
end

function printall(...)
  local arg1, arg2, arg3, arg4 = ...
  local arg = { arg1, arg2, arg3, arg4 }
  local out = ""
  for k, v in ipairs(arg) do
    out = out..printVal(v).." "
  end
  print(out)
end

function table.clone(tableToClone)
  return { unpack(tableToClone) }
end

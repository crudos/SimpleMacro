function SM_printall(table)
   if table == nil then
      print("nil value for SM_printall")
      return
   end

   local tableContents = ""
   for k, v in pairs(table) do
      tableContents = tableContents.." "..k..": "..tostring(v)..","
   end

   print(tostring(table).." {"..tableContents.." }")
end
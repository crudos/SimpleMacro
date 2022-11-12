local _, ns = ...

-- Initialize localization object
if not ns.L then
  ns.L = {}
end

function GetGlobalString(stringID)
  return _G["SIMPLE_MACRO_STRING_"..stringID]
end
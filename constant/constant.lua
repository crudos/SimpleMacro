local _, L = ...

L["defaultsAccount"] = {
   settings = {
      ContextMenu = false,
   },
}
L["defaultsCharacter"] = {
   groupTable = {},
   tab = 1,
}

L["settings"] = {}

L["settings"]["contextMenus"] = { "TARGET", "PARTY", "PLAYER", "RAID_PLAYER" }

L["tabs"] = { "Create", "Group" }

L["Create"] = {}
L["Create"]["popupMenus"] = { "SimpleMacroChangeMenu", "SM_NewLineMenu", "SM_ArgMenu", "SM_CondMenu" }
L["Create"]["macrosPerRow"] = 6
L["Create"]["conditionalsPerCol"] = 18
L["Create"]["conditionalSpacing"] = 184
L["Create"]["numConditionals"] = 36
L["Create"]["maxMacroCategories"] = 12
L["Create"]["maxMacroCommands"] = 32
L["Create"]["editorHeight"] = 14
L["Create"]["numIconFrames"] = 54
L["Create"]["iconsPerRow"] = 6
L["Create"]["iconRowHeight"] = 46
L["Create"]["iconTable"] = {}
   GetMacroIcons(L["Create"]["iconTable"])
   GetMacroItemIcons(L["Create"]["iconTable"])
L["Create"]["rIconTable"] = {}
   for k, v in pairs(L["Create"]["iconTable"]) do
      L["Create"]["rIconTable"][v] = k
   end

L["Group"] = {}
L["Group"]["macrosPerRow"] = 6
L["Group"]["maxTabs"] = 4
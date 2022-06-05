local _, L = ...

L["DEFAULTS_ACCOUNT"] = {
  settings = {
    ContextMenu = false,
  },
}
L["DEFAULTS_CHARACTER"] = {
  groupTable = {},
  tab = 1,
}

L["SETTINGS"] = {}
L["SETTINGS"]["CHANGE_BUTTON_ADDED"] = "SimpleMacroChangeButtonAdded"

L["tabs"] = { "Create", "Group" }

L["MACRO_EDITOR"] = {}
L["MACRO_EDITOR"]["NUM_MACRO_CATEGORIES"] = 12
L["MACRO_EDITOR"]["NUM_MACRO_COMMANDS"] = 32
L["MACRO_EDITOR"]["MAX_CONDITIONAL_GROUPS"] = 5
L["MACRO_EDITOR"]["MAX_CONDITIONALS"] = 5
L["MACRO_EDITOR"]["HASH_CATEGORY"] = "Metacommands"

-- TODO REMOVE any unused "Create" entries already in "MACRO_EDITOR"
L["Create"] = {}
L["Create"]["popupMenus"] = { "SimpleMacroChangeMenu", "SM_NewLineMenu", "SM_ArgMenu", "SM_CondMenu" }
L["Create"]["macrosPerRow"] = 6
L["Create"]["conditionalsPerCol"] = 18
L["Create"]["conditionalSpacing"] = 184
L["Create"]["numConditionals"] = 36
L["Create"]["maxMacroCategories"] = 12
L["Create"]["maxMacroCommands"] = 32
L["Create"]["editorHeight"] = 14
L["Create"]["numIconFrames"] = 100
L["Create"]["iconsPerRow"] = 10
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
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

-- TODO REMOVE any unused "CREATE_TAB" entries already in "MACRO_EDITOR"
L["CREATE_TAB"] = {}
L["CREATE_TAB"]["popupMenus"] = { "SimpleMacroChangeMenu", "SM_NewLineMenu", "SM_ArgMenu", "SM_CondMenu" }
L["CREATE_TAB"]["macrosPerRow"] = 6
L["CREATE_TAB"]["conditionalsPerCol"] = 18
L["CREATE_TAB"]["conditionalSpacing"] = 184
L["CREATE_TAB"]["numConditionals"] = 36
L["CREATE_TAB"]["maxMacroCategories"] = 12
L["CREATE_TAB"]["maxMacroCommands"] = 32
L["CREATE_TAB"]["editorHeight"] = 14
L["CREATE_TAB"]["numIconFrames"] = 100
L["CREATE_TAB"]["iconsPerRow"] = 10
L["CREATE_TAB"]["iconRowHeight"] = 46
L["CREATE_TAB"]["iconTable"] = {}
GetMacroIcons(L["CREATE_TAB"]["iconTable"])
GetMacroItemIcons(L["CREATE_TAB"]["iconTable"])
L["CREATE_TAB"]["rIconTable"] = {}
for k, v in pairs(L["CREATE_TAB"]["iconTable"]) do
  L["CREATE_TAB"]["rIconTable"][v] = k
end

L["Group"] = {}
L["Group"]["macrosPerRow"] = 6
L["Group"]["maxTabs"] = 4
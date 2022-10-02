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

L["CREATE_TAB"] = {}
L["CREATE_TAB"]["POPUP_MENUS"] = { "SimpleMacroChangeMenu" }
L["CREATE_TAB"]["MACROS_PER_ROW"] = 6
L["CREATE_TAB"]["ICON_ROW_HEIGHT"] = 46
L["CREATE_TAB"]["ICONS_PER_ROW"] = 10
L["CREATE_TAB"]["NUM_ICON_FRAMES"] = 100
L["CREATE_TAB"]["ICON_TABLE"] = {}
GetMacroIcons(L["CREATE_TAB"]["ICON_TABLE"])
GetMacroItemIcons(L["CREATE_TAB"]["ICON_TABLE"])
L["CREATE_TAB"]["R_ICON_TABLE"] = {}
for k, v in pairs(L["CREATE_TAB"]["ICON_TABLE"]) do
  L["CREATE_TAB"]["R_ICON_TABLE"][v] = k
end
L["CREATE_TAB"]["EDITOR_HEIGHT"] = 14

L["Group"] = {}
L["Group"]["MACROS_PER_ROW"] = 6
L["Group"]["MAX_TABS"] = 4
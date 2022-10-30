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
L["CREATE_TAB"]["POPUP_MENUS"] = { "SMChangeFrame" }
L["CREATE_TAB"]["MACROS_PER_ROW"] = 6
L["CREATE_TAB"]["EDITOR_HEIGHT"] = 14

L["CHANGE_FRAME"] = {}
L["CHANGE_FRAME"]["ICON_ROW_HEIGHT"] = 46
L["CHANGE_FRAME"]["ICONS_PER_ROW"] = 10
L["CHANGE_FRAME"]["NUM_ICON_FRAMES"] = 100
L["CHANGE_FRAME"]["ICON_TABLE"] = {}
GetMacroIcons(L["CHANGE_FRAME"]["ICON_TABLE"])
GetMacroItemIcons(L["CHANGE_FRAME"]["ICON_TABLE"])
L["CHANGE_FRAME"]["R_ICON_TABLE"] = {}
for k, v in pairs(L["CHANGE_FRAME"]["ICON_TABLE"]) do
  L["CHANGE_FRAME"]["R_ICON_TABLE"][v] = k
end

L["Group"] = {}
L["Group"]["MACROS_PER_ROW"] = 6
L["Group"]["MAX_TABS"] = 4
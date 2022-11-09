local _, ns = ...
-- Initialize constants
if not ns.C then
  ns.C = {}
end

local C = ns.C

C["SETTINGS"] = {}
C["SETTINGS"]["ENUM"] = { "ContextMenu" }
C["SETTINGS"]["DEFAULT_ACCOUNT"] = {
  Settings = {}
}
C["SETTINGS"]["DEFAULT_CHARACTER"] = {
  GroupTable = {}
}
for _, setting in pairs(C["SETTINGS"]["ENUM"]) do
  C["SETTINGS"]["DEFAULT_ACCOUNT"].Settings[setting] = false
end

C["tabs"] = { "Create", "Group" }

C["MACRO_EDITOR"] = {}
C["MACRO_EDITOR"]["NUM_MACRO_CATEGORIES"] = 12
C["MACRO_EDITOR"]["NUM_MACRO_COMMANDS"] = 32
C["MACRO_EDITOR"]["MAX_CONDITIONAL_GROUPS"] = 5
C["MACRO_EDITOR"]["MAX_CONDITIONALS"] = 5
C["MACRO_EDITOR"]["HASH_CATEGORY"] = "Metacommands"

C["MACRO_FRAME"] = {}
C["MACRO_FRAME"]["MACROS_PER_ROW"] = 8

C["CREATE_TAB"] = {}
C["CREATE_TAB"]["POPUP_MENUS"] = { "SMChangeFrame" }
C["CREATE_TAB"]["MACROS_PER_ROW"] = 6
C["CREATE_TAB"]["EDITOR_HEIGHT"] = 14

C["CHANGE_FRAME"] = {}
C["CHANGE_FRAME"]["ICON_ROW_HEIGHT"] = 46
C["CHANGE_FRAME"]["ICONS_PER_ROW"] = 10
C["CHANGE_FRAME"]["NUM_ICON_FRAMES"] = 100
C["CHANGE_FRAME"]["ICON_TABLE"] = {}
GetMacroIcons(C["CHANGE_FRAME"]["ICON_TABLE"])
GetMacroItemIcons(C["CHANGE_FRAME"]["ICON_TABLE"])
C["CHANGE_FRAME"]["R_ICON_TABLE"] = {}
for k, v in pairs(C["CHANGE_FRAME"]["ICON_TABLE"]) do
  C["CHANGE_FRAME"]["R_ICON_TABLE"][v] = k
end

C["GROUP_FRAME"] = {}
C["GROUP_FRAME"]["MAX_TABS"] = 4
C["GROUP_FRAME"]["MACROS_PER_ROW"] = 8
C["GROUP_FRAME"]["MAX_MACROS_PER_GROUP"] = 16
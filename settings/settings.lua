local _, ns = ...
local L = ns.L["SETTINGS"]

-- Add to Blizzard Options addon menu
local category = Settings.RegisterVerticalLayoutCategory("SimpleMacro")
SimpleMacro.SettingsCategory = category

local function InitializeContextMenuButtons(owner, rootDescription, contextData)
  rootDescription:CreateDivider();
  rootDescription:CreateTitle("SimpleMacro");
  local groups = SimpleMacro.dbc.GroupTable:GetGroups()
  for i, _ in ipairs(groups) do
    rootDescription:CreateButton(string.format(L["CONTEXT_MENU"]["SET_GROUP_TARGET"], i),
                                 function()
                                   SimpleMacroGroupFrame:ChangeGroupTarget(i, contextData.name)
                                 end);
  end
end

local function ModifyMenus()
  Menu.ModifyMenu("MENU_UNIT_PARTY", InitializeContextMenuButtons);
  Menu.ModifyMenu("MENU_UNIT_PLAYER", InitializeContextMenuButtons);
  Menu.ModifyMenu("MENU_UNIT_RAID", InitializeContextMenuButtons);
  Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", InitializeContextMenuButtons);
end

local function OnSettingChanged(_, setting)
  local variable = setting:GetVariable()
  local value = setting:GetValue()
  if variable == "ContextMenu" then
    SimpleMacro.dba.Settings[variable] = value
    if value then
      ModifyMenus()
    else
      --dropdown:Disable()
    end
  end
end

SimpleMacro.settings = {}

do
  local variable = "ContextMenu"
  local setting = Settings.RegisterAddOnSetting(category, L["CONTEXT_MENU"]["NAME"], variable, Settings.VarType.Boolean, Settings.Default.False)
  Settings.SetOnValueChangedCallback(variable, OnSettingChanged)
  Settings.CreateCheckbox(category, setting, L["CONTEXT_MENU"]["TOOLTIP"])
  table.insert(SimpleMacro.settings, setting)
end

Settings.RegisterAddOnCategory(category)

SimpleMacroSettingsMixin = {}

function SimpleMacroSettingsMixin:OnLoad()
  -- do nothing
end

function SimpleMacroSettingsMixin:OnShow()
  -- do nothing
end

function SimpleMacroSettingsMixin:OnHide()
  -- do nothing
end

function SimpleMacroSettingsMixin:LoadSettings()
  for _, setting in pairs(SimpleMacro.settings) do
    local variable = setting:GetVariable()
    Settings.SetValue(variable, SimpleMacro.dba.Settings[variable])
  end
end
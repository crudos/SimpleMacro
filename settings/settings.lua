local addonName, ns = ...
local C = ns.C["SETTINGS"]
local L = ns.L["SETTINGS"]

SimpleMacro.Settings = {}

-- Add to Blizzard Options addon menu
local category, layout = Settings.RegisterVerticalLayoutCategory(L["TITLE"])
Settings.RegisterAddOnCategory(category)
SimpleMacro.SettingsCategory = category

-- Group Target settings
layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(L["GROUP_TARGET_LABEL"], L["GROUP_TARGET_TOOLTIP"]));

-- Context Menu
do
  local function InitializeContextMenuButtons(owner, rootDescription, contextData)
    rootDescription:CreateDivider();
    rootDescription:CreateTitle(L["TITLE"]);
    local groups = SimpleMacro.dbc.GROUP_TABLE:GetGroups()
    for i, _ in ipairs(groups) do
      rootDescription:CreateButton(string.format(L["CONTEXT_MENU_BUTTON_TEXT"], i), function()
        SimpleMacroGroupFrame:ChangeGroupTarget(i, contextData.name)
      end);
    end
  end

  local function UpdateContextMenus()
    Menu.ModifyMenu("MENU_UNIT_PARTY", InitializeContextMenuButtons);
    Menu.ModifyMenu("MENU_UNIT_PLAYER", InitializeContextMenuButtons);
    Menu.ModifyMenu("MENU_UNIT_RAID", InitializeContextMenuButtons);
    Menu.ModifyMenu("MENU_UNIT_RAID_PLAYER", InitializeContextMenuButtons);
  end

  local contextMenuVariable = "CONTEXT_MENU"
  local contextMenuSetting = Settings.RegisterAddOnSetting(category, contextMenuVariable, contextMenuVariable, SimpleMacro.dba.SETTINGS,
                                                           Settings.VarType.Boolean, L["CONTEXT_MENU_NAME"], Settings.Default.False)
  Settings.CreateCheckbox(category, contextMenuSetting, L["CONTEXT_MENU_TOOLTIP"])
  Settings.SetOnValueChangedCallback(contextMenuVariable, function(_, set)
    local value = set:GetValue()
    SimpleMacro.dba.SETTINGS[set:GetVariable()] = value
    if value then UpdateContextMenus() end
  end)
  table.insert(SimpleMacro.Settings, contextMenuSetting)
end

-- Auto Arena
do
  local autoArenaVariable = "AUTO_ARENA"
  local autoArenaSetting = Settings.RegisterAddOnSetting(category, autoArenaVariable, autoArenaVariable, SimpleMacro.dba.SETTINGS,
                                                         Settings.VarType.Boolean, L["AUTO_ARENA_NAME"], Settings.Default.False)
  local autoArenaInitializer = Settings.CreateCheckbox(category, autoArenaSetting, L["AUTO_ARENA_TOOLTIP"])
  Settings.SetOnValueChangedCallback(autoArenaVariable, function(_, set) print('set auto arena')
    SimpleMacro.dbc.SETTINGS[set:GetVariable()] = set:GetValue() end)
  table.insert(SimpleMacro.Settings, autoArenaSetting)

  local function isAutoArenaCheckedAndHasGroups(count)
    return function()
      return autoArenaSetting:GetValue() == true and SimpleMacro.dbc.GROUP_TABLE:GetCount() >= count
    end
  end

  -- Order dropdown
  do
    local orderVariable = "AUTO_ARENA_ORDER"

    local function GetValue()
      return SimpleMacro.dbc.SETTINGS[orderVariable]
    end

    local function SetValue(value)
      SimpleMacro.dbc.SETTINGS[orderVariable] = value
    end

    local function GetOptions()
      local container = Settings.CreateControlTextContainer();
      for _, option in ipairs(C["AUTO_ARENA_ORDER_OPTIONS"]) do
        container:Add(option, L["AUTO_ARENA_ORDER_" .. option], L["AUTO_ARENA_ORDER_" .. option .. "_TOOLTIP"])
      end
      return container:GetData();
    end

    local orderSetting = Settings.RegisterProxySetting(category, orderVariable, Settings.VarType.String,
                                                       L["AUTO_ARENA_ORDER_NAME"], C["AUTO_ARENA_ORDER_OPTIONS"][1], GetValue, SetValue);
    local orderInitializer = Settings.CreateDropdown(category, orderSetting, GetOptions, L["AUTO_ARENA_ORDER_TOOLTIP"]);
    orderInitializer:SetParentInitializer(autoArenaInitializer, isAutoArenaCheckedAndHasGroups(1));
    table.insert(SimpleMacro.Settings, orderSetting)
  end

  --Group dropdowns
  do
    local function GetValue(variable)
      return function() return SimpleMacro.dbc.SETTINGS[variable] end
    end

    local function SetValue(variable)
      return function(value) SimpleMacro.dbc.SETTINGS[variable] = value end
    end

    local group1Variable = "AUTO_ARENA_GROUP1"
    local group1Setting = Settings.RegisterProxySetting(category, group1Variable,
                                                        Settings.VarType.Number,
                                                        L["AUTO_ARENA_GROUP1_NAME"],
                                                        1,
                                                        GetValue(group1Variable),
                                                        SetValue(group1Variable))
    table.insert(SimpleMacro.Settings, group1Setting)

    local group2Variable = "AUTO_ARENA_GROUP2"
    local group2Setting = Settings.RegisterProxySetting(category, group2Variable,
                                                        Settings.VarType.Number,
                                                        L["AUTO_ARENA_GROUP2_NAME"],
                                                        2,
                                                        GetValue(group2Variable),
                                                        SetValue(group2Variable))
    table.insert(SimpleMacro.Settings, group2Setting)

    local function GetOptionsExcluding(ignoreGroupSetting)
      return function()
        local container = Settings.CreateControlTextContainer()
        for i = 1, SimpleMacro.dbc.GROUP_TABLE:GetCount() do
          if ignoreGroupSetting:GetValue() ~= i then
            container:Add(i, string.format(L["AUTO_ARENA_GROUP_OPTION"], i))
          end
        end
        container:Add(SimpleMacro.dbc.GROUP_TABLE:GetCount() + 1, L["AUTO_ARENA_NONE_OPTION"])
        return container:GetData()
      end
    end

    local group1Initializer = Settings.CreateDropdown(category, group1Setting, GetOptionsExcluding(group2Setting), L["AUTO_ARENA_GROUP1_TOOLTIP"]);
    group1Initializer:SetParentInitializer(autoArenaInitializer, isAutoArenaCheckedAndHasGroups(1));
    local group2Initializer = Settings.CreateDropdown(category, group2Setting, GetOptionsExcluding(group1Setting), L["AUTO_ARENA_GROUP2_TOOLTIP"]);
    group2Initializer:SetParentInitializer(autoArenaInitializer, isAutoArenaCheckedAndHasGroups(2));
  end
end

SimpleMacroSettingsMixin = {}

function SimpleMacroSettingsMixin:LoadSettings()
  for _, setting in pairs(SimpleMacro.Settings) do
    local variable = setting:GetVariable()
    if SimpleMacro.dba.SETTINGS[variable] ~= nil then
      Settings.SetValue(variable, SimpleMacro.dba.SETTINGS[variable])
    elseif SimpleMacro.dbc.SETTINGS[variable] ~= nil then
      Settings.SetValue(variable, SimpleMacro.dbc.SETTINGS[variable])
    end
  end
end

function SimpleMacroSettingsMixin:OnLoad()
  self:RegisterEvent("GROUP_ROSTER_UPDATE")
end

function SimpleMacroSettingsMixin:OnEvent(event)
  if C_PvP.IsRatedArena() and GetNumGroupMembers() == 3 and SimpleMacro.dbc.SETTINGS["AUTO_ARENA"] then
    local identifierList = {}

    for i=1,4 do
      local name = UnitName('party'..i)
      local role = UnitGroupRolesAssigned('party'..i)
      if role == 'TANK' then role = 'A'..role end
      if name == nil or role == nil then break end
      table.insert(identifierList, { name = name, nameRole = name .. "_" .. role, roleName = role .. "_" .. name })
    end

    local order = SimpleMacro.dbc.SETTINGS["AUTO_ARENA_ORDER"]
    -- no sort for POSITION
    if order == "NAME_ROLE" then
      table.sort(identifierList, function(a, b) return a.nameRole < b.nameRole end)
    elseif order == "ROLE_NAME" then
      table.sort(identifierList, function(a, b) return a.roleName < b.roleName end)
    end

    local groupCount = SimpleMacro.dbc.GROUP_TABLE:GetCount()
    local group1 = SimpleMacro.dbc.SETTINGS["AUTO_ARENA_GROUP1"]
    if identifierList[1] ~= nil and group1 <= groupCount then
      SimpleMacroGroupFrame:ChangeGroupTarget(group1, identifierList[1].name)
    end

    local group2 = SimpleMacro.dbc.SETTINGS["AUTO_ARENA_GROUP2"]
    if identifierList[2] ~= nil and group2 <= groupCount then
      SimpleMacroGroupFrame:ChangeGroupTarget(group2, identifierList[2].name)
    end
  end
end
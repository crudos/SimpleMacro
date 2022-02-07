local _, L = ...
local C = L["settings"]
local G = _G

local function isContextMenuButtonEnabled()
  return SimpleMacro.dba.settings.ContextMenu == true and #SimpleMacro.dbc.groupTable > 0
end

function SimpleMacroSettings_OnLoad(self)
  self.name = "Simple Macro";
  self.okay = function(this)
    SimpleMacroSettings_OnOkay(this)
  end
  self.cancel = function(_)
    SimpleMacroSettings_OnCancel()
  end
  self:Hide() -- stops OnShow from running immediately
  InterfaceOptions_AddCategory(self);

  SimpleMacroSettings_LoadText(self)
end

function SimpleMacroSettings_LoadText(self)
  for setting, _ in pairs(L["defaultsAccount"].settings) do
    G[self:GetName() .. setting .. "Text"]:SetText(L["SETTINGS"][setting])
    G[self:GetName() .. setting].tooltipText = L["SETTINGS"][setting .. "Tooltip"]
  end
end

function SimpleMacroSettings_OnShow(self)
  for setting, isChecked in pairs(SimpleMacro.dba.settings) do
    G[self:GetName() .. setting]:SetChecked(isChecked)
  end
end

function SimpleMacroSettings_OnOkay(self)
  SimpleMacroSettings_Save(self)
  SimpleMacroSettings_Load()
end

function SimpleMacroSettings_Save(self)
  for setting, _ in pairs(L["defaultsAccount"].settings) do
    if G[self:GetName() .. setting]:GetChecked() == true then
      SimpleMacro.dba.settings[setting] = true
    else
      SimpleMacro.dba.settings[setting] = false
    end
  end
end

function SimpleMacroSettings_OnCancel()
  -- Do nothing
end

function SimpleMacroSettings_Load()
  SimpleMacroSettings_Setup()
end

function SimpleMacroSettings_Setup()
  if isContextMenuButtonEnabled() then
    SimpleMacroSettings_SetupContextMenu()
  end
end

function SimpleMacroSettings_SetupContextMenu()
  if (UnitPopupMenus["SM_CHANGE_GROUP_TARGET"] == nil) then
    UnitPopupMenus["SM_CHANGE_GROUP_TARGET"] = {}
    UnitPopupButtons["SM_CHANGE_GROUP_TARGET"] = { text = L["CONTEXT"]["CHANGE_GROUP_TARGET"], nested = 1 }

    for i, _ in ipairs(SimpleMacro.dbc.groupTable) do
      UnitPopupButtons["SM_GROUP_" .. i] = { text = L["CONTEXT"]["GROUP"] .. " " .. i }
      tinsert(UnitPopupMenus["SM_CHANGE_GROUP_TARGET"], "SM_GROUP_" .. i)
    end

    for menu, _ in pairs(C["contextMenus"]) do
      tinsert(UnitPopupMenus[menu], #UnitPopupMenus[menu], "SM_CHANGE_GROUP_TARGET")
    end

    hooksecurefunc("UnitPopup_OnClick", SM_ContextMenuChangeGroup_OnClick)
    hooksecurefunc("UnitPopup_HideButtons", SM_ContextMenuChangeGroup_HideButtons)
  end
end

function SM_ContextMenuChangeGroup_OnClick(self)
  if string.match(self.value, "SM_GROUP_[0-9]*") then
    local newTarget = self:GetParent().parent.dropdown.name
    SM_ChangeGroupTarget(self:GetID(), newTarget)
    self:GetParent():Hide()
  end
end

function SM_ContextMenuChangeGroup_HideButtons()
  local dropdownMenu = UIDropDownMenu_GetCurrentDropDown()
  local dropdownLevel = 1

  if (C["contextMenus"][dropdownMenu.which] ~= nil) then
    for index, value in ipairs(UnitPopupMenus[dropdownMenu.which]) do
      if value == "SM_CHANGE_GROUP_TARGET" then
        UnitPopupShown[dropdownLevel][index] = isContextMenuButtonEnabled() and 1 or 0
      end
    end
  end
end
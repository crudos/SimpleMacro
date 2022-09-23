local _, L = ...
local C = L["SETTINGS"]
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
  for setting, _ in pairs(L["DEFAULTS_ACCOUNT"].settings) do
    G[self:GetName()..setting.."Text"]:SetText(C[setting])
    G[self:GetName()..setting].tooltipText = C[setting.."Tooltip"]
  end
end

function SimpleMacroSettings_OnShow(self)
  for setting, isChecked in pairs(SimpleMacro.dba.settings) do
    G[self:GetName()..setting]:SetChecked(isChecked)
  end
end

function SimpleMacroSettings_OnOkay(self)
  SimpleMacroSettings_Save(self)
  SimpleMacroSettings_Load()
end

function SimpleMacroSettings_Save(self)
  for setting, _ in pairs(L["DEFAULTS_ACCOUNT"].settings) do
    if G[self:GetName()..setting]:GetChecked() == true then
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

SimpleMacroChangeGroupTargetButton = CreateFromMixins(UnitPopupButtonBaseMixin)
function SimpleMacroChangeGroupTargetButton:GetText()
  return L["CONTEXT"]["CHANGE_GROUP_TARGET"]
end

function SimpleMacroChangeGroupTargetButton:CanShow()
  return isContextMenuButtonEnabled()
end

function SimpleMacroChangeGroupTargetButton:IsNested()
  return true
end

function SimpleMacroSettings_SetupContextMenu()
  local SimpleMacroGroupButtons = {}

  for i, _ in ipairs(SimpleMacro.dbc.groupTable) do
    local SimpleMacroGroupButton = CreateFromMixins(UnitPopupButtonBaseMixin)

    SimpleMacroGroupButton.GetText = function()
      return L["CONTEXT"]["GROUP"].." "..i
    end

    SimpleMacroGroupButton.GetID = function()
      return i
    end

    SimpleMacroGroupButton.OnClick = function(self)
      local dropdownMenu = UnitPopupSharedUtil.GetCurrentDropdownMenu();
      local newTarget = dropdownMenu.name
      SM_ChangeGroupTarget(self:GetID(), newTarget)
    end

    tinsert(SimpleMacroGroupButtons, SimpleMacroGroupButton)
  end

  SimpleMacroChangeGroupTargetButton.GetButtons = function()
    return SimpleMacroGroupButtons
  end
end

local isAdded = C["CHANGE_BUTTON_ADDED"]

local selfButtons = UnitPopupMenuSelf:GetMenuButtons()
function UnitPopupMenuSelf:GetMenuButtons()
  if selfButtons[isAdded] == nil then
    selfButtons[isAdded] = true
    tinsert(selfButtons, SimpleMacroChangeGroupTargetButton)
  end

  return selfButtons
end

local partyButtons = UnitPopupMenuParty:GetMenuButtons()
function UnitPopupMenuParty:GetMenuButtons()
  if partyButtons[isAdded] == nil then
    partyButtons[isAdded] = true
    tinsert(partyButtons, SimpleMacroChangeGroupTargetButton)
  end

  return partyButtons
end

local raidButtons = UnitPopupMenuRaidPlayer:GetMenuButtons()
function UnitPopupMenuRaidPlayer:GetMenuButtons()
  if raidButtons[isAdded] == nil then
    raidButtons[isAdded] = true
    tinsert(raidButtons, SimpleMacroChangeGroupTargetButton)
  end

  return raidButtons
end

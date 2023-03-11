local addonName, ns = ...
local C = ns.C["SETTINGS"]
local L = ns.L["SETTINGS"]
local G = _G

local dropdown = ns:GetModule("DropDown")

SimpleMacroSettingsMixin = {}

function SimpleMacroSettingsMixin:OnLoad()
  self.name = addonName
  InterfaceOptions_AddCategory(self)

  for setting, _ in pairs(C["DEFAULT_ACCOUNT"].Settings) do
    G[self:GetName()..setting.."Text"]:SetText(L[setting])
    G[self:GetName()..setting].tooltipText = L[setting.."Tooltip"]
  end
end

function SimpleMacroSettingsMixin:OnShow()
  -- do nothing
end

function SimpleMacroSettingsMixin:OnHide()
  self:SaveSettings()
  self:LoadSettings()
end

function SimpleMacroSettingsMixin:SaveSettings()
  for setting, _ in pairs(C["DEFAULT_ACCOUNT"].Settings) do
    if G[self:GetName()..setting]:GetChecked() == true then
      SimpleMacro.dba.Settings[setting] = true
    else
      SimpleMacro.dba.Settings[setting] = false
    end
  end
end

function SimpleMacroSettingsMixin:LoadSettings()
  for setting, isChecked in pairs(SimpleMacro.dba.Settings) do
    G[self:GetName()..setting]:SetChecked(isChecked)
    if isChecked then self:Enable(setting) else self:Disable(setting) end
  end
end

function SimpleMacroSettingsMixin:Enable(setting)
  local groupCount = SimpleMacro.dbc.GroupTable:GetCount()
  if setting == "ContextMenu" then
    if groupCount > 0 then
      dropdown:Enable()
    else
      dropdown:Disable()
    end
  end
end

function SimpleMacroSettingsMixin:Disable(setting)
  if setting == "ContextMenu" then
    dropdown:Disable()
  end
end
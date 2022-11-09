local addonName, L = ...
local C = L["SETTINGS"]
local G = _G

local dropdown = L:GetModule("DropDown")

SimpleMacroSettingsMixin = {}

function SimpleMacroSettingsMixin:OnLoad()
  self.name = addonName
  InterfaceOptions_AddCategory(self);
end

function SimpleMacroSettingsMixin:LoadSettings()
  for setting, isChecked in pairs(SimpleMacro.dba.Settings) do
    G[self:GetName()..setting]:SetChecked(isChecked)
    if isChecked then self:Enable(setting) else self:Disable(setting) end
  end
end

function SimpleMacroSettingsMixin:OnShow()
  for setting, _ in pairs(L["DEFAULTS_ACCOUNT"].Settings) do
    G[self:GetName()..setting.."Text"]:SetText(C[setting])
    G[self:GetName()..setting].tooltipText = C[setting.."Tooltip"]
  end
end

function SimpleMacroSettingsMixin:OnHide()
  self:SaveSettings()
end

function SimpleMacroSettingsMixin:SaveSettings()
  for setting, _ in pairs(L["DEFAULTS_ACCOUNT"].Settings) do
    if G[self:GetName()..setting]:GetChecked() == true then
      self:Enable(setting)
    else
      self:Disable(setting)
    end
  end
end

function SimpleMacroSettingsMixin:Enable(setting)
  if setting == "ContextMenu" then
    SimpleMacro.dba.Settings[setting] = true
    if #SimpleMacro.dbc.GroupTable > 0 then
      dropdown:Enable()
    else
      dropdown:Disable()
    end
  end
end

function SimpleMacroSettingsMixin:Disable(setting)
  if setting == "ContextMenu" then
    SimpleMacro.dba.Settings[setting] = false
    dropdown:Disable()
  end
end
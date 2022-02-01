local _, L = ...
local C = L["settings"]
local G = _G

function SimpleMacroSettings_OnLoad(self)
   self.name = "Simple Macro";
   self.okay = function(this) SimpleMacroSettings_OnOkay(this) end
   self.cancel = function(_) SimpleMacroSettings_OnCancel() end
   self:Hide() -- stops OnShow from running immediately
   InterfaceOptions_AddCategory(self);

   SimpleMacroSettings_LoadText(self)
end

function SimpleMacroSettings_LoadText(self)
   for setting, _ in pairs(L["defaultsAccount"].settings) do
      G[self:GetName()..setting.."Text"]:SetText(L["SETTINGS"][setting])
      G[self:GetName()..setting].tooltipText = L["SETTINGS"][setting.."Tooltip"]
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
   for setting, _ in pairs(L["defaultsAccount"].settings) do
      if G[self:GetName()..setting]:GetChecked() == true then
         SimpleMacro.dba.settings[setting] = true
      else
         SimpleMacro.dba.settings[setting] = false
      end
   end
end

function SimpleMacroSettings_OnCancel()
end

function SimpleMacroSettings_Load()
   SimpleMacroSettings_Teardown()
   SimpleMacroSettings_Setup()
end

function SimpleMacroSettings_Teardown()
   SimpleMacroSettings_RemoveContext()
end

function SimpleMacroSettings_RemoveContext()
   local existingIndex

   for _, menu in ipairs(C["contextMenus"]) do
      if UnitPopupMenus["SM_CHANGE_GROUP_TARGET"] ~= nil then
         for i, v in ipairs(UnitPopupMenus[menu]) do
            if v == "SM_CHANGE_GROUP_TARGET" then
               existingIndex = i
               break
            end
         end
      end

      if existingIndex ~= nil then
         tremove(UnitPopupMenus[menu], existingIndex)
      end
   end
end

function SimpleMacroSettings_Setup()
   if SimpleMacro.dba.settings.ContextMenu == true and #SimpleMacro.dbc.groupTable > 0 then
      SimpleMacroSettings_SetupContextMenu()
   end
end

function SimpleMacroSettings_SetupContextMenu()
   UnitPopupMenus["SM_CHANGE_GROUP_TARGET"] = {}

   for i, _ in ipairs(SimpleMacro.dbc.groupTable) do
      UnitPopupButtons["SM_GROUP_"..i] = { text = L["CONTEXT"]["GROUP"].." "..i }
      tinsert(UnitPopupMenus["SM_CHANGE_GROUP_TARGET"], "SM_GROUP_"..i)
   end

   UnitPopupButtons["SM_CHANGE_GROUP_TARGET"] = { text = L["CONTEXT"]["CHANGE_GROUP_TARGET"], nested = 1 }

   for _, menu in ipairs(C["contextMenus"]) do
      tinsert(UnitPopupMenus[menu], #UnitPopupMenus[menu], "SM_CHANGE_GROUP_TARGET")
   end

   hooksecurefunc("UnitPopup_OnClick", SM_ContextMenuChangeGroup_OnClick)
end

function SM_ContextMenuChangeGroup_OnClick(self)
   if not string.match(self.value, "SM_GROUP_[0-9]*") then return end

   local newTarget = self:GetParent().parent.dropdown.name
   SM_ChangeGroupTarget(self:GetID(), newTarget)
   self:GetParent():Hide()
end
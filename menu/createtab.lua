-- Author      : Crudos
-- Create Date : 4/25/2015 01:06:26 PM
CREATETAB_MACROS_PER_ROW = 6

local _, L = ...
local G = _G

-- UNUSED FILE AT THE MOMENT

-- CREATE TAB
function SimpleMacroMenuCreateTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())
   SimpleMacroMenuCreateTab:Show()
   SimpleMacroMenuGroupTab:Hide()

   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
   SM_SetAccountMacros()
   CreateTab_Update()
end

function SM_CreateTabAccountMacroTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
   SM_SetAccountMacros()
   CreateTab_Update()
end

function SM_CreateTabCharacterMacroTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 2)
   SM_SetCharacterMacros()
   CreateTab_Update()
end

function SM_SetAccountMacros()
   SimpleMacroMenu.macroStart = 0
   SimpleMacroMenu.macroMax = MAX_ACCOUNT_MACROS

   local numAccountMacros, numCharacterMacros = GetNumMacros()

   if numAccountMacros > 0 then
      CreateTab_SelectMacro(1)
   else
      CreateTab_SelectMacro(nil)
   end
end

function SM_SetCharacterMacros()
   SimpleMacroMenu.macroStart = MAX_ACCOUNT_MACROS
   SimpleMacroMenu.macroMax = MAX_CHARACTER_MACROS

   local numAccountMacros, numCharacterMacros = GetNumMacros()

   if numCharacterMacros > 0 then
      CreateTab_SelectMacro(1)
   else
      CreateTab_SelectMacro(nil)
   end
end

function SMCreateButtons_OnLoad(self)
   local button
   for i = 1, MAX_ACCOUNT_MACROS do
      button = CreateFrame("CheckButton", "SMCreateButton"..i, self, "SimpleMacroButtonTemplate")
      button:SetID(i)
      if i == 1 then
         button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
      elseif mod(i, CREATETAB_MACROS_PER_ROW) == 1 then
         button:SetPoint("TOP", "SMCreateButton"..(i-CREATETAB_MACROS_PER_ROW), "BOTTOM", 0, -10);
      else
         button:SetPoint("LEFT", "SMCreateButton"..(i-1), "RIGHT", 13, 0);
      end
   end
end

local function SM_PopulateLineList()
   local lc, parsed, line_entry

   parsed = SimpleMacroMenu.createParse

   for lc = 1, parsed.lines.count, 1 do
      if G["LineEntry"..lc] == nil then
         line_entry = CreateFrame("CheckButton", "LineEntry"..lc, LineList, "LineEntryTemplate")

         if lc == 1 then
            line_entry:SetPoint("TOPLEFT", LineList, "BOTTOMLEFT", 0, 0)
         else
            line_entry:SetPoint("TOPLEFT", "LineEntry"..(lc - 1), "BOTTOMLEFT", 0, -6)
         end
      else
         line_entry = G["LineEntry"..lc]
         line_entry:Show()
      end
      
      G["LineEntry"..lc.."Number"]:SetText(lc)
      G["LineEntry"..lc.."Command"]:SetText(parsed:getLine(lc))
      line_entry:SetID(lc)

      if lc == 1 then
         LineListEntry_OnClick(line_entry, _, _)
      end
   end

   lc = parsed.lines.count + 1

   while G["LineEntry"..lc] do
      G["LineEntry"..lc]:Hide()
      lc = lc + 1
   end
end

function CreateTab_Update()
   local numAccountMacros, numCharacterMacros = GetNumMacros()
   local numMacros, maxMacros
   local macroButtonName, macroButton, macroIcon, macroName
   local name, texture, body

   if SimpleMacroMenu.macroStart == 0 then
      numMacros = numAccountMacros
   else
      numMacros = numCharacterMacros
   end

   for i = 1, MAX_ACCOUNT_MACROS do
      macroButtonName = "SMCreateButton"..i
      macroButton = G[macroButtonName]
      macroIcon = G[macroButtonName.."Icon"]
      macroName = G[macroButtonName.."Name"]

      if i <= SimpleMacroMenu.macroMax then
         if i <= numMacros then
            name, texture, body = GetMacroInfo(i + SimpleMacroMenu.macroStart)
            macroIcon:SetTexture(texture)
            macroName:SetText(name)
            macroButton:Enable()

            if SimpleMacroMenu.createSelect and SimpleMacroMenu.createSelect == i then
               macroButton:SetChecked(true)
               SimpleMacroMenuCreateTabTextScrollFrameMacroText:SetText(body)

               G["SimpleMacroMenuCreateTabSelected"]:SetID(i)
               G["SimpleMacroMenuCreateTabSelectedText"]:SetText(name)
               G["SimpleMacroMenuCreateTabSelectedIcon"]:SetTexture(texture)
            else
               macroButton:SetChecked(false)
            end
         else
            macroIcon:SetTexture("");
            macroName:SetText("");
            macroButton:Disable();
            macroButton:SetChecked(false)
         end

         macroButton:Show()
      else 
         macroButton:Hide()
      end
   end

   -- make any button/text field updates

   if SimpleMacroMenu.createSelect ~= nil then
      SimpleMacroMenuCreateTab_ShowDetails()
      SM_PopulateLineList()
   else
      SimpleMacroMenuCreateTab_HideDetails()
   end

end

local selected

function LineListEntry_OnClick(self, button, down)
   if selected then
      print("Previous Selection: "..selected)
      G["LineEntry"..selected].highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
      G["LineEntry"..selected]:UnlockHighlight()
   end

   selected = self:GetID()
   self.highlight:SetVertexColor(1, 1, 0) -- selected, yellow
   self:LockHighlight()

   print("Current Selection: "..selected)
end

function CreateTab_SelectMacro(id)
   SimpleMacroMenu.createSelect = id

   if id then 
      SimpleMacroMenu.createParse = SMacro:new()
      SimpleMacroMenu.createParse:set(id + SimpleMacroMenu.macroStart)
   end
end

function SimpleMacroMenuCreateTab_ShowDetails()
   SMCharLimitText:Show()
   SimpleMacroMenuCreateTabTextScrollFrameMacroText:Show()
end

function SimpleMacroMenuCreateTab_HideDetails()
   SMCharLimitText:Hide()
   SimpleMacroMenuCreateTabTextScrollFrameMacroText:Hide()
end

function SimpleMacroMenuCreateTabLineTypeDropDown_OnEvent(self, event, ...)
   if event == "PLAYER_ENTERING_WORLD" then
      self.defaultValue = "none"
      self.value = self.defaultValue
      self.tooltip = L.LINE_TYPE_TOOLTIP_NONE

      UIDropDownMenu_SetWidth(self, 120)
      UIDropDownMenu_Initialize(self, SimpleMacroMenuCreateTabLineTypeDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(self, self.value)
      
      self.SetValue = 
         function (self, value)
            self.value = value
            UIDropDownMenu_SetSelectedValue(self, value)
            -- do something
            if value == "none" then
               self.tooltip = L.LINE_TYPE_TOOLTIP_NONE
            else
               self.tooltip = L.LINE_TYPE_TOOLTIP..value.."\""
            end
         end
      self.GetValue =
         function (self)
            return UIDropDownMenu_GetSelectedValue(self)
         end
      self.RefreshValue =
         function (self)
            UIDropDownMenu_Initialize(self, SimpleMacroMenuCreateTabLineTypeDropDown_Initialize)
            UIDropDownMenu_SetSelectedValue(self, self.value)
         end

      SimpleMacroMenuCreateTabLineTypeDropDownLabel:SetText(L.LINE_TYPE_DROPDOWN_LABEL)
      self:UnregisterEvent(event)
   end
end

function SimpleMacroMenuCreateTabLineTypeDropDown_OnClick(self)
   SimpleMacroMenuCreateTabLineTypeDropDown:SetValue(self.value)
   L.LINE.COMMAND = self.value
end

function SimpleMacroMenuCreateTabLineTypeDropDown_Initialize()
   local selectedValue = UIDropDownMenu_GetSelectedValue(SimpleMacroMenuCreateTabLineTypeDropDown)
   local info = UIDropDownMenu_CreateInfo()

   for _, cmd in pairs(L.LINE_TYPE_TABLE) do
      info.text = cmd
      info.func = SimpleMacroMenuCreateTabLineTypeDropDown_OnClick
      info.value = cmd
      if info.value == selectedValue then
         info.checked = 1
      else
         info.checked = nil
      end
      info.tooltipTitle = cmd
      info.tooltipText = "The command "..cmd
      UIDropDownMenu_AddButton(info)
   end
end

function SimpleMacroMenuSaveButton_OnClick(self)
   SMSaveMacro()
end

local function makeconditionals(list)
   local condlist = ""
   local i = 0

   for conditional, _ in pairs(list) do
      i = i + 1
      if condlist == "" then
         condlist = condlist..conditional
      else
         condlist = condlist..", "..conditional
      end
   end

   if condlist == "" then
      return
   elseif i > 1 then
      return condlist
   end

   condlist = string.gsub(reverse(condlist), " ,", "", 1)
   return reverse(condlist)
end

function SimpleMacroMenuSetButton_OnClick(self)
   local spell = CreateTabSpellText:GetText()

   if GetSpellInfo(spell) ~= nil then
      local line = "/"..L.LINE.COMMAND
      line = line.." ["..makeconditionals(L.LINE.CONDITIONAL_LIST).."]"
      line = line.." "..spell
      SimpleMacroMenuCreateTabTextScrollFrameMacroText:SetText(line)
   else
      print("This spell doesn't exist.")
   end
end

function SMSaveMacro()
   if SimpleMacroMenuCreateTab.textChanged and SimpleMacroMenu.createSelect then
      EditMacro(SimpleMacroMenu.createSelect, nil, nil, SimpleMacroMenuCreateTabTextScrollFrameMacroText:GetText())
      SimpleMacroMenuCreateTab.textChanged = nil;
   end
end

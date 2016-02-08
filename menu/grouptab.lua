-- Author      : Crudos
-- Create Date : 4/25/2015 12:55:17 PM
GROUPTAB_MACROS_PER_ROW = 6
SM_MAX_GROUP_TABS = 4

local _, L = ...
local G = _G

local function isempty(s)
   return s == nil or s == ''
end

local function setAccountMacros()
   SimpleMacroMenu.macroStart = 0
   SimpleMacroMenu.macroMax = MAX_ACCOUNT_MACROS

   local numAccountMacros, numCharacterMacros = GetNumMacros()

   if numAccountMacros > 0 then
      SM_UserButton_SelectMacro(1)
   else
      SM_UserButton_SelectMacro(nil)
   end
end

local function setCharacterMacros()
   SimpleMacroMenu.macroStart = MAX_ACCOUNT_MACROS
   SimpleMacroMenu.macroMax = MAX_CHARACTER_MACROS

   local numAccountMacros, numCharacterMacros = GetNumMacros()

   if numCharacterMacros > 0 then
      SM_UserButton_SelectMacro(1)
   else
      SM_UserButton_SelectMacro(nil)
   end
end

local function setGroupMacros()
   local groupTable = SimpleMacroMenu.groupTable
   local group = groupTable[groupTable.selected]

   if group and #group > 0 then
      -- possibly save the last selected macro in the group in SimpleMacroMenu.groupTable[#].selected
      SM_GroupButton_SelectMacro(1)
   else
      SM_GroupButton_SelectMacro(nil)
   end
end

-- GROUP TAB

local function loadGroupTabs()
   local parentFrame = SimpleMacroMenuGroupTabGroupScrollFrame
   local inheritFrame = "OptionsFrameTabButtonTemplate"

   for i = 1, SM_MAX_GROUP_TABS do
      CreateFrame("CheckButton", "$parentTab"..i, parentFrame, inheritFrame, i)
   end
end

function SM_GroupTab_OnLoad(panel)
   PanelTemplates_SetNumTabs(panel, 2)
   PanelTemplates_SetTab(panel, 1)

   loadGroupTabs()
end

function SM_GroupTab_OnShow(panel)
   if PanelTemplates_GetSelectedTab(SimpleMacroMenuGroupTab) == 1 then
      setAccountMacros()
   else 
      setCharacterMacros()
   end

   setGroupMacros()
   SM_SetGroupTabs()

   SM_UserButton_Update()
   SM_GroupButton_Update()

   SM_GroupTargetText:ClearFocus()

   if SimpleMacroMenu.groupTable == nil then
      --print("group table wasn't created yet (BAD)")
   end
   if SimpleMacroMenu.groupTable[SimpleMacroMenu.groupTable.selected] == nil then
      --print("no groups have been made")
   end
end

function SM_SetGroupTabs()
   local parentFrame = SimpleMacroMenuGroupTabGroupScrollFrame
   local groupTabName = "SimpleMacroMenuGroupTabGroupScrollFrameTab"
   local groupTable = SimpleMacroMenu.groupTable
   local tab

   -- #groupTable + 1 allows for the "+" button to be added at the end
   for i = 1, #groupTable + 1 do
      tab = G[groupTabName..i]

      if nil ~= tab then
         if i == #groupTable + 1 then
            tab:SetText("+")
            tab:SetScript("OnClick", SM_GroupTab_AddGroup_OnClick)
         else
            tab:SetText("Group "..i)
            tab:SetScript("OnClick", SM_GroupTab_Group_OnClick)
         end

         if i == 1 then
            tab:SetPoint("BOTTOMLEFT", parentFrame, "TOPLEFT", 2, 2)
         else
            tab:SetPoint("LEFT", G[groupTabName..(i-1)], "RIGHT", -16, 0)
         end

         tab:Hide()
         tab:Show()
      end
   end

   PanelTemplates_SetNumTabs(parentFrame, SM_MAX_GROUP_TABS)

   if groupTable.selected then
      PanelTemplates_SetTab(parentFrame, groupTable.selected)
   elseif #groupTable > 0 then
      PanelTemplates_SetTab(parentFrame, 1)
   end
end

function SM_GroupTab_AddGroup_OnClick(self)
   local groupTable = SimpleMacroMenu.groupTable

   -- make new group
   if self:GetID() <= SM_MAX_GROUP_TABS then
      groupTable[self:GetID()] = {}
      groupTable.selected = self:GetID()

      SM_GroupButton_SelectMacro(nil)
      SM_SetGroupTabs()
   end

   PlaySound("UChatScrollButton")
end

function SM_GroupTab_Group_OnClick(self)
   local groupTable = SimpleMacroMenu.groupTable

   PanelTemplates_SetTab(SimpleMacroMenuGroupTabGroupScrollFrame, self:GetID())
   groupTable.selected = self:GetID()

   if #groupTable[groupTable.selected] > 0 then
      SM_GroupButton_SelectMacro(1)
   else
      SM_GroupButton_SelectMacro(nil)
   end

   SM_GroupButton_Update()

   PlaySound("igCharacterInfoTab")
end

function SimpleMacroMenuGroupTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())
   SimpleMacroMenuCreateTab:Hide()
   SimpleMacroMenuGroupTab:Show()
end

-- create buttons containers
function SM_UserButtons_OnLoad(self)
   local button
   for i = 1, MAX_ACCOUNT_MACROS do
      button = CreateFrame("CheckButton", "SMUserButton"..i, self, "SimpleMacroButtonTemplate")
      button:SetID(i)
      if i == 1 then
         button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
      elseif mod(i, GROUPTAB_MACROS_PER_ROW) == 1 then
         button:SetPoint("TOP", "SMUserButton"..(i-GROUPTAB_MACROS_PER_ROW), "BOTTOM", 0, -10);
      else
         button:SetPoint("LEFT", "SMUserButton"..(i-1), "RIGHT", 13, 0);
      end
   end
end

function SM_GroupTabAccountMacroTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenuGroupTab, self:GetID())
   setAccountMacros()
   SM_UserButton_Update()
end


function SM_GroupTabCharacterMacroTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenuGroupTab, self:GetID())
   setCharacterMacros()
   SM_UserButton_Update()
end

function SM_GroupButtons_OnLoad(self)
   local macrosPerRow = GROUPTAB_MACROS_PER_ROW
   local button
   for i = 1, MAX_ACCOUNT_MACROS do
      button = CreateFrame("CheckButton", "SMGroupButton"..i, self, "SimpleMacroButtonTemplate")
      button:SetID(i)
      if i == 1 then
         button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
      elseif mod(i, macrosPerRow) == 1 then
         button:SetPoint("TOP", "SMGroupButton"..(i-macrosPerRow), "BOTTOM", 0, -10)
      else
         button:SetPoint("LEFT", "SMGroupButton"..(i-1), "RIGHT", 13, 0)
      end
   end
end

function SM_UserButton_Update()
   local numAccountMacros, numCharacterMacros = GetNumMacros()
   local macroButtonName, macroButton, macroIcon, macroName
   local name, texture, body

   if SimpleMacroMenu.macroStart == 0 then
      numMacros = numAccountMacros
   else
      numMacros = numCharacterMacros
   end

   for i = 1, MAX_ACCOUNT_MACROS do
      macroButtonName = "SMUserButton"..i
      macroButton = G[macroButtonName]
      macroIcon = G[macroButtonName.."Icon"]
      macroName = G[macroButtonName.."Name"]

      if i <= SimpleMacroMenu.macroMax then
         if i <= numMacros then
            name, texture, body = GetMacroInfo(i + SimpleMacroMenu.macroStart)
            macroIcon:SetTexture(texture)
            macroName:SetText(name)
            macroButton:Enable()

            if SimpleMacroMenu.userSelect and SimpleMacroMenu.userSelect == i then
               macroButton:SetChecked(true)
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
end

function SM_GroupButton_Update()
   local numAccountMacros, numCharacterMacros = GetNumMacros()
   local macroButtonName, macroButton, macroIcon, macroName
   local name, texture, body
   local groupTable = SimpleMacroMenu.groupTable
   local group = groupTable[groupTable.selected]

   for i = 1, MAX_ACCOUNT_MACROS do
      macroButtonName = "SMGroupButton"..i
      macroButton = G[macroButtonName]
      macroIcon = G[macroButtonName.."Icon"]
      macroName = G[macroButtonName.."Name"]

      if group and i <= #group then
         name, texture, body = GetMacroInfo(group[i]) --TODO what if group[i] doesn't exist anymore or is the wrong macro
         macroIcon:SetTexture(texture)
         macroName:SetText(name)
         macroButton:Enable()

         if SimpleMacroMenu.groupSelect and SimpleMacroMenu.groupSelect == i then
            macroButton:SetChecked(true)
         else
            macroButton:SetChecked(false)
         end
      else
         macroIcon:SetTexture("");
         macroName:SetText("");
         macroButton:Disable();
         macroButton:SetChecked(false)
      end
   end
      
   if group and #group > 0 then
      SM_GroupDeleteButton:Enable()
      SM_GroupTargetButton:Enable()
      SM_GroupTargetText:Enable()
   else
      SM_GroupDeleteButton:Disable()
      SM_GroupTargetButton:Disable()
      SM_GroupTargetText:Disable()
   end
end

function SM_UserButton_SelectMacro(id)
   SimpleMacroMenu.userSelect = id
end

function SM_GroupButton_SelectMacro(id)
   SimpleMacroMenu.groupSelect = id
end

function SM_GroupAddButton_OnClick(self)
   local buttonId = SimpleMacroMenu.userSelect + SimpleMacroMenu.macroStart
   local groupTable = SimpleMacroMenu.groupTable
   local group = groupTable[groupTable.selected]
   local isFound = false

   for i = 1, #group do
      if group[i] == buttonId then
         isFound = true
      end
   end

   if isFound == false then
      group[#group + 1] = buttonId
      SM_GroupButton_SelectMacro(#group)
   end

   SM_GroupButton_Update()
end

function SM_GroupDeleteButton_OnClick(self)
   local id = SimpleMacroMenu.groupSelect
   local groupTable = SimpleMacroMenu.groupTable
   local group = groupTable[groupTable.selected]
   local temp

   -- if we're deleting the last one, select the previous macro
   if id == #group then
      SM_GroupButton_SelectMacro(#group - 1)
   end

   -- shift all the macros down one from the deleted
   for i = 1, #group do
      if i >= id then
         group[i] = group[i + 1]
      end
   end

   SM_GroupButton_Update()
end

local function changeTargets(index, target)
   local numAccountMacros, numCharacterMacros = GetNumMacros() -- API for users current # of macros
   local idx = tonumber(index)

   if isempty(index) then
      print("That is not a macro number.")
   else
      local macroText = GetMacroBody(idx)

      if string.len(target) ~= 0 then
         local atStart, atEnd, tarStart, tarEnd, oldTar

         atStart, atEnd = string.find(macroText, "@")
         if not isempty(atStart) then
            oldTar = string.match(string.sub(macroText, atEnd + 1), '([^ ,%]]*).-$')
            macroText = string.sub(macroText, 1, atEnd)..target..string.sub(macroText, atEnd + string.len(oldTar) + 1)
         end

         tarStart, tarEnd = string.find(macroText, "target=")
         if not isempty(tarStart) then
            oldTar = string.match(string.sub(macroText, tarEnd + 1), '([^ ,%]]*).-$')
            macroText = string.sub(macroText, 1, tarEnd)..target..string.sub(macroText, tarEnd + string.len(oldTar) + 1)
         end

         EditMacro(idx, nil, nil, macroText)

         print("The macro at index "..idx.." was changed.")
      else
         print("You need to enter in a target!")
      end
   end
end

function SM_GroupTargetButton_OnClick(self)
   local id = SimpleMacroMenu.groupSelect
   local groupTable = SimpleMacroMenu.groupTable
   local group = groupTable[groupTable.selected]
   local target = SM_GroupTargetText:GetText()

   if not isempty(target) then
      for i = 1, #group do
         changeTargets(group[i], target)
      end
   end
end
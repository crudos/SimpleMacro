-- Author      : Crudos
-- Create Date : 4/25/2015 12:55:17 PM
GROUPTAB_MACROS_PER_ROW = 5

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

-- GROUP TAB
function SM_GroupTab_OnLoad(panel)
   PanelTemplates_SetNumTabs(SimpleMacroMenuGroupTab, 2)
   PanelTemplates_SetTab(SimpleMacroMenuGroupTab, 1)
end

function SimpleMacroMenuGroupTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())
   SimpleMacroMenuCreateTab:Hide()
   SimpleMacroMenuGroupTab:Show()

   setAccountMacros()
   SM_UserButton_Update()
   SM_GroupButton_Update()
   SimpleMacroMenuGroupTabTargetText:ClearFocus()
end

-- create buttons containers
function SM_UserButtons_OnLoad(self)
   local macrosPerRow = GROUPTAB_MACROS_PER_ROW
   local button
   for i = 1, MAX_ACCOUNT_MACROS do
      button = CreateFrame("CheckButton", "SMUserButton"..i, self, "SimpleMacroButtonTemplate")
      button:SetID(i)
      if i == 1 then
         button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
      elseif mod(i, macrosPerRow) == 1 then
         button:SetPoint("TOP", "SMUserButton"..(i-macrosPerRow), "BOTTOM", 0, -10);
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

   if SimpleMacroMenu.groupButtons == nil then
      SimpleMacroMenu.groupButtons = {}
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
   local list = SimpleMacroMenu.groupButtons

   for i = 1, MAX_ACCOUNT_MACROS do
      macroButtonName = "SMGroupButton"..i
      macroButton = G[macroButtonName]
      macroIcon = G[macroButtonName.."Icon"]
      macroName = G[macroButtonName.."Name"]

      if i <= #list then
         name, texture, body = GetMacroInfo(list[i])
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
end

function SM_UserButton_SelectMacro(id)
   SimpleMacroMenu.userSelect = id
end

function SM_GroupButton_SelectMacro(id)
   SimpleMacroMenu.groupSelect = id
end

function SM_GroupAddButton_OnClick(self)
   local leftButton = SimpleMacroMenu.userSelect + SimpleMacroMenu.macroStart
   local list = SimpleMacroMenu.groupButtons
   local isFound = false

   for i = 1, #list do
      if list[i] == leftButton then
         isFound = true
      end
   end

   if isFound == false then
      list[#list + 1] = leftButton
   end

   SM_GroupButton_Update()
end

function SM_GroupDeleteButton_OnClick(self)
   local id = SimpleMacroMenu.groupSelect
   local list = SimpleMacroMenu.groupButtons
   local temp

   if id == #list then
      SM_GroupButton_SelectMacro(#list - 1)
   else
      SM_GroupButton_SelectMacro(id)
   end

   if id == #list then
      list[id] = nil
   else
      for i = 1, #list do
         if i == #list then
            list[i] = nil
         elseif i >= id then
            list[i] = list[i + 1]
         end
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
         print("/sm edit <macro #> <new target>")
      end
   end
end

function SM_GroupTargetButton_OnClick(self)
   local id = SimpleMacroMenu.groupSelect
   local list = SimpleMacroMenu.groupButtons
   local target = SimpleMacroMenuGroupTabTargetText:GetText()

   if not isempty(target) then
      for i = 1, #list do
         changeTargets(list[i], target)
      end
   end
end
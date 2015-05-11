-- Author      : Crudos
-- Create Date : 4/25/2015 12:55:17 PM
GROUPTAB_MACROS_PER_ROW = 5

local _, L = ...
local G = _G

-- GROUP TAB
function SimpleMacroMenuGroupTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())
   SimpleMacroMenuCreateTab:Hide()
   SimpleMacroMenuGroupTab:Show()

   SM_UserButton_Update()
   SM_GroupButton_Update()
   SimpleMacroMenuGroupTabTargetText:ClearFocus()
end

-- create buttons containers
function SM_UserButtons_OnLoad(self)
   local macrosPerRow = GROUPTAB_MACROS_PER_ROW
   local button
   for i = 1, MAX_CHARACTER_MACROS do
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

function SM_GroupButtons_OnLoad(self)
   local macrosPerRow = GROUPTAB_MACROS_PER_ROW
   local button
   for i = 1, MAX_CHARACTER_MACROS do
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

   for i = 1, MAX_CHARACTER_MACROS do
      macroButtonName = "SMUserButton"..i
      macroButton = G[macroButtonName]
      macroIcon = G[macroButtonName.."Icon"]
      macroName = G[macroButtonName.."Name"]
      if i <= numCharacterMacros then
         name, texture, body = GetMacroInfo(MAX_ACCOUNT_MACROS + i)
         macroIcon:SetTexture(texture)
         macroName:SetText(name)
         macroButton:Enable()

         if SimpleMacroMenu.userSelect and SimpleMacroMenu.userSelect - MAX_ACCOUNT_MACROS == i then
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

function SM_GroupButton_Update()
   local numAccountMacros, numCharacterMacros = GetNumMacros()
   local macroButtonName, macroButton, macroIcon, macroName
   local name, texture, body
   local list = SimpleMacroMenu.groupButtons

   for i = 1, MAX_CHARACTER_MACROS do
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
   local leftButton = SimpleMacroMenu.userSelect
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

local function editmacro(index, target)
   local numAccountMacros, numCharacterMacros = GetNumMacros() -- API for users current # of macros
   local idx = tonumber(index)

   if isempty(index) then
      print("That is not a macro number.")
   elseif idx <= numCharacterMacros then
      local macroText = GetMacroBody(idx + MAX_ACCOUNT_MACROS)

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

         EditMacro(idx + MAX_ACCOUNT_MACROS, nil, nil, macroText)
         print("The macro at index "..idx.." was changed.")
      else
         print("/sm edit <macro #> <new target>")
      end
   else
      print("The macro number provided doesnt exist.")
   end
end

function SM_GroupTargetButton_OnClick(self)
   local id = SimpleMacroMenu.groupSelect
   local list = SimpleMacroMenu.groupButtons
   local target = SimpleMacroMenuTargetText:GetText()

   if not isempty(target) then
      for i = 1, #list do
         editmacro(list[i] - MAX_ACCOUNT_MACROS, target)
      end
   end
end
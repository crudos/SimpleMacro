-- Author      : Crudos
-- Create Date : 2/27/2015 05:17:35 PM
local _, L = ...
local G = _G

-- sets the selected macro button
function SimpleMacroButton_OnClick(self, button, down)
   local name = self:GetName()
   local id = self:GetID()

   if name == "SMUserButton"..id then
      SM_UserButton_SelectMacro(id)
      SM_UserButton_Update()
   elseif name == "SMGroupButton"..id then
      SM_GroupButton_SelectMacro(id)
      SM_GroupButton_Update()
   elseif name == "SMCreateButton"..id then
      SM_CreateTab_SelectMacro(id)
      SM_CreateTab_Update()
   elseif name == "SMIconButton"..id then
      SM_ChangeMenu_SelectIcon(id, nil)
      SimpleMacroChangeMenu_Update()
   end
end

function SimpleMacro_LoadButtons(frame, name, buttonsPerRow, totalButtons)
   local button

   for i = 1, totalButtons do
      button = CreateFrame("CheckButton", name..i, frame, "SimpleMacroButtonTemplate")
      button:SetID(i)
      if i == 1 then
         button:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
      elseif mod(i, buttonsPerRow) == 1 then
         button:SetPoint("TOP", name..(i - buttonsPerRow), "BOTTOM", 0, -10)

         if totalButtons - buttonsPerRow < i then
            SimpleMacroMenu[name.."LastRow"] = button:GetName()
         end
      else
         button:SetPoint("LEFT", name..(i - 1), "RIGHT", 13, 0)
      end
   end
end

-- picks up the correct macro when its in the group list
function SimplePickupMacro(self)
   local name = self:GetName()
   local id = self:GetID()

   if name == "SMGroupButton"..id then
      PickupMacro(SimpleMacroMenu.groupTable[id])
   else
      -- SMUserButton and SMCreateButton
      PickupMacro(id + SimpleMacroMenu.macroStart)
   end
end

function SM_CheckButton_OnClick(checkButton)
   if checkButton:GetChecked() and checkButton.interruptCheck then
      checkButton.interruptCheck(checkButton)
      checkButton:SetChecked(false)
      return
   elseif not checkButton:GetChecked() and checkButton.interruptUncheck then
      checkButton.interruptUncheck(checkButton)
      checkButton:SetChecked(true)
      return
   end
end

function SimpleMacroMenu_OnLoad(self)
   tinsert(UISpecialFrames, self:GetName())
   self:RegisterForDrag("LeftButton")
   self.name = "SimpleMacro"
   self.elapsed = 0

   PanelTemplates_SetNumTabs(SimpleMacroMenu, 2)
end

function SimpleMacroMenu_OnShow(self)
   PlaySound("igCharacterInfoOpen")
   local tabNum = SimpleMacro.dbc.tab

   PanelTemplates_SetTab(SimpleMacroMenu, tabNum)
   G["SimpleMacroMenu"..L["tabs"][tabNum].."Tab"]:Show()
end

function SimpleMacroMenu_OnHide(self)
   PlaySound("igCharacterInfoClose")
end

function SimpleMacroMenuTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())

   for i, tab in ipairs(L["tabs"]) do
      if i == self:GetID() then
         G["SimpleMacroMenu"..tab.."Tab"]:Show()
         SimpleMacro.dbc.tab = self:GetID()
      else
         G["SimpleMacroMenu"..tab.."Tab"]:Hide()
      end
   end
end

function SM_CloseButton_OnClick(self)
   G["SM_MacroEditor_AddNewLine"]:Enable()
   HideUIPanel(SimpleMacroMenu)
end
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
      --SM_SaveMacro()
      CreateTab_SelectMacro(id)
      CreateTab_Update()
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

function SimpleMacroMenu_OnLoad(panel)
   tinsert(UISpecialFrames, panel:GetName())
   panel:RegisterForDrag("LeftButton")
   panel.name = "SimpleMacro"
   panel.elapsed = 0

   PanelTemplates_SetNumTabs(SimpleMacroMenu, 2)
end

function SimpleMacroMenu_OnShow(panel)
   local tabNum = SimpleMacro.dbc.tab

   PanelTemplates_SetTab(SimpleMacroMenu, tabNum)
   G["SimpleMacroMenu"..L["tabs"][tabNum].."Tab"]:Show()

   PlaySound("igCharacterInfoOpen")
end

function SimpleMacroMenu_OnHide(panel)
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
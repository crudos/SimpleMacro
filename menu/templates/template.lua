local _, L = ...
local G = _G

-- sets the selected macro button
function SimpleMacroButton_OnClick(self, _, _)
  local name = self:GetName()
  local id = self:GetID()

  if name == "SMUserButton" .. id then
    SM_UserButton_SelectMacro(id)
    SM_UserButton_Update()
  elseif name == "SMGroupButton" .. id then
    SM_GroupButton_SelectMacro(id)
    SM_GroupButton_Update()
  elseif name == "SMCreateButton" .. id then
    SM_CreateTab_SelectMacro(id)
    SM_CreateTab_Update()
  elseif name == "SMIconButton" .. id then
    SM_ChangeMenu_SelectIcon(id, nil)
    SimpleMacroChangeMenu_Update()
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

-- picks up the correct macro when its in the group list
function SimplePickupMacro(self)
  local name = self:GetName()
  local id = self:GetID()

  if name == "SMGroupButton" .. id then
    PickupMacro(SimpleMacroMenu.groupTable[id])
  else
    -- SMUserButton and SMCreateButton
    PickupMacro(id + SimpleMacroMenu.macroStart)
  end
end

function SimpleMacroPopupFrameCancelButton_OnClick(self, ...)
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  local cancelFunction = self:GetParent().OnCancel;
  if cancelFunction then
    cancelFunction(self, ...);
  end
end

function SimpleMacroPopupFrameOkayButton_OnClick(self, ...)
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  local okayFunction = self:GetParent().OnOkay;
  if okayFunction then
    okayFunction(self, ...);
  end
end

function SimpleMacroPopupFrameDeleteButton_OnClick(self, ...)
  PlaySound(SOUNDKIT.GS_TITLE_OPTION_OK);
  local deleteFunction = self:GetParent().OnDelete;
  if deleteFunction then
    deleteFunction(self, ...);
  end
end
local _, L = ...
local G = _G


SimpleMacroButtonMixin = {};

function SimpleMacroButtonMixin:OnLoad()
  self:RegisterForDrag("LeftButton");
end

function SimpleMacroButtonMixin:OnClick()
  SelectorButtonMixin.OnClick(self);

  if InClickBindingMode() and ClickBindingFrame:HasNewSlot() then
    local actualIndex = SimpleMacroFrame:GetMacroDataIndex(self:GetElementData());
    ClickBindingFrame:AddNewAction(Enum.ClickBindingType.Macro, actualIndex);
  end
end

function SimpleMacroButtonMixin:OnDragStart()
  local actualIndex = SimpleMacroFrame:GetMacroDataIndex(self:GetElementData());
  PickupMacro(actualIndex);
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
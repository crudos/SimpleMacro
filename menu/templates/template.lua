SimpleMacroTopTabButtonMixin = {}

local TOP_TAB_HEIGHT_PERCENT = 0.75;
local TOP_TAB_BOTTOM_TEX_COORD = 1 - TOP_TAB_HEIGHT_PERCENT;

function SimpleMacroTopTabButtonMixin:OnLoad()
  PanelTabButtonMixin.OnLoad(self);

  for _, tabTexture in ipairs(self.TabTextures) do
    tabTexture:SetTexCoord(0, 1, 1, TOP_TAB_BOTTOM_TEX_COORD);
    tabTexture:SetHeight(tabTexture:GetHeight() * TOP_TAB_HEIGHT_PERCENT);
  end

  self.Left:ClearAllPoints();
  self.Left:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0);
  self.Right:ClearAllPoints();
  self.Right:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);

  self.LeftActive:ClearAllPoints();
  self.LeftActive:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0);
  self.RightActive:ClearAllPoints();
  self.RightActive:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0);

  self.isTopTab = true;
end

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
local _, L = ...
local G = _G

-- SimpleMacroEditorPopup_Update()

function SimpleMacroEditorPopup_ConditionalDropDown_Initialize(self)
  local selectedValue = self:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for i, conditional in ipairs(L["CONDITIONAL_LIST"]) do
    info.func = SimpleMacroEditorPopup_ConditionalDropDown_OnClick
    info.text = conditional["DEFAULT"]
    info.value = conditional["DEFAULT"]
    info.checked = info.value == selectedValue and 1 or nil
    info.tooltipTitle = conditional["DEFAULT"]
    info.tooltipText = L["CONDITIONAL_STRING"]["DESCRIPTION"][i]
    info.arg1 = conditional
    UIDropDownMenu_AddButton(info)
  end
end

function SimpleMacroEditorPopup_ConditionalDropDown_OnClick(self)
  self:GetParent()["dropdown"]:SetValue(self:GetID(), self.value)
end

function SimpleMacroEditorPopup_ConditionalDropDown_OnLoad(self)
  self.SetDefaultValue = function(this)
    this.id = 1
    this.value = L["CONDITIONAL_LIST"][1]["DEFAULT"]
    this.tooltip = L["CONDITIONAL_STRING"]["DESCRIPTION"][1]
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end
  self.SetValue = function(this, id, value)
    this.id = id
    this.value = value
    this.tooltip = L["CONDITIONAL_STRING"]["DESCRIPTION"][id]
    UIDropDownMenu_SetSelectedValue(this, value)
  end
  self.GetValue = function(this)
    return UIDropDownMenu_GetSelectedValue(this)
  end
  self.GetID = function(this)
    return this.id
  end
  self.RefreshValue = function(this)
    UIDropDownMenu_Initialize(this, SimpleMacroEditorPopup_ConditionalDropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end

  self:SetDefaultValue()
  UIDropDownMenu_SetWidth(self, 120)
  UIDropDownMenu_Initialize(self, SimpleMacroEditorPopup_ConditionalDropDown_Initialize)
  UIDropDownMenu_SetSelectedValue(self, self.value)
end

local function buttonRegionToDropdownRegion(point, relativeTo, relativePoint, xOffset, yOffset)
  return point, relativeTo, relativePoint, xOffset, yOffset;
end

function SimpleMacroEditorPopup_AddConditionalButton_OnClick(self)
  local conditionalGroupFrame, conditionalDropdownFrame, conditionalDeleteButton
  local i = 1

  conditionalDropdownFrame = CreateFrame("Frame", "SimpleMacroEditorPopup_ConditionalDropdown" .. i, SimpleMacroEditorPopup, "SimpleMacroEditorPopupDropDownTemplate")
  conditionalDropdownFrame:SetPoint(buttonRegionToDropdownRegion(self:GetPoint()))

  conditionalDeleteButton = CreateFrame("Button", conditionalDropdownFrame:GetName() .. ".DeleteButton", conditionalDropdownFrame, "UIPanelCloseButtonNoScripts")
  conditionalDeleteButton:SetPoint("LEFT", conditionalDropdownFrame, "RIGHT", -10, 3)
  --conditionalDeleteButton:SetScript("OnClick", )

  local _, height = conditionalDropdownFrame:GetSize()
  local _, _, _, _, yOffset = self:GetPoint()

  self:SetPoint("TOP", SimpleMacroEditorPopup, "TOP", 0, yOffset - height)
end

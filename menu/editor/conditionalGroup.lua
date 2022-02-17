local _, L = ...
local G = _G

function SimpleMacroEditorConditionalPopup_OnLoad()

end

function SimpleMacroEditorConditionalPopup_OnShow(self)
  print(self:GetID())
end

function SimpleMacroEditorConditionalPopup_OnHide()

end

function SimpleMacroEditorConditionalPopup_CancelButton_OnClick(self)
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset()
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorConditionalPopup_OkayButton_OnClick(self)
end

function SimpleMacroEditorConditionalPopup_DeleteButton_OnClick(self)
end

function SimpleMacroEditorConditionalPopup_DropDown_Initialize(self)
  local selectedValue = self:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for i, conditional in ipairs(L["CONDITIONAL_LIST"]) do
    info.func = SimpleMacroEditorConditionalPopup_DropDown_OnClick
    info.text = conditional["DEFAULT"]
    info.value = conditional["DEFAULT"]
    info.checked = info.value == selectedValue and 1 or nil
    info.tooltipTitle = conditional["DEFAULT"]
    info.tooltipText = L["CONDITIONAL_STRING"]["DESCRIPTION"][i]
    info.arg1 = conditional
    UIDropDownMenu_AddButton(info)
  end
end

function SimpleMacroEditorConditionalPopup_DropDown_OnClick(self)
  print("dropdown onclick")
  SM_printall(self)
  SM_printall(self:GetParent())
  self:GetParent()["dropdown"]:SetValue(self:GetID(), self.value)
end

function SimpleMacroEditorConditionalPopup_DropDown_OnLoad(self)
  print("loading")

  self.SetDefaultValue = function(this)
    this.id = 1
    this.value = L["CONDITIONAL_LIST"][1]["DEFAULT"]
    this.tooltip = L["CONDITIONAL_STRING"]["DESCRIPTION"][1]
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end
  self.SetValue = function(this, id, value)
    print("set value")
    this.id = id
    this.value = value
    this.tooltip = L["CONDITIONAL_STRING"]["DESCRIPTION"][id]
    print(this.tooltip)
    UIDropDownMenu_SetSelectedValue(this, value)
  end
  self.GetValue = function(this)
    return UIDropDownMenu_GetSelectedValue(this)
  end
  self.GetID = function(this)
    return this.id
  end
  self.RefreshValue = function(this)
    -- Necessary?
    -- UIDropDownMenu_Initialize(this, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end

  self:SetDefaultValue()
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")

  UIDropDownMenu_SetWidth(self, 120)
  UIDropDownMenu_Initialize(self, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
  UIDropDownMenu_SetSelectedValue(self, self.value)
end

local function createConditionalDropDown(addButton, index)
  local conditionalDropDownFrame, deleteConditionalButton

  conditionalDropDownFrame = CreateFrame("Frame",
                                         "SimpleMacroEditorConditionalPopup.ConditionalDropDown" .. index,
                                         SimpleMacroEditorConditionalPopup,
                                         "SimpleMacroEditorPopupConditionalDropDownTemplate")
  conditionalDropDownFrame:SetPoint(addButton:GetPoint())

  deleteConditionalButton = CreateFrame("Button",
                                        conditionalDropDownFrame:GetName() .. ".DeleteButton",
                                        conditionalDropDownFrame,
                                        "UIPanelCloseButtonNoScripts")
  deleteConditionalButton:SetPoint("LEFT", conditionalDropDownFrame, "RIGHT", -10, 3)

  local _, height = conditionalDropDownFrame:GetSize()
  local _, _, _, _, yOffset = addButton:GetPoint()

  addButton:SetPoint("TOP", SimpleMacroEditorConditionalPopup, "TOP", 0, yOffset - height)
end

function SimpleMacroEditorConditionalPopup_AddConditionalButton_OnClick(self)
  createConditionalDropDown(self, 0)
end
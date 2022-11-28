local _, ns = ...
local L = ns.L["CONDITIONAL_EDITOR"]
local C = ns.C["CONDITIONAL_EDITOR"]
local G = _G

SimpleMacroEditorConditionalPopupMixin = {}

function SimpleMacroEditorConditionalPopupMixin:OnLoad()
  self:SetTitle(GetGlobalString("CONDITIONAL_EDITOR_TITLE"))
  self.editor = SimpleMacroEditorPopup
end

function SimpleMacroEditorConditionalPopupMixin:OnShow()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
end

function SimpleMacroEditorConditionalPopupMixin:OnHide()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
  SimpleMacroEditorPopup_ConditionalGroupButton_Unclick(self:GetID())
end

function SimpleMacroEditorConditionalPopupMixin:GetConditionalDropDowns()
  if self.conditionalDropDowns == nil then
    self.conditionalDropDowns = {}
  end
  return self.conditionalDropDowns
end

function SimpleMacroEditorConditionalPopupMixin:AddConditionalDropDown(dropDown)
  if self.conditionalDropDowns == nil then
    self.conditionalDropDowns = {}
  end
  return tinsert(self.conditionalDropDowns, dropDown)
end

function SimpleMacroEditorConditionalPopupMixin:RemoveConditionalDropDown()
  return tremove(self.conditionalDropDowns, #self.conditionalDropDowns)
end

function SimpleMacroEditorConditionalPopupMixin:ResetConditionalDropDowns()
  self.conditionalDropDowns = nil
end

function SimpleMacroEditorConditionalPopupMixin:Save()
  local dropDowns = self:GetConditionalDropDowns()
  local sMacro = SimpleMacroEditorPopup:GetSMacro()
  local selectedLine, selectedArgument = SimpleMacroEditorPopup:GetSelected()
  local selectedConditionalGroup = self:GetID()
  local parsedConditionalCount = #sMacro:getConditionals(selectedLine, selectedArgument, selectedConditionalGroup)

  for i, dropDown in ipairs(dropDowns) do
    if i <= parsedConditionalCount then
      sMacro:setConditional(selectedLine,
                            selectedArgument,
                            selectedConditionalGroup,
                            i,
                            dropDown:GetValue(),
                            dropDown:GetInputValue())
    else
      sMacro:addConditional(selectedLine,
                            selectedArgument,
                            selectedConditionalGroup,
                            dropDown:GetValue(),
                            dropDown:GetInputValue())
    end
  end

  if parsedConditionalCount - #dropDowns > 0 then
    for i = #dropDowns + 1, parsedConditionalCount do
      sMacro:removeConditional(selectedLine,
                               selectedArgument,
                               selectedConditionalGroup,
                               i)
    end
  end

  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
  SimpleMacroFrame:Update()
end

function SimpleMacroEditorConditionalPopupMixin:Delete()
  local sMacro = SimpleMacroEditorPopup:GetSMacro()
  local selectedLine, selectedArgument = SimpleMacroEditorPopup:GetSelected()
  local selectedConditionalGroup = self:GetID()

  sMacro:removeConditionalGroup(selectedLine,
                                selectedArgument,
                                selectedConditionalGroup)
  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
  SimpleMacroFrame:Update()
end

function SimpleMacroEditorConditionalPopupMixin:Update()
  local currentLine, currentArgument = SimpleMacroEditorPopup:GetSelected()
  local sMacro = SimpleMacroEditorPopup:GetSMacro()
  local conditionals = sMacro:getConditionals(currentLine, currentArgument, self:GetID())

  for i, conditional in ipairs(conditionals) do
    local currentDropDown = getConditionalDropDown(i)
    currentDropDown:SetValue(conditional.name)
    currentDropDown:SetInputValue(conditional.input or "")
  end

  for _ = 1, #self:GetConditionalDropDowns() - #conditionals do
    hideLastConditionalDropDown()
  end

  self:UpdateButtons()
end

function SimpleMacroEditorConditionalPopupMixin:UpdateButtons()
  local addButton = self.AddConditionalButton
  if #self:GetConditionalDropDowns() >= C["MAX_CONDITIONALS"] then
    addButton:Disable()
  else
    addButton:Enable()
  end
end

-- old



-- button onclicks
function SimpleMacroEditorConditionalPopup_CancelButton_OnClick(self)
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset()
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorConditionalPopup_OkayButton_OnClick(self)
  local parent = self:GetParent()
  parent:Save()
  HideUIPanel(parent)
end

function SimpleMacroEditorConditionalPopup_DeleteButton_OnClick(self)
  local parent = self:GetParent()
  parent:Delete()
  HideUIPanel(parent)
end

function SimpleMacroEditorConditionalPopup_DropDown_Initialize(self)
  local selectedValue = self:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for i, conditionalData in ipairs(C["CONDITIONALS"]) do
    for _, alias in ipairs(conditionalData["ALIASES"]) do
      info.func = SimpleMacroEditorConditionalPopup_DropDown_OnClick
      info.text = alias
      info.value = alias
      info.checked = info.value == selectedValue and 1 or nil
      info.tooltipTitle = alias
      info.tooltipText = L["DESCRIPTION"][i]
      info.arg1 = conditionalData
      UIDropDownMenu_AddButton(info)
    end
  end
end

function SimpleMacroEditorConditionalPopup_DropDown_OnClick(self)
  self:GetParent()["dropdown"]:SetValue(self.value)
end

function SimpleMacroEditorConditionalPopup_DropDown_OnLoad(self)
  self.RefreshValue = function(this)
    UIDropDownMenu_Initialize(self, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end
  self.SetValue = function(this, value)
    for i, conditionalData in ipairs(C["CONDITIONALS"]) do
      for _, alias in ipairs(conditionalData["ALIASES"]) do
        if value == alias then
          this.id = i
          this.value = alias
          this.tooltip = L["DESCRIPTION"][i]
          break
        end
      end
    end
    UIDropDownMenu_SetSelectedValue(this, value)

    local editBox = this.editBox
    if editBox ~= nil then
      if C["CONDITIONALS"][self:GetID()]["INPUT_HINT"] ~= nil then
        editBox:Show()
      else
        editBox:Hide()
      end
    end

    this:RefreshValue()
  end
  self.GetValue = function(this)
    return UIDropDownMenu_GetSelectedValue(this)
  end
  self.SetID = function(this, value)
    this.id = value
  end
  self.GetID = function(this)
    return this.id
  end
  self.SetEditBox = function(this, editBox)
    this.editBox = editBox
  end
  self.SetInputValue = function(this, value)
    local editBox = this.editBox
    if editBox and editBox:IsShown() then
      editBox:SetText(value)
    end
  end
  self.GetInputValue = function(this)
    return this.editBox:GetText()
  end
  self.SetDefaultValue = function(this)
    this.id = 1
    this.value = C["CONDITIONALS"][1]["ALIASES"][1]
    this.tooltip = L["DESCRIPTION"][1]
    this:SetInputValue("")
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end

  self:SetDefaultValue()

  UIDropDownMenu_SetWidth(self, 90)
  UIDropDownMenu_Initialize(self, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
  UIDropDownMenu_SetSelectedValue(self, self.value)
end

function hideLastConditionalDropDown()
  local popupFrame = SimpleMacroEditorConditionalPopup
  local addButton = popupFrame.AddConditionalButton
  local conditionalDropDownName = popupFrame:GetName()..".ConditionalDropDown"..#popupFrame:GetConditionalDropDowns()

  if G[conditionalDropDownName] ~= nil then
    local conditionalDropDown = G[conditionalDropDownName]
    conditionalDropDown:Hide()
    G[conditionalDropDown:GetName()..".DeleteButton"]:Hide()
    conditionalDropDown:SetDefaultValue()

    -- resize parent, move add button, remove dropdown
    local parentX, parentY = popupFrame:GetSize()
    local _, buttonY = addButton:GetSize()
    popupFrame:SetSize(parentX, parentY - (buttonY + 10))
    popupFrame:RemoveConditionalDropDown()
  end
end

function getConditionalDropDown(index)
  local popupFrame = SimpleMacroEditorConditionalPopup
  local addButton = popupFrame.AddConditionalButton
  local _, buttonY = addButton:GetSize()
  local conditionalDropDownName = popupFrame:GetName()..".ConditionalDropDown"..index
  local shouldResize = false

  local conditionalDropDown
  if G[conditionalDropDownName] ~= nil then
    conditionalDropDown = G[conditionalDropDownName]

    if not conditionalDropDown:IsVisible() then
      conditionalDropDown:Show()
      G[conditionalDropDown:GetName()..".DeleteButton"]:Show()
      shouldResize = true
    end
  else
    conditionalDropDown = CreateFrame("Frame",
                                      conditionalDropDownName,
                                      popupFrame,
                                      "SimpleMacroEditorPopupConditionalDropDownTemplate")
    conditionalDropDown:SetID(index) -- doesn't work?
    conditionalDropDown:SetPoint("TOP", popupFrame, "TOP", -60, -10 - ((buttonY + 10) * index))
    local x, y = conditionalDropDown:GetSize()
    conditionalDropDown:SetSize(x, y)

    local editBox = CreateFrame("EditBox",
                                conditionalDropDown:GetName()..".EditBox",
                                conditionalDropDown,
                                "SimpleMacroEditorPopupEditBoxTemplate")
    editBox:SetPoint("LEFT", conditionalDropDown, "RIGHT", -3, 2)
    editBox:SetSize(80, 27)
    conditionalDropDown:SetEditBox(editBox)

    local deleteConditionalButton = CreateFrame("Button",
                                                conditionalDropDown:GetName()..".DeleteButton",
                                                conditionalDropDown,
                                                "UIPanelCloseButtonNoScripts")
    deleteConditionalButton:SetPoint("LEFT", editBox, "RIGHT", 4, 2)
    deleteConditionalButton:SetScript("OnClick", SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick)
    deleteConditionalButton:SetID(index)

    shouldResize = true
  end

  -- resize parent, move add button, store dropdown
  if shouldResize and index > #popupFrame:GetConditionalDropDowns() then
    local p1, p2, p3, p4, p5 = addButton:GetPoint() -- store location before resize
    local parentX, parentY = popupFrame:GetSize()
    popupFrame:SetSize(parentX, parentY + buttonY + 10)
    addButton:SetPoint(p1, p2, p3, p4, p5)
    popupFrame:AddConditionalDropDown(conditionalDropDown)
  end

  return conditionalDropDown
end

function SimpleMacroEditorConditionalPopup_AddConditionalButton_OnClick()
  local conditionalDropDowns = SimpleMacroEditorConditionalPopup:GetConditionalDropDowns()
  local conditionalDropDownCount = conditionalDropDowns ~= nil and #conditionalDropDowns or 0

  getConditionalDropDown(conditionalDropDownCount + 1)
  SimpleMacroEditorConditionalPopup:UpdateButtons()
end

function SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick(self)
  local conditionalDropDowns = SimpleMacroEditorConditionalPopup:GetConditionalDropDowns()
  local currentDropDownId = self:GetID()

  for i, conditionalDropDown in ipairs(conditionalDropDowns) do
    if i >= currentDropDownId and conditionalDropDowns[i+1] ~= nil then
      conditionalDropDown:SetValue(conditionalDropDowns[i+1]:GetValue())
      conditionalDropDown:SetInputValue(conditionalDropDowns[i+1]:GetInputValue() or "")
    end
  end

  hideLastConditionalDropDown()
  SimpleMacroEditorConditionalPopup:UpdateButtons()
end
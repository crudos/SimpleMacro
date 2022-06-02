local _, L = ...
local G = _G

function SimpleMacroEditorConditionalPopup_OnLoad(self)
  self.Update = SimpleMacroEditorConditionalPopup_Update
  self.GetConditionalDropDowns = function(this)
    return this.conditionalDropDowns
  end
  self.InsertConditionalDropDown = function(this, dropDown)
    if this.conditionalDropDowns == nil then
      this.conditionalDropDowns = {}
    end
    tinsert(this.conditionalDropDowns, dropDown)
  end
  self.RemoveConditionalDropDown = function(this)
    tremove(this.conditionalDropDowns, #this.conditionalDropDowns)
  end
end

function SimpleMacroEditorConditionalPopup_OnShow(self)
  SimpleMacroEditorConditionalPopup_Update(self)
end

function SimpleMacroEditorConditionalPopup_OnHide(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
end

function SimpleMacroEditorConditionalPopup_CancelButton_OnClick(self)
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset()
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorConditionalPopup_OkayButton_OnClick(self)
end

function SimpleMacroEditorConditionalPopup_DeleteButton_OnClick(self)
  -- TODO re-enable add group button if disabled
end

function SimpleMacroEditorConditionalPopup_DropDown_Initialize(self)
  local selectedValue = self:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for i, conditionalData in ipairs(L["CONDITIONAL_LIST"]) do
    for _, alias in ipairs(conditionalData["ALIASES"]) do
      info.func = SimpleMacroEditorConditionalPopup_DropDown_OnClick
      info.text = alias
      info.value = alias
      info.checked = info.value == selectedValue and 1 or nil
      info.tooltipTitle = alias
      info.tooltipText = L["CONDITIONAL_STRING"]["DESCRIPTION"][i]
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
  self.SetDefaultValue = function(this)
    this.id = 1
    this.value = L["CONDITIONAL_LIST"][1]["ALIASES"][1]
    this.tooltip = L["CONDITIONAL_STRING"]["DESCRIPTION"][1]
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end
  self.SetValue = function(this, value)
    for i, conditionalData in ipairs(L["CONDITIONAL_LIST"]) do
      for _, alias in ipairs(conditionalData["ALIASES"]) do
        if value == alias then
          this.id = i
          this.value = alias
          this.tooltip = L["CONDITIONAL_STRING"]["DESCRIPTION"][i]
          break
        end
      end
    end
    UIDropDownMenu_SetSelectedValue(this, value)
    this:RefreshValue()
  end
  self.GetValue = function(this)
    return UIDropDownMenu_GetSelectedValue(this)
  end
  self.GetID = function(this)
    return this.id
  end

  self:SetDefaultValue()

  UIDropDownMenu_SetWidth(self, 90)
  UIDropDownMenu_Initialize(self, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
  UIDropDownMenu_SetSelectedValue(self, self.value)
end

local function hideLastConditionalDropDown()
  local popupFrame = SimpleMacroEditorConditionalPopup
  local addButton = popupFrame.AddConditionalButton
  local conditionalDropDownName = popupFrame:GetName() .. ".ConditionalDropDown" .. #popupFrame:GetConditionalDropDowns()

  if G[conditionalDropDownName] ~= nil then
    local conditionalDropDown = G[conditionalDropDownName]
    conditionalDropDown:Hide()
    G[conditionalDropDown:GetName() .. ".DeleteButton"]:Hide()

    -- resize parent, move add button, remove dropdown
    local parentX, parentY = popupFrame:GetSize()
    local _, buttonY = addButton:GetSize()
    popupFrame:SetSize(parentX, parentY - (buttonY + 10))
    addButton:SetPoint(conditionalDropDown:GetPoint())
    popupFrame:RemoveConditionalDropDown()
  end
end

local function createConditionalDropDown(index)
  local popupFrame = SimpleMacroEditorConditionalPopup
  local addButton = popupFrame.AddConditionalButton
  local _, buttonY = addButton:GetSize()
  local conditionalDropDownName = popupFrame:GetName() .. ".ConditionalDropDown" .. index
  local shouldResize = false

  local conditionalDropDown
  if G[conditionalDropDownName] ~= nil then
    conditionalDropDown = G[conditionalDropDownName]

    if not conditionalDropDown:IsVisible() then
      conditionalDropDown:Show()
      G[conditionalDropDown:GetName() .. ".DeleteButton"]:Show()
      shouldResize = true
    end
  else
    -- has input
    local hasInput = index == 1

    conditionalDropDown = CreateFrame("Frame",
                                      conditionalDropDownName,
                                      popupFrame,
                                      "SimpleMacroEditorPopupConditionalDropDownTemplate")
    conditionalDropDown:SetID(index)
    conditionalDropDown:SetPoint("TOP", popupFrame, "TOP", hasInput and -60 or 0, -10 - ((buttonY + 10) * index))
    local x, y = conditionalDropDown:GetSize()
    conditionalDropDown:SetSize(x, y)

    local editBox = CreateFrame("EditBox",
                                conditionalDropDown:GetName() .. ".EditBox",
                                conditionalDropDown,
                                "SimpleMacroEditorPopupEditBoxTemplate")
    editBox:SetPoint("LEFT", conditionalDropDown, "RIGHT", -3, 2)
    editBox:SetSize(80, 27)

    local deleteConditionalButton = CreateFrame("Button",
                                                conditionalDropDown:GetName() .. ".DeleteButton",
                                                conditionalDropDown,
                                                "UIPanelCloseButtonNoScripts")
    deleteConditionalButton:SetPoint("LEFT", not hasInput and conditionalDropDown or editBox, "RIGHT", hasInput and 4 or -16, 2)
    deleteConditionalButton:SetScript("OnClick", SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick)
    shouldResize = true
  end

  -- resize parent, move add button, store dropdown
  if shouldResize then
    local p1, p2, p3, p4, p5 = addButton:GetPoint() -- store location before resize
    local parentX, parentY = popupFrame:GetSize()
    popupFrame:SetSize(parentX, parentY + buttonY + 10)
    addButton:SetPoint(p1, p2, p3, p4, p5)

    popupFrame:InsertConditionalDropDown(conditionalDropDown)
  end

  return conditionalDropDown
end

function SimpleMacroEditorConditionalPopup_AddConditionalButton_OnClick(self)
  local conditionalDropDowns = SimpleMacroEditorConditionalPopup:GetConditionalDropDowns()
  local conditionalDropDownCount = conditionalDropDowns ~= nil and #conditionalDropDowns or 0

  createConditionalDropDown(conditionalDropDownCount + 1)

  if #SimpleMacroEditorConditionalPopup:GetConditionalDropDowns() >= L["MACRO_EDITOR"]["MAX_CONDITIONALS"] then
    self:Disable()
  end
end

function SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick(self)
  hideLastConditionalDropDown()
end

function SimpleMacroEditorConditionalPopup_Update(self)
  local currentLine = SimpleMacroEditorPopup:GetSelectedLine()
  local currentArgument = SimpleMacroEditorPopup:GetSelectedArgument()
  local parsedMacro = SimpleMacroEditorPopup:GetParsed()
  local conditionals = parsedMacro:getConditionals(currentLine, currentArgument, self:GetID())

  for i, conditional in ipairs(conditionals) do
    local currentDropDown = createConditionalDropDown(i)
    currentDropDown:SetValue(conditional.name)
  end

  for _ = 1, #self:GetConditionalDropDowns() - #conditionals do
    hideLastConditionalDropDown()
  end
end
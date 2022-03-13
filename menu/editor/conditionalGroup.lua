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
  end
  self.GetValue = function(this)
    return UIDropDownMenu_GetSelectedValue(this)
  end
  self.GetID = function(this)
    return this.id
  end
  self.RefreshValue = function(this)
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end

  self:SetDefaultValue()

  UIDropDownMenu_SetWidth(self, 90)
  UIDropDownMenu_Initialize(self, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
  UIDropDownMenu_SetSelectedValue(self, self.value)
end

local function hideConditionalDropDown(addButton)
  local parentFrame = addButton:GetParent()
  local conditionalDropDownName = "SimpleMacroEditorConditionalPopup.ConditionalDropDown" .. #parentFrame:GetConditionalDropDowns()
  if G[conditionalDropDownName] ~= nil then
    local conditionalDropDown = G[conditionalDropDownName]
    conditionalDropDown:Hide()
    G[conditionalDropDown:GetName() .. ".DeleteButton"]:Hide()

    -- resize parent, move add button
    local parentX, parentY = parentFrame:GetSize()
    local _, buttonY = addButton:GetSize()
    parentFrame:SetSize(parentX, parentY - (buttonY + 10))
    addButton:SetPoint(conditionalDropDown:GetPoint())

    parentFrame:RemoveConditionalDropDown()
  end
end

local function createConditionalDropDown(addButton, index)
  local parentFrame = addButton:GetParent()
  local conditionalDropDownName = "SimpleMacroEditorConditionalPopup.ConditionalDropDown" .. index
  local shouldResize = false
  local conditionalDropDown
  if G[conditionalDropDownName] ~= nil then
    conditionalDropDown = G[conditionalDropDownName]

    if not conditionalDropDown:IsVisible() then
      shouldResize = true
      conditionalDropDown:Show()
      G[conditionalDropDown:GetName() .. ".DeleteButton"]:Show()
    end
  else
    conditionalDropDown = CreateFrame("Frame",
                                      conditionalDropDownName,
                                      parentFrame,
                                      "SimpleMacroEditorPopupConditionalDropDownTemplate")
    conditionalDropDown:SetID(index)
    conditionalDropDown:SetPoint(addButton:GetPoint())

    local deleteConditionalButton = CreateFrame("Button",
                                          conditionalDropDown:GetName() .. ".DeleteButton",
                                          conditionalDropDown,
                                          "UIPanelCloseButtonNoScripts")
    deleteConditionalButton:SetPoint("LEFT", conditionalDropDown, "RIGHT", -10, 3)
    deleteConditionalButton:SetScript("OnClick", SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick)

    shouldResize = true
  end

  if shouldResize then
    -- resize parent, move add button
    local parentX, parentY = parentFrame:GetSize()
    local _, buttonY = addButton:GetSize()
    parentFrame:SetSize(parentX, parentY + buttonY + 10)
    addButton:SetPoint("TOP", conditionalDropDown, "BOTTOM", 0, 0)

    parentFrame:InsertConditionalDropDown(conditionalDropDown)
  end

  return conditionalDropDown
end

function SimpleMacroEditorConditionalPopup_AddConditionalButton_OnClick(self)
  local conditionalDropDowns = SimpleMacroEditorConditionalPopup:GetConditionalDropDowns()
  local conditionalDropDownCount = conditionalDropDowns ~= nil and #conditionalDropDowns or 0

  createConditionalDropDown(self, conditionalDropDownCount + 1)

  if #SimpleMacroEditorConditionalPopup:GetConditionalDropDowns() >= L["MACRO_EDITOR"]["MAX_CONDITIONALS"] then
    self:Disable()
  end
end

function SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick(self)
  self:GetParent():Hide()

  -- remove last conditional frame, move add button up
end

function SimpleMacroEditorConditionalPopup_Update(self)
  local currentLine = SimpleMacroEditorPopup:GetSelectedLine()
  local currentArgument = SimpleMacroEditorPopup:GetSelectedArgument()

  local parsedMacro = SimpleMacroEditorPopup:GetParsed()
  local conditionals = parsedMacro:getConditionals(currentLine, currentArgument, SimpleMacroEditorConditionalPopup:GetID())

  for i, conditional in ipairs(conditionals) do
    local currentDropDown = createConditionalDropDown(self.AddConditionalButton, i)
    currentDropDown:SetValue(conditional.name)
  end

  for i = 1, #self:GetConditionalDropDowns() - #conditionals do
    hideConditionalDropDown(self.AddConditionalButton)
  end
end
local _, ns = ...
local L = ns.L
local C = ns.C
local G = _G

local function saveConditionalGroups(conditionalPopup)
  local dropDowns = conditionalPopup:GetConditionalDropDowns()
  local editor = conditionalPopup.editor
  local parsed = editor:GetParsed()
  local selectedLine = editor:GetSelectedLine()
  local selectedArgument = editor:GetSelectedArgument()
  local selectedConditionalGroup = conditionalPopup:GetID()
  local parsedConditionalCount = #parsed:getConditionals(selectedLine, selectedArgument, selectedConditionalGroup)

  for i, dropDown in ipairs(dropDowns) do
    if i <= parsedConditionalCount then
      parsed:setConditional(selectedLine,
                            selectedArgument,
                            selectedConditionalGroup,
                            i,
                            dropDown:GetValue(),
                            dropDown:GetInputValue())
    else
      parsed:addConditional(selectedLine,
                            selectedArgument,
                            selectedConditionalGroup,
                            dropDown:GetValue(),
                            dropDown:GetInputValue())
    end
  end

  if parsedConditionalCount - #dropDowns > 0 then
    for i = #dropDowns + 1, parsedConditionalCount do
      parsed:removeConditional(selectedLine,
                               selectedArgument,
                               selectedConditionalGroup,
                               i)
    end
  end

  EditMacro(parsed:getID(), nil, nil, parsed:compose())
end

local function deleteConditionalGroup(conditionalPopup)
  local editor = conditionalPopup.editor
  local parsed = editor:GetParsed()
  local selectedLine = editor:GetSelectedLine()
  local selectedArgument = editor:GetSelectedArgument()
  local selectedConditionalGroup = conditionalPopup:GetID()

  parsed:removeConditionalGroup(selectedLine,
                                selectedArgument,
                                selectedConditionalGroup)

  EditMacro(parsed:getID(), nil, nil, parsed:compose())
end

function SimpleMacroEditorConditionalPopup_OnLoad(self)
  self.Update = SimpleMacroEditorConditionalPopup_Update
  self.GetConditionalDropDowns = function(this)
    if this.conditionalDropDowns == nil then
      this.conditionalDropDowns = {}
    end
    return this.conditionalDropDowns
  end
  self.AddConditionalDropDown = function(this, dropDown)
    if this.conditionalDropDowns == nil then
      this.conditionalDropDowns = {}
    end
    tinsert(this.conditionalDropDowns, dropDown)
  end
  self.RemoveConditionalDropDown = function(this)
    tremove(this.conditionalDropDowns, #this.conditionalDropDowns)
  end
  self.editor = SimpleMacroEditorPopup
end

function SimpleMacroEditorConditionalPopup_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
end

function SimpleMacroEditorConditionalPopup_OnHide(self)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
  SimpleMacroEditorPopup_ConditionalGroupButton_Unclick(self:GetID())
end

function SimpleMacroEditorConditionalPopup_CancelButton_OnClick(self)
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset()
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorConditionalPopup_OkayButton_OnClick(self)
  local conditionalPopup = self:GetParent()
  saveConditionalGroups(conditionalPopup)
  HideUIPanel(conditionalPopup)
end

function SimpleMacroEditorConditionalPopup_DeleteButton_OnClick(self)
  local conditionalPopup = self:GetParent()
  deleteConditionalGroup(conditionalPopup)
  SM_MacroEditor_Update()
  HideUIPanel(conditionalPopup)
end

function SimpleMacroEditorConditionalPopup_DropDown_Initialize(self)
  local selectedValue = self:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for i, conditionalData in ipairs(C["CONDITIONAL_LIST"]) do
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
  self.SetValue = function(this, value)
    for i, conditionalData in ipairs(C["CONDITIONAL_LIST"]) do
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

    local editBox = this.editBox
    if editBox ~= nil then
      if C["CONDITIONAL_LIST"][self:GetID()]["INPUT_HINT"] ~= nil then
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
    this.value = C["CONDITIONAL_LIST"][1]["ALIASES"][1]
    this.tooltip = C["CONDITIONAL_STRING"]["DESCRIPTION"][1]
    this:SetInputValue("")
    UIDropDownMenu_SetSelectedValue(this, this.value)
  end

  self:SetDefaultValue()

  UIDropDownMenu_SetWidth(self, 90)
  UIDropDownMenu_Initialize(self, SimpleMacroEditorConditionalPopup_DropDown_Initialize)
  UIDropDownMenu_SetSelectedValue(self, self.value)
end

local function hideLastConditionalDropDown()
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

local function createConditionalDropDown(index)
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

local function addConditionalButtonUpdate()
  local popupFrame = SimpleMacroEditorConditionalPopup
  local addButton = popupFrame.AddConditionalButton

  if #popupFrame:GetConditionalDropDowns() >= L["MACRO_EDITOR"]["MAX_CONDITIONALS"] then
    addButton:Disable()
  else
    addButton:Enable()
  end
end

function SimpleMacroEditorConditionalPopup_AddConditionalButton_OnClick()
  local conditionalDropDowns = SimpleMacroEditorConditionalPopup:GetConditionalDropDowns()
  local conditionalDropDownCount = conditionalDropDowns ~= nil and #conditionalDropDowns or 0

  createConditionalDropDown(conditionalDropDownCount + 1)
  addConditionalButtonUpdate()
end

function SimpleMacroEditorConditionalPopup_ConditionalDropDownDeleteButton_OnClick(self)
  local conditionalDropDowns = SimpleMacroEditorConditionalPopup:GetConditionalDropDowns()
  local currentDropDownId = self:GetID()

  for i, conditionalDropDown in ipairs(conditionalDropDowns) do
    if i >= currentDropDownId and conditionalDropDowns[i+1] ~= nil then
      conditionalDropDown:SetValue(conditionalDropDowns[i+1]:GetValue())
      conditionalDropDown:SetInputValue(conditionalDropDowns[i+1]:GetInputValue())
    end
  end

  hideLastConditionalDropDown()
  addConditionalButtonUpdate()
end

function SimpleMacroEditorConditionalPopup_Update(self)
  local currentLine = SimpleMacroEditorPopup:GetSelectedLine()
  local currentArgument = SimpleMacroEditorPopup:GetSelectedArgument()
  local parsedMacro = SimpleMacroEditorPopup:GetParsed()
  local conditionals = parsedMacro:getConditionals(currentLine, currentArgument, self:GetID())

  for i, conditional in ipairs(conditionals) do
    local currentDropDown = createConditionalDropDown(i)
    currentDropDown:SetValue(conditional.name)
    currentDropDown:SetInputValue(conditional.input)
  end

  for _ = 1, #self:GetConditionalDropDowns() - #conditionals do
    hideLastConditionalDropDown()
  end

  addConditionalButtonUpdate()
end
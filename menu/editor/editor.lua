local _, L = ...
local G = _G

--[[
  SimpleMacroEditorPopup
]]
local function generateCommandString(category, command)
  return (category == L["MACRO_EDITOR"]["HASH_CATEGORY"] and '#' or '/')..command
end

local function saveArgumentAndCommand(editor)
  local parsed = editor:GetParsed()
  local selectedLine = editor:GetSelectedLine()

  parsed:setCommand(selectedLine,
                    generateCommandString(editor.CategoryDropDown:GetValue(),
                                          editor.CommandDropDown:GetValue()))
  parsed:setArgument(selectedLine,
                     editor:GetSelectedArgument(),
                     editor.ArgumentEditBox:GetText())

  EditMacro(parsed:getID(), nil, nil, parsed:compose())
end

function SimpleMacroEditorPopup_OnLoad(self)
  self.GetSelectedMacro = function(this)
    return this.selectedMacro
  end
  self.GetParsed = function(this)
    return this.selectedMacro.parsed
  end
  self.SetSelectedMacro = function(this, id)
    local name, texture, body = GetMacroInfo(id)

    this.selectedMacro = { name = name, texture = texture, body = body }
    this.selectedMacro.parsed = SMacro:new()
    this.selectedMacro.parsed:set(id)
  end
  self.GetSelectedLine = function(this)
    return this.selectedLine
  end
  self.SetSelectedLine = function(this, id)
    this.selectedLine = id
  end
  self.GetSelectedArgument = function(this)
    return this.selectedArgument
  end
  self.SetSelectedArgument = function(this, id)
    this.selectedArgument = id
  end
  self.GetConditionalGroupButtons = function(this)
    if this.conditionalGroupButtons == nil then
      this.conditionalGroupButtons = {}
    end
    return this.conditionalGroupButtons
  end
  self.InsertConditionalGroupButton = function(this, groupButton)
    if this.conditionalGroupButtons == nil then
      this.conditionalGroupButtons = {}
    end
    tinsert(this.conditionalGroupButtons, groupButton)
  end
  self.RemoveLastConditionalGroupButton = function(this)
    tremove(this.conditionalGroupButtons)
  end
end

function SimpleMacroEditorPopup_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
end

function SimpleMacroEditorPopup_OnHide(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
  SM_MacroEditor_Update()

  -- close conditional popup
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(nil)
  HideUIPanel(SimpleMacroEditorConditionalPopup)
end

function SimpleMacroEditorPopup_CancelButton_OnClick(self)
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorPopup_OkayButton_OnClick(self)
  local editor = self:GetParent()
  saveArgumentAndCommand(editor)
  SimpleMacroFrame.currentMacro = nil --clear state to reload
  SM_MacroEditor_Update()
  HideUIPanel(editor)
end

function SimpleMacroEditorPopup_DeleteButton_OnClick(self)
  HideUIPanel(self:GetParent())
end

--[[
  Category DropDown
]]
function SimpleMacroEditorPopup_CategoryDropDown_OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    self.RefreshValue = function(this)
      UIDropDownMenu_Initialize(this, SimpleMacroEditorPopup_CategoryDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(this, this.value)
    end
    self.SetDefaultValue = function(this)
      this.defaultValue = L["LINE_TYPE_TABLE"][6].CATEGORY
      this.value = this.defaultValue
      UIDropDownMenu_SetSelectedValue(this, this.value)
      this.tooltip = this.value.." commands."
    end
    self.SetValue = function(this, value)
      this.value = value
      this.tooltip = value.." commands."
      UIDropDownMenu_SetSelectedValue(this, value)
      this:RefreshValue()
    end
    self.GetValue = function(this)
      return UIDropDownMenu_GetSelectedValue(this)
    end
    self.GetID = function(this)
      for i = 1, L["MACRO_EDITOR"]["NUM_MACRO_CATEGORIES"] do
        if this:GetValue() == L["LINE_TYPE_TABLE"][i].CATEGORY then
          return i
        end
      end
    end

    self:SetDefaultValue()
    self:UnregisterEvent(event)

    UIDropDownMenu_SetWidth(self, 120)
    UIDropDownMenu_Initialize(self, SimpleMacroEditorPopup_CategoryDropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(self, self.value)
  end
end

function SimpleMacroEditorPopup_CategoryDropDown_OnClick(self)
  SimpleMacroEditorPopup.CategoryDropDown:SetValue(self.value)

  local categoryID = SimpleMacroEditorPopup.CategoryDropDown:GetID()
  SimpleMacroEditorPopup_CommandDropDown_Initialize()
  SimpleMacroEditorPopup.CommandDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID][1].COMMANDS[1])
end

function SimpleMacroEditorPopup_CategoryDropDown_Initialize()
  local selectedValue = SimpleMacroEditorPopup.CategoryDropDown:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for _, entry in ipairs(L["LINE_TYPE_TABLE"]) do
    info.text = entry.CATEGORY
    info.func = SimpleMacroEditorPopup_CategoryDropDown_OnClick
    info.value = entry.CATEGORY
    info.checked = info.value == selectedValue and 1 or nil
    info.tooltipTitle = entry.CATEGORY
    info.tooltipText = entry.CATEGORY.." commands."
    UIDropDownMenu_AddButton(info)
  end
end

--[[
  Command DropDown
]]
function SimpleMacroEditorPopup_CommandDropDown_OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    self.RefreshValue = function(this)
      UIDropDownMenu_Initialize(this, SimpleMacroEditorPopup_CommandDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(this, this.value)
    end
    self.SetDefaultValue = function(this)
      this.defaultValue = L["LINE_TYPE_TABLE"][6][4].COMMANDS[1]
      this.value = this.defaultValue
      this.tooltip = L["LINE_TYPE_TABLE"][6][4].DESCRIPTION
      UIDropDownMenu_SetSelectedValue(this, this.value)
    end
    self.SetValue = function(this, value)
      local categoryID = SimpleMacroEditorPopup.CategoryDropDown:GetID()
      local commandID = SimpleMacroEditorPopup.CommandDropDown:GetID() or 1
      this.tooltip = L["LINE_TYPE_TABLE"][categoryID][commandID].DESCRIPTION
      this.value = value
      UIDropDownMenu_SetSelectedValue(this, value)
      this:RefreshValue()
    end
    self.GetValue = function(this)
      return UIDropDownMenu_GetSelectedValue(this)
    end
    self.GetID = function(_)
      local category = SimpleMacroEditorPopup.CategoryDropDown:GetID()
      for i = 1, L["MACRO_EDITOR"]["NUM_MACRO_COMMANDS"] do
        if L["LINE_TYPE_TABLE"][category][i] ~= nil then
          for _, cmd in pairs(L["LINE_TYPE_TABLE"][category][i].COMMANDS) do
            if SimpleMacroEditorPopup.CommandDropDown:GetValue() == cmd then
              return i
            end
          end
        end
      end
    end

    self:SetDefaultValue()
    self:UnregisterEvent(event)

    UIDropDownMenu_SetWidth(self, 120)
    UIDropDownMenu_Initialize(self, SimpleMacroEditorPopup_CommandDropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(self, self.value)
  end
end

function SimpleMacroEditorPopup_CommandDropDown_OnClick(self)
  self:GetParent()["dropdown"]:SetValue(self.value)
end

function SimpleMacroEditorPopup_CommandDropDown_Initialize()
  local categoryID = SimpleMacroEditorPopup.CategoryDropDown:GetID()
  local selectedValue = SimpleMacroEditorPopup.CommandDropDown:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for _, entry in ipairs(L["LINE_TYPE_TABLE"][categoryID]) do
    info.text = entry.COMMANDS[1]
    info.func = SimpleMacroEditorPopup_CommandDropDown_OnClick
    info.value = entry.COMMANDS[1]
    info.checked = info.value == selectedValue and 1 or nil
    info.tooltipTitle = entry.COMMANDS[1]
    info.tooltipText = entry.DESCRIPTION
    UIDropDownMenu_AddButton(info)
  end
end

--[[
  Conditional groups
]]
local function anchorAddButtonTo(button)
  local addButton = SimpleMacroEditorPopup.AddConditionalGroupButton
  addButton:SetPoint("TOP", button, "BOTTOM", 0, -6)
end

-- Resize frame for numButtons, if negative decrease the frame size
local function resizeFrameForButtons(frame, numButtons)
  -- resize parent
  local parentX, parentY = frame:GetSize()
  local _, buttonY = SimpleMacroEditorPopup.AddConditionalGroupButton:GetSize()
  frame:SetSize(parentX, parentY + numButtons * (buttonY + 4))
end

local function createConditionalGroupButton(index)
  local addButton = SimpleMacroEditorPopup.AddConditionalGroupButton
  local popupFrame = SimpleMacroEditorPopup
  local conditionalGroupButtonName = "SimpleMacroEditorPopup.ConditionalGroup"..index.."Button"
  local conditionalGroupButton

  if G[conditionalGroupButtonName] ~= nil then
    conditionalGroupButton = G[conditionalGroupButtonName]

    if not conditionalGroupButton:IsShown() then
      conditionalGroupButton:Show()
      anchorAddButtonTo(conditionalGroupButton)
      resizeFrameForButtons(popupFrame, 1)
      popupFrame:InsertConditionalGroupButton(conditionalGroupButton)
    end
  else
    conditionalGroupButton = CreateFrame("Button",
                                         conditionalGroupButtonName,
                                         popupFrame,
                                         "UIPanelButtonTemplate")
    conditionalGroupButton:SetText(string.format(G["SIMPLE_MACRO_STRING_CONDITIONAL_GROUP"], index))
    conditionalGroupButton:SetPoint(addButton:GetPoint())
    conditionalGroupButton:SetSize(addButton:GetSize())
    conditionalGroupButton:SetScript("OnClick", SimpleMacroEditorPopup_ConditionalGroupButton_OnClick)
    conditionalGroupButton:SetScript("OnMouseUp", nil)
    conditionalGroupButton:SetID(index)
    anchorAddButtonTo(conditionalGroupButton)
    resizeFrameForButtons(popupFrame, 1)
    popupFrame:InsertConditionalGroupButton(conditionalGroupButton)
  end

  return conditionalGroupButton
end

local function openConditionalGroup(button)
  SimpleMacroEditorPopup_ConditionalGroupButton_OnClick(button)
  UIPanelButton_OnMouseDown(button)
end

function SimpleMacroEditorPopup_AddConditionalGroupButton_OnClick(self)
  -- Add new group to parsed macro
  local parentFrame = self:GetParent()
  local line = parentFrame:GetSelectedLine()
  local argument = parentFrame:GetSelectedArgument()
  parentFrame:GetParsed():addConditionalGroup(line, argument)

  -- Create Button and open conditional popup
  local conditionalGroupButtons = SimpleMacroEditorPopup:GetConditionalGroupButtons()
  local conditionalGroupCount = conditionalGroupButtons ~= nil and #conditionalGroupButtons or 0
  local newConditionalGroupButton = createConditionalGroupButton(conditionalGroupCount + 1)
  openConditionalGroup(newConditionalGroupButton)

  if #SimpleMacroEditorPopup:GetConditionalGroupButtons() >= L["MACRO_EDITOR"]["MAX_CONDITIONAL_GROUPS"] then
    self:Disable()
  end
end

function SimpleMacroEditorPopup_ConditionalGroupButton_OnClick(self)
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(self)
  SimpleMacroEditorConditionalPopup:SetID(self:GetID())
  SimpleMacroEditorConditionalPopup:Update()
  ShowUIPanel(SimpleMacroEditorConditionalPopup)
  self:SetScript("OnMouseUp", nil)
end

function SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(ignoreButton)
  for _, button in ipairs(SimpleMacroEditorPopup:GetConditionalGroupButtons()) do
    if ignoreButton == nil or button ~= ignoreButton then
      UIPanelButton_OnMouseUp(button)
    end
  end
end

function SimpleMacroEditorPopup_ConditionalGroupButton_Unclick(id)
  UIPanelButton_OnMouseUp(SimpleMacroEditorPopup:GetConditionalGroupButtons()[id])
end

local function getCommandIds(command)
  local checkString = string.match(command, "[/#]?(.*)")

  for categoryID, categoryData in ipairs(L["LINE_TYPE_TABLE"]) do
    for commandID, commandData in ipairs(categoryData) do
      for nameID, nameData in ipairs(commandData["COMMANDS"]) do
        if nameData == checkString then
          return categoryID, commandID, nameID
        end
      end
    end
  end
end

local function hideConditionalGroupButtons(startingIndex)
  local conditionalGroupButtonName = "SimpleMacroEditorPopup.ConditionalGroupINDEXButton"
  local firstHidden = nil

  for i = L["MACRO_EDITOR"]["MAX_CONDITIONAL_GROUPS"], startingIndex + 1, -1 do
    local buttonFrame = G[string.gsub(conditionalGroupButtonName, "INDEX", i)]
    if buttonFrame ~= nil and buttonFrame:IsShown() then
      buttonFrame:Hide()
      SimpleMacroEditorPopup:RemoveLastConditionalGroupButton()
      if firstHidden == nil then
        firstHidden = i
      end
    end
  end

  if firstHidden ~= nil then
    local lastEnabledButton = G[string.gsub(conditionalGroupButtonName, "INDEX", startingIndex)]
    anchorAddButtonTo(lastEnabledButton)
    resizeFrameForButtons(SimpleMacroEditorPopup, startingIndex - firstHidden)
  end
end

function SimpleMacroEditorPopup_Update()
  local popupFrame = SimpleMacroEditorPopup
  local parsedMacro = popupFrame:GetParsed()
  local currentLine = popupFrame:GetSelectedLine()
  local currentArgument = popupFrame:GetSelectedArgument()

  -- dropdowns
  local categoryID, commandID, nameID = getCommandIds(parsedMacro:getCommand(currentLine))
  popupFrame.CategoryDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID].CATEGORY)
  popupFrame.CommandDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID][commandID].COMMANDS[nameID])

  -- TODO Fix for empty argument. This currently hides the edit box and conditional group buttons.
  local conditionalGroups
  if currentArgument ~= nil then
    -- editbox
    local lineArguments = parsedMacro:getArguments(currentLine)
    popupFrame.ArgumentEditBox:SetText(lineArguments[currentArgument].arg)

    -- conditionals
    conditionalGroups = parsedMacro:getConditionalGroups(currentLine, currentArgument)
    for i, _ in ipairs(conditionalGroups) do
      createConditionalGroupButton(i)
    end
  else
    popupFrame.ArgumentEditBox:SetText("")
    SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(nil)
  end

  hideConditionalGroupButtons(conditionalGroups and #conditionalGroups or 0)

  if #popupFrame:GetConditionalGroupButtons() < L["MACRO_EDITOR"]["MAX_CONDITIONAL_GROUPS"] then
    popupFrame.AddConditionalGroupButton:Enable()
  end
end

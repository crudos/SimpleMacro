local _, ns = ...
local L = ns.L["MACRO_EDITOR"]
local C = ns.C["MACRO_EDITOR"]
local G = _G

SimpleMacroEditorPopupMixin = {}

function SimpleMacroEditorPopupMixin:OnLoad()
  self:SetTitle(GetGlobalString("MACRO_EDITOR_TITLE"))
end

function SimpleMacroEditorPopupMixin:OnShow()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
end

function SimpleMacroEditorPopupMixin:OnHide()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
  -- close conditional popup
  SimpleMacroCreateFrame:UnclickLastTextButton()
  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(nil)
  HideUIPanel(SimpleMacroEditorConditionalPopup)
end

---@return SMacro current SMacro or nil if there is none
function SimpleMacroEditorPopupMixin:GetSMacro()
  return SimpleMacroCreateFrame:GetSMacro()
end

function SimpleMacroEditorPopupMixin:SetSelected(lineId, argumentId)
  self:SetSelectedLine(lineId)
  self:SetSelectedArgument(argumentId)
end

function SimpleMacroEditorPopupMixin:GetSelectedLine()
  return self.selectedLine
end

function SimpleMacroEditorPopupMixin:SetSelectedLine(id)
  self.selectedLine = id
end

function SimpleMacroEditorPopupMixin:GetSelectedArgument()
  return self.selectedArgument
end

function SimpleMacroEditorPopupMixin:SetSelectedArgument(id)
  self.selectedArgument = id
end

function SimpleMacroEditorPopupMixin:GetArgumentEditBoxes()
  if self.argumentEditBoxes == nil then
    self.argumentEditBoxes = {}
  end
  return self.argumentEditBoxes
end

function SimpleMacroEditorPopupMixin:InsertArgumentEditBox(editBox)
  if self.argumentEditBoxes == nil then
    self.argumentEditBoxes = {}
  end
  tinsert(self.argumentEditBoxes, editBox)
end

function SimpleMacroEditorPopupMixin:RemoveLastArgumentEditBox()
  return tremove(self.argumentEditBoxes)
end

function SimpleMacroEditorPopupMixin:GetConditionalGroupButtons()
  if self.conditionalGroupButtons == nil then
    self.conditionalGroupButtons = {}
  end
  return self.conditionalGroupButtons
end

function SimpleMacroEditorPopupMixin:InsertConditionalGroupButton(groupButton)
  if self.conditionalGroupButtons == nil then
    self.conditionalGroupButtons = {}
  end
  tinsert(self.conditionalGroupButtons, groupButton)
end

function SimpleMacroEditorPopupMixin:RemoveLastConditionalGroupButton()
  return tremove(self.conditionalGroupButtons)
end

local function generateCommandString(category, command)
  return (category == C["HASH_CATEGORY"] and '#' or '/')..command
end

function SimpleMacroEditorPopupMixin:Save()
  local sMacro = self:GetSMacro() ---@type SMacro
  local selectedLine = self:GetSelectedLine()
  sMacro:setCommand(selectedLine, generateCommandString(self.CategoryDropDown:GetValue(), self.CommandDropDown:GetValue()))
  sMacro:setArgument(selectedLine, self:GetSelectedArgument(), self.ArgumentEditBox:GetText())
  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
  self:GetParent():Update()
end

function SimpleMacroEditorPopupMixin:Delete()
  local sMacro = self:GetSMacro() ---@type SMacro
  sMacro:removeArgument(self:GetSelectedLine(), self:GetSelectedArgument())
  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
  self:GetParent():Update()
end

local function isArgumentPopup()
  if SimpleMacroEditorPopup:GetSelectedArgument() ~= nil then
    return true
  end
  return false
end

function SimpleMacroEditorPopupMixin:SetupDropDowns()
  local sMacro = self:GetSMacro() ---@type SMacro
  local currentLine = self:GetSelectedLine()

  if isArgumentPopup() then
    self.CategoryDropDown:Hide()
    self.CommandDropDown:Hide()
  else
    local categoryID, commandID, nameID = getCommandIds(sMacro:getCommand(currentLine))
    self.CategoryDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID].CATEGORY)
    self.CommandDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID][commandID].COMMANDS[nameID])
    self.CategoryDropDown:Show()
    self.CommandDropDown:Show()
  end
end

local function getArgumentEditBox(name)
  local argumentEditBox
  if G[name] ~= nil then
    argumentEditBox = _G[name]
  else
    argumentEditBox = CreateFrame("EditBox", name, SimpleMacroEditorPopup, "SimpleMacroEditorPopupEditBoxTemplate")
    argumentEditBox:SetSize(160, 24)
  end
  return argumentEditBox
end

local function addArgumentEditBoxSection(argumentEditBox)
  local popupFrame = SimpleMacroEditorPopup

  argumentEditBox:Show()
  popupFrame:InsertArgumentEditBox(argumentEditBox)

  local addButton = popupFrame.AddArgumentButton
  argumentEditBox:SetPoint(addButton:GetPoint())
  addButton:SetPoint("TOP", argumentEditBox, "BOTTOM", 0, -10)
end

  -- TODO
  --[[
    If we're selecting the beginning of the line we should show every argument (no conditional group buttons)
    Each argument should have a button to "go to the argument"
  ]]--
function SimpleMacroEditorPopupMixin:SetupArgumentEditBoxes()
  local addButton = self.AddArgumentButton
  addButton:SetPoint("TOP", 0, -80)

  for i = 1, C["MAX_ARGUMENTS"] do
    local argumentEditBox = getArgumentEditBox("ArgumentEditBox"..i)
    local arguments = self:GetSMacro():getArguments(self:GetSelectedLine(), self:GetSelectedArgument())

    if i <= #arguments then
      addArgumentEditBoxSection(argumentEditBox)
      argumentEditBox:SetText(arguments[i].arg)

      local _, editBoxY = argumentEditBox:GetSize()
      self:SetSize(C["BASE_WIDTH"], C["BASE_HEIGHT"] + i*(editBoxY + 10))
    else
      argumentEditBox:Hide()
      if i == 1 then
        self:SetSize(C["BASE_WIDTH"], C["BASE_HEIGHT"])
      end
    end
  end
end

  --TODO
  --[[
    Setup
  ]]--
function SimpleMacroEditorPopupMixin:SetupConditionalGroupButtons()
  local conditionalGroups
  if isArgumentPopup() then
    conditionalGroups = self:GetSMacro():getConditionalGroups(self:GetSelectedLine(), self:GetSelectedArgument())
    for i, _ in ipairs(conditionalGroups) do
      createConditionalGroupButton(i)
    end
  else
    self.AddConditionalGroupButton:Hide()
    SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(nil)
  end

  hideConditionalGroupButtons(conditionalGroups and #conditionalGroups or 0)

  if #self:GetConditionalGroupButtons() < C["MAX_CONDITIONAL_GROUPS"] then
    self.AddConditionalGroupButton:Enable()
  end
end

function SimpleMacroEditorPopupMixin:Update()
  self:SetupDropDowns()
  self:SetupArgumentEditBoxes()
  self:SetupConditionalGroupButtons()
end

-- Buttons
function SimpleMacroEditorPopup_OkayButton_OnClick(self)
  local parent = self:GetParent()
  parent:Save()
  HideUIPanel(parent)
end

function SimpleMacroEditorPopup_DeleteButton_OnClick(self)
  local parent = self:GetParent()
  parent:Delete()
  HideUIPanel(parent)
end






-- old


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
      this.tooltip = this.value .. " commands."
    end
    self.SetValue = function(this, value)
      this.value = value
      this.tooltip = value .. " commands."

      UIDropDownMenu_SetSelectedValue(this, value)
      this:RefreshValue()
    end
    self.GetValue = function(this)
      return UIDropDownMenu_GetSelectedValue(this)
    end
    self.GetID = function(this)
      for i = 1, C["NUM_MACRO_CATEGORIES"] do
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
    info.tooltipText = entry.CATEGORY .. " commands."
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
      for i = 1, C["NUM_MACRO_COMMANDS"] do
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
  Arguments
]]

function SimpleMacroEditorPopup_AddArgumentButton_OnClick(self)
  SimpleMacroEditorPopup:GetSMacro():addArgument(SimpleMacroEditorPopup:GetSelectedLine(), "")
  if #SimpleMacroEditorPopup:GetArgumentEditBoxes() >= C["MAX_CONDITIONAL_GROUPS"] then
    self:Disable()
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

function createConditionalGroupButton(index)
  local addButton = SimpleMacroEditorPopup.AddConditionalGroupButton
  local popupFrame = SimpleMacroEditorPopup
  local conditionalGroupButtonName = "SimpleMacroEditorPopup.ConditionalGroup" .. index .. "Button"
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

  if #SimpleMacroEditorPopup:GetConditionalGroupButtons() >= C["MAX_CONDITIONAL_GROUPS"] then
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

function getCommandIds(command)
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

function hideConditionalGroupButtons(startingIndex)
  local conditionalGroupButtonName = "SimpleMacroEditorPopup.ConditionalGroupINDEXButton"
  local firstHidden = nil

  for i = C["MAX_CONDITIONAL_GROUPS"], startingIndex + 1, -1 do
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
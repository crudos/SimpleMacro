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

---@return SMacro current SMacro or nil if there is none
function SimpleMacroEditorPopupMixin:GetSMacro()
  return SimpleMacroCreateFrame:GetSMacro()
end

function SimpleMacroEditorPopupMixin:GetSelected()
  return self:GetSelectedLine(), self:GetSelectedArgument()
end

function SimpleMacroEditorPopupMixin:SetSelected(lineId, argumentId)
  self:SetSelectedLine(lineId)
  self:SetSelectedArgument(argumentId)
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

function SimpleMacroEditorPopupMixin:ResetArgumentEditBoxes()
  self.argumentEditBoxes = nil
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

function SimpleMacroEditorPopupMixin:ResetConditionalGroupButtons()
  self.conditionalGroupButtons = nil
end

local function isArgumentPopup()
  if SimpleMacroEditorPopup:GetSelectedArgument() ~= nil then
    return true
  end
  return false
end

function SimpleMacroEditorPopupMixin:Resize(frame, index, spacing)
  local baseHeight = isArgumentPopup() and C["BASE_ARGUMENT_POPUP_HEIGHT"] or C["BASE_LINE_POPUP_HEIGHT"]
  if frame == nil then
    self:SetSize(C["BASE_WIDTH"], baseHeight)
  else
    local _, frameY = frame:GetSize()
    self:SetSize(C["BASE_WIDTH"], baseHeight + index * (frameY + spacing))
  end
end

--[[
  SETUP DROP DOWNS
]]--
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

--[[
  SETUP ARGUMENT EDIT BOXES
]]--
local function getArgumentEditBox(name)
  local argumentEditBox

  if G[name] ~= nil then
    argumentEditBox = _G[name]
  else
    argumentEditBox = CreateFrame("EditBox", name, SimpleMacroEditorPopup, "SimpleMacroEditorPopupEditBoxTemplate")
    argumentEditBox:SetSize(160, 24)
    local editBoxButton = CreateFrame("Button", name.."Button", argumentEditBox, "UIPanelButtonTemplate")
    editBoxButton:SetPoint("LEFT", argumentEditBox, "RIGHT", 5, 1)
    editBoxButton:SetSize(24, 22)
    editBoxButton:SetText(">")
    editBoxButton:SetScript("OnClick", SimpleMacroEditorPopup_OpenArgumentButton_OnClick)
  end

  return argumentEditBox
end

local function addArgumentEditBoxSection(argumentEditBox)
  local popupFrame = SimpleMacroEditorPopup
  local addButton = popupFrame.AddArgumentButton

  popupFrame:InsertArgumentEditBox(argumentEditBox)
  argumentEditBox:Show()
  argumentEditBox:SetPoint(addButton:GetPoint())
  addButton:SetPoint("TOP", argumentEditBox, "BOTTOM", 0, -10)
end

function SimpleMacroEditorPopupMixin:SetupArgumentEditBoxes()
  self:ResetArgumentEditBoxes()
  local addButton = self.AddArgumentButton
  addButton:SetPoint("TOP", 0, -80)

  local arguments = self:GetSMacro():getArguments(self:GetSelectedLine())
  for i = 1, C["MAX_ARGUMENTS"] do
    local argumentEditBox = getArgumentEditBox("ArgumentEditBox"..i)
    if isArgumentPopup() then
      argumentEditBox:Hide()
    else
      if arguments and i <= #arguments then
        addArgumentEditBoxSection(argumentEditBox)
        argumentEditBox:SetText(arguments[i].arg)
        self:Resize(argumentEditBox, i, 10)
      else
        if i == 1 then
          self:Resize()
        end
        argumentEditBox:Hide()
      end
    end
  end

  if isArgumentPopup() then
    addButton:Hide()
  else
    if #arguments >= C["MAX_ARGUMENTS"] then
      addButton:Disable()
    else
      addButton:Enable()
    end
    addButton:Show()
  end
end

--[[
  SETUP CONDITIONAL GROUP BUTTONS
]]--
local function getConditionalGroupButton(index)
  local popup = SimpleMacroEditorPopup
  local addButton = popup.AddConditionalGroupButton
  local conditionalGroupButtonName = "SimpleMacroEditorPopup.ConditionalGroup" .. index .. "Button"
  local conditionalGroupButton

  if G[conditionalGroupButtonName] ~= nil then
    conditionalGroupButton = G[conditionalGroupButtonName]
  else
    conditionalGroupButton = CreateFrame("Button", conditionalGroupButtonName, popup,"UIPanelButtonTemplate")
    conditionalGroupButton:SetText(string.format(G["SIMPLE_MACRO_STRING_CONDITIONAL_GROUP"], index))
    conditionalGroupButton:SetPoint(addButton:GetPoint())
    conditionalGroupButton:SetSize(addButton:GetSize())
    conditionalGroupButton:SetScript("OnClick", SimpleMacroEditorPopup_ConditionalGroupButton_OnClick)
    conditionalGroupButton:SetScript("OnMouseUp", nil)
    conditionalGroupButton:SetID(index)
  end

  return conditionalGroupButton
end

function SimpleMacroEditorPopupMixin:SetupConditionalGroupButtons()
  local sMacro = self:GetSMacro()
  local addButton = self.AddConditionalGroupButton

  if isArgumentPopup() then
    self.ArgumentBackButton:Show()
    self.ArgumentText:Show()
    self.ArgumentText:SetText(sMacro:getArgument(self:GetSelected()))

    addButton:Show()
    addButton:SetPoint("TOP", self.ArgumentText, "BOTTOM", 0, -10)
    if #self:GetConditionalGroupButtons() < C["MAX_CONDITIONAL_GROUPS"] then
      addButton:Enable()
    else
      addButton:Disable()
    end

    self:ResetConditionalGroupButtons()
  else
    self.ArgumentBackButton:Hide()
    self.ArgumentText:Hide()
    addButton:Hide()
  end

  local conditionalGroups = sMacro:getConditionalGroups(self:GetSelected())
  for i = 1, C["MAX_CONDITIONAL_GROUPS"] do
    local conditionalGroupButton = getConditionalGroupButton(i)
    if isArgumentPopup() then
      if conditionalGroups and i <= #conditionalGroups then
        conditionalGroupButton:SetPoint(addButton:GetPoint())
        addButton:SetPoint("TOP", conditionalGroupButton, "BOTTOM", 0, -6)
        self:InsertConditionalGroupButton(conditionalGroupButton)
        self:Resize(conditionalGroupButton, i, 6)
        conditionalGroupButton:Show()
      else
        if i == 1 then
          self:Resize()
        end
        conditionalGroupButton:Hide()
      end
    else
      conditionalGroupButton:Hide()
    end
  end

  SimpleMacroEditorPopup_ConditionalGroupButtons_Reset(nil)
end

function SimpleMacroEditorPopupMixin:Update()
  self:SetupDropDowns()
  self:SetupArgumentEditBoxes()
  self:SetupConditionalGroupButtons()
end

function SimpleMacroEditorPopupMixin:Save()
  if isArgumentPopup() then
    self:ArgumentPopupSave(sMacro)
  else
    self:LinePopupSave(sMacro)
  end
  self:GetParent():Update()
end

function SimpleMacroEditorPopupMixin:ArgumentPopupSave()
  -- do nothing
end

local function generateCommandString(category, command)
  return (category == C["HASH_CATEGORY"] and '#' or '/')..command
end

function SimpleMacroEditorPopupMixin:LinePopupSave()
  local sMacro = self:GetSMacro() ---@type SMacro
  local selectedLine = self:GetSelectedLine()
  sMacro:setCommand(selectedLine, generateCommandString(self.CategoryDropDown:GetValue(), self.CommandDropDown:GetValue()))
  for i = 1, C["MAX_ARGUMENTS"] do
    sMacro:setArgument(selectedLine, i, getArgumentEditBox("ArgumentEditBox"..i):GetText())
  end
  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
end

function SimpleMacroEditorPopupMixin:Delete()
  if isArgumentPopup() then
    self:ArgumentPopupDelete(sMacro)
  else
    self:LinePopupDelete(sMacro)
  end
  self:GetParent():Update()
end

function SimpleMacroEditorPopupMixin:ArgumentPopupDelete()
  local sMacro = self:GetSMacro() ---@type SMacro
  sMacro:removeArgument(self:GetSelected())
  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
end

function SimpleMacroEditorPopupMixin:LinePopupDelete()
  local sMacro = self:GetSMacro() ---@type SMacro
  sMacro:removeLine(self:GetSelectedLine())
  EditMacro(sMacro:getID(), nil, nil, sMacro:compose())
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

function SimpleMacroEditorPopup_OpenArgumentButton_OnClick(self)
  local argumentId = string.match(self:GetName(), "%a+(%d)%a*")
  local popup = SimpleMacroEditorPopup
  popup:SetSelectedArgument(tonumber(argumentId))
  popup:Update()
  G["SimpleMacroLine"..popup:GetSelectedLine().."Argument"..popup:GetSelectedArgument()]:Click()
end

function SimpleMacroEditorPopup_AddArgumentButton_OnClick()
  local popup = SimpleMacroEditorPopup
  popup:GetSMacro():addArgument(popup:GetSelectedLine(), "")
  popup:Update()
end

function SimpleMacroEditorPopup_ArgumentBackButton_OnClick()
  local popup = SimpleMacroEditorPopup
  popup:SetSelectedArgument(nil)
  popup:Update()
  G["SimpleMacroLine"..popup:GetSelectedLine()]:Click()
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
    for id, command in ipairs(entry["COMMANDS"]) do
      info.text = command
      info.func = SimpleMacroEditorPopup_CommandDropDown_OnClick
      info.value = command
      info.checked = info.value == selectedValue and 1 or nil
      info.tooltipTitle = command
      info.tooltipText = entry["DESCRIPTION"]
      info.arg1 = id
      UIDropDownMenu_AddButton(info)
    end
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
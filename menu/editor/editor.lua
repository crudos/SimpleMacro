local _, L = ...
local G = _G

--[[
  SimpleMacroEditorPopup
]]
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
    this.selectedMacro.parsed:set(id + SimpleMacroMenu.macroStart)
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
    return this.conditionalGroupButtons
  end
  self.InsertConditionalGroupButton = function(this, groupButton)
    if this.conditionalGroupButtons == nil then
      this.conditionalGroupButtons = {}
    end
    tinsert(this.conditionalGroupButtons, groupButton)
  end
end

function SimpleMacroEditorPopup_OnShow(self)
  self:SetSelectedMacro(126)
  self:SetSelectedLine(2) -- temp
  self:SetSelectedArgument(1) -- temp
  SimpleMacroEditorPopup_Update(self)
end

function SimpleMacroEditorPopup_OnHide(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
end

function SimpleMacroEditorPopup_CancelButton_OnClick(self)
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorPopup_OkayButton_OnClick(self)
end

function SimpleMacroEditorPopup_DeleteButton_OnClick(self)
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
  Conditionals
]]
local function createConditionalGroupButton(addButton, index)
  local parentFrame = addButton:GetParent()
  local conditionalGroupButtonName = "SimpleMacroEditorPopup.ConditionalGroup" .. index .. "Button"
  local conditionalGroupButton

  if G[conditionalGroupButtonName] ~= nil then
    conditionalGroupButton = G[conditionalGroupButtonName]
    conditionalGroupButton:Show()
  else
    conditionalGroupButton = CreateFrame("Button",
                                         conditionalGroupButtonName,
                                         parentFrame,
                                         "UIPanelButtonTemplate")
    conditionalGroupButton:SetText(string.format(G["SIMPLE_MACRO_STRING_CONDITIONAL_GROUP"], index))
    conditionalGroupButton:SetPoint(addButton:GetPoint())
    conditionalGroupButton:SetSize(addButton:GetSize())
    conditionalGroupButton:SetScript("OnClick", SimpleMacroEditorPopup_ConditionalGroupButton_OnClick)
    conditionalGroupButton:SetScript("OnMouseUp", nil)
    conditionalGroupButton:SetID(index)
    addButton:SetPoint("TOP", conditionalGroupButton, "BOTTOM", 0, -6)

    -- resize parent
    local parentX, parentY = parentFrame:GetSize()
    local _, buttonY = addButton:GetSize()
    parentFrame:SetSize(parentX, parentY + buttonY + 4)

    parentFrame:InsertConditionalGroupButton(conditionalGroupButton)
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
  local newConditionalGroupButton = createConditionalGroupButton(self, conditionalGroupCount + 1)
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

function SimpleMacroEditorPopup_Update(self)
  local parsedMacro = self:GetParsed()
  local currentLine = self:GetSelectedLine()
  local currentArgument = self:GetSelectedArgument()

  -- dropdowns
  local categoryID, commandID, nameID = getCommandIds(parsedMacro:getCommand(currentLine))
  SimpleMacroEditorPopup.CategoryDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID].CATEGORY)
  SimpleMacroEditorPopup.CommandDropDown:SetValue(L["LINE_TYPE_TABLE"][categoryID][commandID].COMMANDS[nameID])

  -- editbox
  local lineArguments = parsedMacro:getArguments(currentLine)
  SimpleMacroEditorPopup.ArgumentEditBox:SetText(lineArguments[currentArgument].arg)

  -- conditionals
  local conditionalGroups = parsedMacro:getConditionalGroups(currentLine, currentArgument)
  for i, _ in ipairs(conditionalGroups) do
    createConditionalGroupButton(SimpleMacroEditorPopup.AddConditionalGroupButton, i)
  end

end
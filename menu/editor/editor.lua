local _, L = ...
local G = _G

--[[
  SimpleMacroEditorPopup
]]
function SimpleMacroMenuPopup_OnLoad(self)

end

function SimpleMacroMenuPopup_OnShow(self)

end

function SimpleMacroMenuPopup_OnHide(self)

end

function SimpleMacroEditorPopup_CancelButton_OnClick(self)
  HideUIPanel(self:GetParent())
end

function SimpleMacroEditorPopup_OkayButton_OnClick(self)
end

function SimpleMacroEditorPopup_DeleteButton_OnClick(self)
end
-- SimpleMacroEditorPopup_Update()

--[[
  Category DropDown
]]
function SimpleMacroEditorPopup_CategoryDropDown_OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    self.SetDefaultValue = function(this)
      self.defaultValue = L["LINE_TYPE_TABLE"][6].CATEGORY
      this.value = this.defaultValue
      UIDropDownMenu_SetSelectedValue(this, this.value)
      this.tooltip = this.value .. " commands."
    end
    self.SetValue = function(this, value)
      this.value = value
      UIDropDownMenu_SetSelectedValue(this, value)
      this.tooltip = value .. " commands."
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
    self.RefreshValue = function(this)
      UIDropDownMenu_Initialize(this, SimpleMacroEditorPopup_CategoryDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(this, this.value)
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
    self.SetDefaultValue = function(this)
      this.defaultValue = L["LINE_TYPE_TABLE"][6][4].COMMANDS[1]
      this.value = this.defaultValue
      UIDropDownMenu_SetSelectedValue(this, this.value)
      this.tooltip = L["LINE_TYPE_TABLE"][6][4].DESCRIPTION
    end
    self.SetValue = function(this, value)
      local categoryID, commandID
      this.value = value
      UIDropDownMenu_SetSelectedValue(this, value)
      categoryID = SimpleMacroEditorPopup.CategoryDropDown:GetID()
      commandID = SimpleMacroEditorPopup.CommandDropDown:GetID() or 1
      this.tooltip = L["LINE_TYPE_TABLE"][categoryID][commandID].DESCRIPTION
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
    self.RefreshValue = function(this)
      UIDropDownMenu_Initialize(this, SimpleMacroEditorPopup_CommandDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(this, this.value)
    end

    self:SetDefaultValue()
    self:UnregisterEvent(event)

    UIDropDownMenu_SetWidth(self, 120)
    UIDropDownMenu_Initialize(self, SimpleMacroEditorPopup_CommandDropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(self, self.value)
  end
end

function SimpleMacroEditorPopup_CommandDropDown_OnClick(self)
  SimpleMacroEditorPopup.CommandDropDown:SetValue(self.value)
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
  local conditionalGroupButton  = CreateFrame("Button",
                                              "SimpleMacroEditorPopup.ConditionalGroup" .. index .. "Button",
                                              addButton:GetParent(),
                                              "UIPanelButtonTemplate")
  conditionalGroupButton:SetText(string.format(G["SIMPLE_MACRO_STRING_CONDITIONAL_GROUP"], index))
  conditionalGroupButton:SetPoint(addButton:GetPoint())
  conditionalGroupButton:SetSize(addButton:GetSize())
  conditionalGroupButton:SetScript("OnClick", SimpleMacroEditorPopup_ConditionalGroupButton_OnClick)
  conditionalGroupButton:SetScript("OnMouseUp", nil)
  conditionalGroupButton:SetID(index)
  addButton:SetPoint("TOP", conditionalGroupButton, "BOTTOM", 0, -6)

  return conditionalGroupButton
end

local function openConditionalGroup(button)
  SimpleMacroEditorPopup_ConditionalGroupButton_OnClick(button)
  UIPanelButton_OnMouseDown(button)
end

function SimpleMacroEditorPopup_AddConditionalGroupButton_OnClick(self)
  local conditionalGroups = SimpleMacroEditorPopup.conditionalGroupButtons

  if conditionalGroups == nil then
    SimpleMacroEditorPopup.conditionalGroupButtons = {}
    conditionalGroups = SimpleMacroEditorPopup.conditionalGroupButtons
  end

  local newConditionalGroupButton = createConditionalGroupButton(self, #conditionalGroups + 1)
  table.insert(SimpleMacroEditorPopup.conditionalGroupButtons, newConditionalGroupButton)
  openConditionalGroup(newConditionalGroupButton)
end

function SimpleMacroEditorPopup_ConditionalGroupButton_OnClick(self)
  SimpleMacroEditorConditionalPopup:SetID(self:GetID())
  ShowUIPanel(SimpleMacroEditorConditionalPopup)
  self:SetScript("OnMouseUp", nil)
end

function SimpleMacroEditorPopup_ConditionalGroupButtons_Reset()
  for _, button in ipairs(SimpleMacroEditorPopup.conditionalGroupButtons) do
    UIPanelButton_OnMouseUp(button)
  end
end
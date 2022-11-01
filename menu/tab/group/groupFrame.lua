local _, L = ...
local C = L["Group"]
local G = _G

local function isempty(s)
  return s == nil or s == ''
end

local function setAccountMacros()
  SimpleMacroFrame.macroStart = 0
  SimpleMacroFrame.macroMax = MAX_ACCOUNT_MACROS

  local numAccountMacros, _ = GetNumMacros()

  if numAccountMacros > 0 then
    SM_UserButton_SelectMacro(1)
  else
    SM_UserButton_SelectMacro(nil)
  end
end

local function setCharacterMacros()
  SimpleMacroFrame.macroStart = MAX_ACCOUNT_MACROS
  SimpleMacroFrame.macroMax = MAX_CHARACTER_MACROS

  local _, numCharacterMacros = GetNumMacros()

  if numCharacterMacros > 0 then
    SM_UserButton_SelectMacro(1)
  else
    SM_UserButton_SelectMacro(nil)
  end
end

local function setGroupMacros()
  local groupTable = SimpleMacro.dbc.GroupTable
  local group = groupTable[groupTable.selected]

  if group and #group > 0 then
    -- possibly save the last selected macro in the group in SimpleMacroFrame.groupTable[#].selected
    SM_GroupButton_SelectMacro(1)
  else
    SM_GroupButton_SelectMacro(nil)
  end
end

-- GROUP TAB

local function loadGroupTabs()
  local parentFrame = SimpleMacroFrameGroupTabGroupScrollFrame
  local inheritFrame = "PanelTabButtonTemplate"

  for i = 1, C["MAX_TABS"] do
    CreateFrame("CheckButton", "$parentTab"..i, parentFrame, inheritFrame, i)
  end
end

function SM_GroupTab_OnLoad(panel)
  PanelTemplates_SetNumTabs(panel, 2)
  PanelTemplates_SetTab(panel, 1)

  loadGroupTabs()
end

function SM_GroupTab_OnShow(_)
  if PanelTemplates_GetSelectedTab(SimpleMacroFrameGroupTab) == 1 then
    setAccountMacros()
  else
    setCharacterMacros()
  end

  setGroupMacros()
  SM_SetGroupTabs()

  SM_UserButton_Update()
  SM_GroupButton_Update()

  SM_GroupTargetText:ClearFocus()
end

function SM_SetGroupTabs()
  local parentFrame = SimpleMacroFrameGroupTabGroupScrollFrame
  local groupTabName = "SimpleMacroFrameGroupTabGroupScrollFrameTab"
  local groupTable = SimpleMacro.dbc.GroupTable
  local tab

  for i = 1, C["MAX_TABS"] do
    tab = G[groupTabName..i]

    -- + 1 allows for the "+" button to be added at the end
    if i <= #groupTable + 1 then
      if nil ~= tab then
        if i == #groupTable + 1 then
          tab:SetText("+")
          tab:SetScript("OnClick", SM_GroupTab_AddGroup_OnClick)
        else
          tab:SetText(L["GROUP_TAB"]["TAB_TEXT"].." "..i)
          tab:SetScript("OnClick", SM_GroupTab_Group_OnClick)
        end

        if i == 1 then
          tab:SetPoint("BOTTOMLEFT", parentFrame, "TOPLEFT", 2, 2)
        else
          tab:SetPoint("LEFT", G[groupTabName..(i - 1)], "RIGHT", -16, 0)
        end

        tab:Hide()
        tab:Show()
      end
    else
      -- hides stray tabs
      tab:Hide()
    end
  end

  PanelTemplates_SetNumTabs(parentFrame, C["MAX_TABS"])

  if groupTable.selected then
    PanelTemplates_SetTab(parentFrame, groupTable.selected)
  elseif #groupTable > 0 then
    PanelTemplates_SetTab(parentFrame, 1)
  end
end

function SM_GroupTab_AddGroup_OnClick(self)
  local groupTable = SimpleMacro.dbc.GroupTable

  if self:GetID() <= C["MAX_TABS"] then
    groupTable[self:GetID()] = {}
    groupTable.selected = self:GetID()

    SM_GroupButton_SelectMacro(nil)
    SM_SetGroupTabs()
  end

  SM_GroupButton_Update()
  SimpleMacroSettings_Load()

  PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON)
end

function SM_GroupTab_Group_OnClick(self)
  local groupTable = SimpleMacro.dbc.GroupTable

  PanelTemplates_SetTab(SimpleMacroFrameGroupTabGroupScrollFrame, self:GetID())
  groupTable.selected = self:GetID()

  if #groupTable[groupTable.selected] > 0 then
    SM_GroupButton_SelectMacro(1)
  else
    SM_GroupButton_SelectMacro(nil)
  end

  SM_GroupButton_Update()

  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end

function SimpleMacroFrameGroupTab_OnClick(self)
  PanelTemplates_SetTab(SimpleMacroFrame, self:GetID())
  SMCreateFrame:Hide()
  SimpleMacroFrameGroupTab:Show()
end

-- create buttons containers
function SM_UserButtons_OnLoad(self)
  local button
  local macrosPerRow = C["MACROS_PER_ROW"]

  for i = 1, MAX_ACCOUNT_MACROS do
    button = CreateFrame("CheckButton", "SMUserButton"..i, self, "SimpleMacroButtonTemplate")
    button:SetID(i)
    if i == 1 then
      button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
    elseif mod(i, macrosPerRow) == 1 then
      button:SetPoint("TOP", "SMUserButton"..(i - macrosPerRow), "BOTTOM", 0, -10);
    else
      button:SetPoint("LEFT", "SMUserButton"..(i - 1), "RIGHT", 13, 0);
    end
  end
end

function SM_GroupTabAccountMacroTab_OnClick(self)
  PanelTemplates_SetTab(SimpleMacroFrameGroupTab, self:GetID())
  setAccountMacros()
  SM_UserButton_Update()
end

function SM_GroupTabCharacterMacroTab_OnClick(self)
  PanelTemplates_SetTab(SimpleMacroFrameGroupTab, self:GetID())
  setCharacterMacros()
  SM_UserButton_Update()
end

function GroupButtons_OnLoad(self)
  local button
  local macrosPerRow = C["MACROS_PER_ROW"]

  for i = 1, MAX_ACCOUNT_MACROS do
    button = CreateFrame("CheckButton", "SMGroupButton"..i, self, "SimpleMacroButtonTemplate")
    button:SetID(i)
    if i == 1 then
      button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
    elseif mod(i, macrosPerRow) == 1 then
      button:SetPoint("TOP", "SMGroupButton"..(i - macrosPerRow), "BOTTOM", 0, -10)
    else
      button:SetPoint("LEFT", "SMGroupButton"..(i - 1), "RIGHT", 13, 0)
    end
  end
end

function SM_UserButton_Update()
  local numAccountMacros, numCharacterMacros = GetNumMacros()
  local macroButtonName, macroButton, macroIcon, macroName
  local name, texture, body

  if SimpleMacroFrame.macroStart == 0 then
    numMacros = numAccountMacros
  else
    numMacros = numCharacterMacros
  end

  for i = 1, MAX_ACCOUNT_MACROS do
    macroButtonName = "SMUserButton"..i
    macroButton = G[macroButtonName]
    macroIcon = G[macroButtonName.."Icon"]
    macroName = G[macroButtonName.."Name"]

    if i <= SimpleMacroFrame.macroMax then
      if i <= numMacros then
        name, texture, body = GetMacroInfo(i + SimpleMacroFrame.macroStart)
        macroButton:SetIconTexture(texture)
        macroButton.Name:SetText(name)
        macroButton:Enable()

        if SimpleMacroFrame.userSelect and SimpleMacroFrame.userSelect == i then
          macroButton:SetChecked(true)
        else
          macroButton:SetChecked(false)
        end
      else
        macroButton:SetIconTexture("")
        macroButton.Name:SetText("")
        macroButton:Disable()
        macroButton:SetChecked(false)
      end

      macroButton:Show()
    else
      macroButton:Hide()
    end
  end
end

function SM_GroupButton_Update()
  local _, _ = GetNumMacros()
  local macroButtonName, macroButton, macroIcon, macroName
  local name, texture, body
  local groupTable = SimpleMacro.dbc.GroupTable
  local group = groupTable[groupTable.selected]

  for i = 1, MAX_ACCOUNT_MACROS do
    macroButtonName = "SMGroupButton"..i
    macroButton = G[macroButtonName]
    macroIcon = G[macroButtonName.."Icon"]
    macroName = G[macroButtonName.."Name"]

    if group and i <= #group then
      --[[
        TODO what if group[i] doesn't exist anymore or is the wrong macro. FIX: hook into Macro deletion to update group ids
      ]]
      name, texture, body = GetMacroInfo(group[i])
      macroButton:SetIconTexture(texture)
      macroButton.Name:SetText(name)
      macroButton:Enable()

      if SimpleMacroFrame.groupSelect and SimpleMacroFrame.groupSelect == i then
        macroButton:SetChecked(true)
      else
        macroButton:SetChecked(false)
      end
    else
      macroButton:SetIconTexture("")
      macroButton.Name:SetText("")
      macroButton:Disable()
      macroButton:SetChecked(false)
    end
  end

  if group then
    SM_GroupAddButton:Enable()
  else
    SM_GroupAddButton:Disable()
  end

  if group and #group > 0 then
    SM_GroupDeleteButton:Enable()
    SM_GroupTargetButton:Enable()
    SM_GroupTargetText:Enable()
  else
    SM_GroupDeleteButton:Disable()
    SM_GroupTargetButton:Disable()
    SM_GroupTargetText:Disable()
  end
end

function SM_UserButton_SelectMacro(id)
  SimpleMacroFrame.userSelect = id
end

function SM_GroupButton_SelectMacro(id)
  SimpleMacroFrame.groupSelect = id
end

function SM_GroupAddButton_OnClick(_)
  local buttonId = SimpleMacroFrame.userSelect + SimpleMacroFrame.macroStart
  local groupTable = SimpleMacro.dbc.GroupTable
  local group = groupTable[groupTable.selected]
  local isFound = false

  for i = 1, #group do
    if group[i] == buttonId then
      isFound = true
    end
  end

  if isFound == false then
    group[#group + 1] = buttonId
    SM_GroupButton_SelectMacro(#group)
  end

  SM_GroupButton_Update()
end

function SM_GroupDeleteButton_OnClick(_)
  local id = SimpleMacroFrame.groupSelect
  local groupTable = SimpleMacro.dbc.GroupTable
  local group = groupTable[groupTable.selected]

  -- if we're deleting the last one, select the previous macro
  if id == #group then
    SM_GroupButton_SelectMacro(#group - 1)
  end

  -- shift all the macros down one from the deleted
  for i = 1, #group do
    if i >= id then
      group[i] = group[i + 1]
    end
  end

  SM_GroupButton_Update()
end

local function changeTargets(index, target)
  local idx = tonumber(index)
  local targetPattern = '([^,%]]*).-$'
  local macroText = GetMacroBody(idx)

  if string.len(target) ~= 0 then
    local atStart, atEnd, tarStart, tarEnd, oldTar

    atStart, atEnd = string.find(macroText, "@")
    if not isempty(atStart) then
      oldTar = string.match(string.sub(macroText, atEnd + 1), targetPattern)
      macroText = string.sub(macroText, 1, atEnd)..target..string.sub(macroText, atEnd + string.len(oldTar) + 1)
    end

    tarStart, tarEnd = string.find(macroText, "target=")
    if not isempty(tarStart) then
      oldTar = string.match(string.sub(macroText, tarEnd + 1), targetPattern)
      macroText = string.sub(macroText, 1, tarEnd)..target..string.sub(macroText, tarEnd + string.len(oldTar) + 1)
    end

    EditMacro(idx, nil, nil, macroText)
  else
    print("You need to enter in a target!")
  end
end

function SM_ChangeGroupTarget(groupNum, newTarget)
  local groupTable = SimpleMacro.dbc.GroupTable
  local group = groupTable[groupNum]

  if not isempty(newTarget) then
    for i = 1, #group do
      changeTargets(group[i], newTarget)
    end
  end

  print("Set target of Group "..groupNum.." to "..newTarget)
end

function SM_GroupTargetButton_OnClick(_)
  local groupNum = SimpleMacro.dbc.GroupTable.selected
  local newTarget = SM_GroupTargetText:GetText()

  SM_ChangeGroupTarget(groupNum, newTarget)
end


-- new shit

SimpleMacroGroupTabMixin = {}

function SimpleMacroGroupTabMixin:OnLoad()
  self.MacroSelector:AdjustScrollBarOffsets(0, 5, -4);

  local function SimpleMacroFrameInitMacroButton(macroButton, selectionIndex, name, texture, body)
    if name ~= nil then
      macroButton:SetIconTexture(texture);
      macroButton.Name:SetText(name);
      macroButton:Enable();
    else
      macroButton:SetIconTexture("");
      macroButton.Name:SetText("");
      macroButton:Disable();
    end
  end

  self.MacroSelector:SetSetupCallback(SimpleMacroFrameInitMacroButton);
  self.MacroSelector:SetCustomStride(9);
  self.MacroSelector:SetCustomPadding(5, 5, 5, 5, 13, 13);

  local function SimpleMacroFrameMacroButtonSelectedCallback(selectionIndex)
    self:SelectMacro(selectionIndex)
  end

  self.MacroSelector:SetSelectedCallback(SimpleMacroFrameMacroButtonSelectedCallback);


  EventRegistry:RegisterCallback("ClickBindingFrame.UpdateFrames", self.UpdateButtons, self);
end

function SimpleMacroGroupTabMixin:OnShow()
  local groupID = SimpleMacroGroupFrame:GetSelectedGroup()
  local groupTable = SimpleMacro.dbc.GroupTable

  SM_printall(groupTable[groupID])
  self:Update()
  --self:SelectMacro(1);
end

function SimpleMacroGroupTabMixin:OnHide()
end

function SimpleMacroGroupTabMixin:SelectMacro(index)
  local groupID = SimpleMacroGroupFrame:GetSelectedGroup()
  local groupTable = SimpleMacro.dbc.GroupTable
  local group = groupTable[groupID]
  local groupCount = #group

  if index then
    if groupCount < index then
      index = nil;
    end
  end

  self.MacroSelector:SetSelectedIndex(index);
  self:UpdateButtons();
end

function SimpleMacroGroupTabMixin:GetSelectedIndex()
  return self.MacroSelector:GetSelectedIndex();
end

function SimpleMacroGroupTabMixin:GetSelectedGroup()
  return 1
end

function SimpleMacroGroupTabMixin:RefreshIconDataProvider()
  if self.iconDataProvider == nil then
    self.iconDataProvider = CreateAndInitFromMixin(IconDataProviderMixin, IconDataProviderExtraType.Spell);
  end

  return self.iconDataProvider;
end

function SimpleMacroGroupTabMixin:Update()
  local groupID = SimpleMacroGroupFrame:GetSelectedGroup()
  local groupTable = SimpleMacro.dbc.GroupTable

  if groupTable[groupID] == nil then
    groupTable[groupID] = {}
  end

  local function MacroFrameGetMacroInfo(selectionIndex)
    local groupID = SimpleMacroGroupFrame:GetSelectedGroup()
    local groupTable = SimpleMacro.dbc.GroupTable
    return GetMacroInfo(groupTable[groupID][selectionIndex])
  end

  local function MacroFrameGetNumMacros()
    local groupID = SimpleMacroGroupFrame:GetSelectedGroup()
    local groupTable = SimpleMacro.dbc.GroupTable
    return #groupTable[groupID]
  end

  self.MacroSelector:SetSelectionsDataProvider(MacroFrameGetMacroInfo, MacroFrameGetNumMacros);
  self:UpdateButtons();
end

function SimpleMacroGroupTabMixin:UpdateButtons()
  -- TODO enable/disable delete from group button

  self.MacroSelector:UpdateAllSelectedTextures();
end

function SimpleMacroGroupTabMixin:SetText()
  -- do nothing on group tab
end

function SimpleMacroGroupTabMixin:SaveMacro()
  -- do nothing on group tab
end

function SimpleMacroGroupTabMixin:HideDetails()
  -- do nothing on group tab
end

function SimpleMacroGroupTabMixin:ShowDetails()
  -- do nothing on group tab
end

-- Buttons
function SimpleMacroGroupFrame_AddButton_OnClick()
  local index = SimpleMacroFrame:GetSelectedIndex()
  local macroIndex = SimpleMacroFrame:GetMacroDataIndex(index)
  local groupID = SimpleMacroGroupFrame:GetSelectedGroup()
  local groupTable = SimpleMacro.dbc.GroupTable

  -- TODO fix duplicates in group
  if #groupTable[groupID] == 0 then
    table.insert(groupTable[groupID], macroIndex)
    groupTable[groupID].searchTable = {}
    groupTable[groupID].searchTable[macroIndex] = true
  else
    if groupTable[groupID].searchTable[macroIndex] == nil then
      table.insert(groupTable[groupID], macroIndex)
      table.sort(groupTable[groupID])
    end
  end

  SimpleMacroGroupFrame:Update()
  -- Find index where macro was added
  for i, v in ipairs(groupTable[groupID]) do
    if v == macroIndex then
      SimpleMacroGroupFrame:SelectMacro(i)
      break
    end
  end
end

function SimpleMacroGroupFrame_DeleteButton_OnClick()
  print('Delete button OnClick')
end
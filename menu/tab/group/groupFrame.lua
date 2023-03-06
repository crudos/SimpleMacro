local _, ns = ...
local C = ns.C["GROUP_FRAME"]
local G = _G

local function loadTabs(parentFrame)
  local tabFramePrefix = 'SimpleMacroGroupFrameTab'

  for i = 1, C["MAX_TABS"] do
    local tab = CreateFrame("Button", tabFramePrefix..i, parentFrame, "SimpleMacroTopTabButtonTemplate", i)
    if i == 1 then
      tab:SetPoint("TOPRIGHT", parentFrame.MacroSelector, "TOPRIGHT", -134, 50)
    else
      tab:SetPoint("LEFT", tabFramePrefix..(i-1), "RIGHT", -2, 0)
    end
  end

  parentFrame.numTabs = C["MAX_TABS"]; -- avoid AnchorTabs PanelTemplates_SetNumTabs
end

local function isempty(s)
  return s == nil or s == ''
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

SimpleMacroGroupFrameMixin = {}

function SimpleMacroGroupFrameMixin:OnLoad()
  loadTabs(self)

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

  local function SimpleMacroFrameMacroButtonSelectedCallback(selectionIndex)
    self:SelectMacro(selectionIndex)
  end

  self.MacroSelector:SetSetupCallback(SimpleMacroFrameInitMacroButton);
  self.MacroSelector:SetSelectedCallback(SimpleMacroFrameMacroButtonSelectedCallback);
  self.MacroSelector:SetCustomStride(C["MACROS_PER_ROW"]);
  self.MacroSelector:SetCustomPadding(5, 5, 5, 5, 13, 13);
  self.MacroSelector:AdjustScrollBarOffsets(0, 5, -3);

  EventRegistry:RegisterCallback("ClickBindingFrame.UpdateFrames", self.UpdateButtons, self);
end

function SimpleMacroGroupFrameMixin:OnShow()
  local groupTable = SimpleMacro.dbc.GroupTable
  local groupID = self:GetSelectedGroupID()

  -- select group if one exists and none are selected
  if self:GetSelectedGroupID() == nil then
    self:ChangeTab(groupTable:GetCount() > 0 and 1 or nil)
  end

  -- move selector if we're out of bounds
  if self:GetSelectedIndex() > groupTable:GetMacroCount(groupID) then
    self:SelectMacro(1)
  end

  self:Update()
end

function SimpleMacroGroupFrameMixin:OnHide()
  -- do nothing
end

function SimpleMacroGroupFrameMixin:SelectTab(tab)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  self:ChangeTab(tab:GetID())
end

function SimpleMacroGroupFrameMixin:ChangeTab(tabID)
  PanelTemplates_SetTab(self, tabID)

  if tabID ~= nil then
    local groupID = self:GetSelectedGroupID()
    local macroCount = SimpleMacro.dbc.GroupTable:GetMacroCount(groupID)

    self:SelectMacro(macroCount > 0 and 1 or 0)
  end

  self:Update()
end

function SimpleMacroGroupFrameMixin:SelectMacro(index)
  local groupID = self:GetSelectedGroupID()
  local macroCount = SimpleMacro.dbc.GroupTable:GetMacroCount(groupID)

  if index and macroCount < index then
    index = nil;
  end

  self.MacroSelector:SetSelectedIndex(index);
end

function SimpleMacroGroupFrameMixin:GetSelectedIndex()
  return self.MacroSelector:GetSelectedIndex();
end

function SimpleMacroGroupFrameMixin:GetSelectedGroupID()
  return PanelTemplates_GetSelectedTab(self)
end

function SimpleMacroGroupFrameMixin:RefreshIconDataProvider()
  if self.iconDataProvider == nil then
    self.iconDataProvider = CreateAndInitFromMixin(IconDataProviderMixin, IconDataProviderExtraType.Spell);
  end

  return self.iconDataProvider;
end

function SimpleMacroGroupFrameMixin:Update()
  local groupID = self:GetSelectedGroupID()
  local groupTable = SimpleMacro.dbc.GroupTable ---@type GroupTable
  local groupCount = groupTable:GetCount()
  local macroCount = groupID and groupTable:GetMacroCount(groupID) or nil

  local function SimpleMacroGroupFrameGetMacroInfo(selectionIndex)
    if groupID and groupID <= groupCount
        and macroCount and selectionIndex <= macroCount then
      return GetMacroInfo(groupTable:GetMacroId(groupID, selectionIndex))
    else
      return nil, nil, nil
    end
  end

  local function SimpleMacroGroupFrameGetNumMacros()
    return C["MAX_MACROS_PER_GROUP"]
  end

  self.MacroSelector:SetSelectionsDataProvider(SimpleMacroGroupFrameGetMacroInfo, SimpleMacroGroupFrameGetNumMacros);
  self:UpdateButtons();
end

function SimpleMacroGroupFrameMixin:UpdateButtons()
  local groupID = self:GetSelectedGroupID()
  local groupTable = SimpleMacro.dbc.GroupTable
  local groupCount = groupTable:GetCount()
  local macroCount = groupID and groupTable:GetMacroCount(groupID) or nil

  -- Create button/selector
  if groupCount > 0 then
    self.MacroSelector:Show()
    SimpleMacroGroupFrameCreateButton:Hide()
  else
    self.MacroSelector:Hide()
    SimpleMacroGroupFrameCreateButton:Show()
  end

  -- Add button
  if groupCount > 0 and macroCount < C["MAX_MACROS_PER_GROUP"] then
    SimpleMacroGroupFrameAddButton:Enable()
  else
    SimpleMacroGroupFrameAddButton:Disable()
  end

  -- EditBox
  if groupCount > 0 and macroCount > 0 then
    SimpleMacroGroupFrameChangeButton:Show()
    SimpleMacroGroupFrameEditBox:Show()
  else
    SimpleMacroGroupFrameChangeButton:Hide()
    SimpleMacroGroupFrameEditBox:Hide()
  end

  local selectedIndex = self:GetSelectedIndex()
  -- Delete button
  if selectedIndex == 0 then
    SimpleMacroGroupFrameDeleteButton:Disable()
  else
    SimpleMacroGroupFrameDeleteButton:Enable()
  end

  self.MacroSelector:UpdateAllSelectedTextures();
  self:UpdateGroupTabs()
end

function SimpleMacroGroupFrameMixin:UpdateGroupTabs()
  local groupTable = SimpleMacro.dbc.GroupTable
  local groupCount = groupTable:GetCount()

  for i = 1, C["MAX_TABS"] do
    local tab = G['SimpleMacroGroupFrameTab'..i]
    -- group tabs
    if i <= groupCount then
      tab:SetScript("OnClick", function() SimpleMacroGroupFrame:SelectTab(tab) end)
      tab:SetText(tostring(i))
      tab:Show()
    -- add tab
    elseif i > 1 and i == groupCount + 1 then
      tab:SetScript("OnClick", function() SimpleMacroGroupFrame_CreateButton_OnClick() end)
      tab:SetText("+")
      tab:Show()
    else
      tab:Hide()
    end
  end
end

function SimpleMacroGroupFrameMixin:ChangeGroupTarget(groupID, newTarget)
  local groupTable = SimpleMacro.dbc.GroupTable
  local macroCount = groupTable:GetMacroCount(groupID)

  if not isempty(newTarget) then
    for i = 1, macroCount do
      changeTargets(groupTable:GetMacroId(groupID, i), newTarget)
    end
  end

  print("Set target of Group "..groupID.." to "..newTarget)
end

--function SimpleMacroGroupFrameMixin:GetGroupTable()
--  return SimpleMacro.dbc.GroupTable
--end
--
--function SimpleMacroGroupFrameMixin:GetSelectedGroup()
--  return self:GetGroupTable()[self:GetSelectedGroupID()]
--end
--
--function SimpleMacroGroupFrameMixin:UpdateSelectedGroup(data)
--  SimpleMacro.dbc.GroupTable[self:GetSelectedGroupID()] = data
--end

function SimpleMacroGroupFrameMixin:SetText()
  -- do nothing on group tab
end

function SimpleMacroGroupFrameMixin:SaveMacro()
  -- do nothing on group tab
end

function SimpleMacroGroupFrameMixin:HideDetails()
  -- do nothing on group tab
end

function SimpleMacroGroupFrameMixin:ShowDetails()
  -- do nothing on group tab
end

-- Buttons
function SimpleMacroGroupFrame_AddButton_OnClick()
  local groupID = SimpleMacroGroupFrame:GetSelectedGroupID()
  local groupTable = SimpleMacro.dbc.GroupTable ---@type GroupTable
  local index = SimpleMacroFrame:GetSelectedIndex()
  local macroId = SimpleMacroFrame:GetMacroDataIndex(index)

  local indexAdded = groupTable:AddMacro(groupID, macroId)
  if indexAdded then SimpleMacroGroupFrame:SelectMacro(indexAdded) end
  SimpleMacroGroupFrame:Update()
end

function SimpleMacroGroupFrame_DeleteButton_OnClick()
  local selectedIndex = SimpleMacroGroupFrame:GetSelectedIndex()
  local groupID = SimpleMacroGroupFrame:GetSelectedGroupID()
  local groupTable = SimpleMacro.dbc.GroupTable ---@type GroupTable

  groupTable:RemoveMacroAtIndex(groupID, selectedIndex)
  SimpleMacroGroupFrame:SelectMacro(math.min(groupTable:GetMacroCount(groupID), selectedIndex))
  SimpleMacroGroupFrame:Update()
end

function SimpleMacroGroupFrame_CreateButton_OnClick()
  local groupTable = SimpleMacro.dbc.GroupTable ---@type GroupTable
  local newGroupID = groupTable:AddGroup()

  SimpleMacroGroupFrame:SelectTab(G['SimpleMacroGroupFrameTab'..newGroupID])
  SimpleMacroSettings:LoadSettings()
end

function SimpleMacroGroupFrame_EditBox_OnTextChanged(self)
  if #self:GetText() > 0 then
    SimpleMacroGroupFrameChangeButton:Enable();
  else
    SimpleMacroGroupFrameChangeButton:Disable();
  end
end

function SimpleMacroGroupFrame_ChangeButton_OnClick()
  local newTarget = SimpleMacroGroupFrameEditBox:GetText()
  local groupID = SimpleMacroGroupFrame:GetSelectedGroupID()

  SimpleMacroGroupFrame:ChangeGroupTarget(groupID, newTarget)
end
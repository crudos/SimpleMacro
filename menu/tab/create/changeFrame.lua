ChangeFrameMixin = {}

function ChangeFrameMixin:OnShow()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
  IconSelectorPopupFrameTemplateMixin.OnShow(self)
  self.BorderBox.IconSelectorEditBox:SetFocus()

  if self.mode == IconSelectorPopupFrameModes.New then
    SimpleMacroCreateFrame.ScrollFrame.EditBox:Hide()
  end

  self.iconDataProvider = self:GetMacroFrame():RefreshIconDataProvider()
  self:Update()
  self.BorderBox.IconSelectorEditBox:OnTextChanged()

  local function OnIconSelected(selectionIndex, icon)
    self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(icon)

    -- Index is not yet set, but we know if an icon in IconSelector was selected it was in the list, so set directly.
    self.BorderBox.SelectedIconArea.SelectedIconButton.SelectedTexture:SetShown(false)
    self.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader:SetText(ICON_SELECTION_TITLE_CURRENT)
    self.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription:SetText(ICON_SELECTION_CLICK)
  end
  self.IconSelector:SetSelectedCallback(OnIconSelected)

  -- Disable Buttons
  SimpleMacroCreateFrameChangeButton:Disable()
  SimpleMacroCreateFrameDeleteButton:Disable()
  SimpleMacroCreateFrameNewButton:Disable()
  SimpleMacroFrameTab1:Disable()
  SimpleMacroFrameTab2:Disable()
end

function ChangeFrameMixin:OnHide()
  IconSelectorPopupFrameTemplateMixin.OnHide(self)
  local macroFrame = self:GetMacroFrame()

  if self.mode == IconSelectorPopupFrameModes.New then
    SimpleMacroCreateFrame.ScrollFrame.EditBox:Show()
    SimpleMacroCreateFrame.ScrollFrame.EditBox:SetFocus()
  end

  -- Enable Buttons
  SimpleMacroCreateFrameChangeButton:Enable()
  SimpleMacroCreateFrameDeleteButton:Enable()

  local numAccountMacros, numCharacterMacros = GetNumMacros()
  local numMacros = macroFrame.macroBase and numAccountMacros or numCharacterMacros
  SimpleMacroCreateFrameNewButton:SetEnabled(numMacros < macroFrame.macroMax)

  -- Enable tabs
  PanelTemplates_UpdateTabs(macroFrame)
end

function ChangeFrameMixin:Update()
  -- Determine whether we're creating a new macro or editing an existing one
  if self.mode == IconSelectorPopupFrameModes.New then
    self.BorderBox.IconSelectorEditBox:SetText("")
    local initialIndex = 1
    self.IconSelector:SetSelectedIndex(initialIndex)
    self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(self:GetIconByIndex(initialIndex))
  elseif self.mode == IconSelectorPopupFrameModes.Edit then
    local macroFrame = self:GetMacroFrame()
    local actualIndex = macroFrame:GetMacroDataIndex(macroFrame:GetSelectedIndex())
    local name = GetMacroInfo(actualIndex)
    self.BorderBox.IconSelectorEditBox:SetText(name)
    self.BorderBox.IconSelectorEditBox:HighlightText()

    local texture = macroFrame.SelectedMacroButton:GetIconTexture()
    self.IconSelector:SetSelectedIndex(self:GetIndexOfIcon(texture))
    self.BorderBox.SelectedIconArea.SelectedIconButton:SetIconTexture(texture)
  end

  local getSelection = GenerateClosure(self.GetIconByIndex, self)
  local getNumSelections = GenerateClosure(self.GetNumIcons, self)
  self.IconSelector:SetSelectionsDataProvider(getSelection, getNumSelections)
  self.IconSelector:ScrollToSelectedIndex()

  self.BorderBox.SelectedIconArea.SelectedIconButton:SetSelectedTexture()
  self:SetSelectedIconText()
end

function ChangeFrameMixin:CancelButton_OnClick()
  IconSelectorPopupFrameTemplateMixin.CancelButton_OnClick(self)
  self:GetMacroFrame():UpdateButtons()
end

function ChangeFrameMixin:OkayButton_OnClick()
  IconSelectorPopupFrameTemplateMixin.OkayButton_OnClick(self)

  local macroFrame = self:GetMacroFrame()

  local index = 1
  local iconTexture = self.BorderBox.SelectedIconArea.SelectedIconButton:GetIconTexture()
  local text = self.BorderBox.IconSelectorEditBox:GetText()
  local groupTable = SimpleMacro.dbc.GroupTable ---@type GroupTable

  text = string.gsub(text, "\"", "")
  if self.mode == IconSelectorPopupFrameModes.New then
    local isCharacterMacro = macroFrame.macroBase > 0
    index = CreateMacro(text, iconTexture, nil, isCharacterMacro) - macroFrame.macroBase
    groupTable:HandleCreateMacro(index + macroFrame.macroBase)
  elseif self.mode == IconSelectorPopupFrameModes.Edit then
    local actualIndex = macroFrame:GetMacroDataIndex(macroFrame:GetSelectedIndex())
    index = EditMacro(actualIndex, text, iconTexture) - macroFrame.macroBase
    groupTable:HandleDeleteMacro(actualIndex)
    groupTable:HandleCreateMacro(index + macroFrame.macroBase)
  end

  macroFrame:SelectMacro(index)
  macroFrame:Update()
end

function ChangeFrameMixin:GetMacroFrame()
  return SimpleMacroFrame
end
local _, ns = ...
local C = ns.C["MACRO_FRAME"]

UIPanelWindows["SimpleMacroFrame"] = { area = "left", pushable = 1, whileDead = 1, width = PANEL_DEFAULT_WIDTH };

SimpleMacroFrameMixin = {};

function SimpleMacroFrameMixin:OnLoad()
  self:RegisterForDrag("LeftButton")
  self:SetTitle(GetGlobalString"MENU_TITLE")

  PanelTemplates_SetNumTabs(self, 2)
  PanelTemplates_SetTab(self, 1)

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
  self.MacroSelector:SetCustomStride(C["MACROS_PER_ROW"]);
  self.MacroSelector:SetCustomPadding(5, 5, 5, 5, 13, 13);

  local function SimpleMacroFrameMacroButtonSelectedCallback(selectionIndex)
    SimpleMacroFrame:SaveMacro();
    SimpleMacroFrame:SelectMacro(selectionIndex);
    SimpleMacroChangeFrame:Hide();
    SimpleMacroCreateFrameText:ClearFocus();
  end

  self.MacroSelector:SetSelectedCallback(SimpleMacroFrameMacroButtonSelectedCallback);
  self.SelectedMacroButton:SetScript("OnDragStart", function()
    local selectedMacroIndex = self:GetSelectedIndex();
    if selectedMacroIndex ~= nil then
      local actualIndex = self:GetMacroDataIndex(selectedMacroIndex);
      PickupMacro(actualIndex);
    end
  end)

  EventRegistry:RegisterCallback("ClickBindingFrame.UpdateFrames", self.UpdateButtons, self);
end

function SimpleMacroFrameMixin:OnShow()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
  self:ChangeTab(1);
end

function SimpleMacroFrameMixin:OnHide()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
  SimpleMacroChangeFrame:Hide();
  HideUIPanel(SimpleMacroEditorPopup)

  if self.iconDataProvider ~= nil then
    self.iconDataProvider:Release();
    self.iconDataProvider = nil;
  end
end

function SimpleMacroFrameMixin:SelectTab(tab)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  self:ChangeTab(tab:GetID());
end

function SimpleMacroFrameMixin:ChangeTab(tabID)
  PanelTemplates_SetTab(self, tabID)

  if tabID == 1 then
    self:SetAccountMacros()
  elseif tabID == 2 then
    self:SetCharacterMacros()
  end
end

function SimpleMacroFrameMixin:SetAccountMacros()
  self.macroBase = 0;
  self.macroMax = MAX_ACCOUNT_MACROS;
  self:Update();
  self:SelectMacro(1);
end

function SimpleMacroFrameMixin:SetCharacterMacros()
  self.macroBase = MAX_ACCOUNT_MACROS;
  self.macroMax = MAX_CHARACTER_MACROS;
  self:Update();
  self:SelectMacro(1);
end

function SimpleMacroFrameMixin:RefreshIconDataProvider()
  if self.iconDataProvider == nil then
    self.iconDataProvider = CreateAndInitFromMixin(IconDataProviderMixin, IconDataProviderExtraType.Spell);
  end

  return self.iconDataProvider;
end

-- TODO move create frame specifics to its own Update
function SimpleMacroFrameMixin:Update()
  local useAccountMacros = PanelTemplates_GetSelectedTab(self) == 1;
  local numAccountMacros, numCharacterMacros = GetNumMacros();

  local function MacroFrameGetMacroInfo(selectionIndex)
    if selectionIndex > self.MacroSelector.numMacros then
      return nil;
    end

    local actualIndex = self:GetMacroDataIndex(selectionIndex);
    return GetMacroInfo(actualIndex);
  end

  local function MacroFrameGetNumMacros()
    return useAccountMacros and MAX_ACCOUNT_MACROS or MAX_CHARACTER_MACROS;
  end

  self.MacroSelector.numMacros = useAccountMacros and numAccountMacros or numCharacterMacros;
  self.MacroSelector:SetSelectionsDataProvider(MacroFrameGetMacroInfo, MacroFrameGetNumMacros);
  self.MacroSelector:ScrollToSelectedIndex()

  self:UpdateButtons();
end

function SimpleMacroFrameMixin:UpdateButtons()
  local hasSelectedMacro = self:GetSelectedIndex() ~= nil;
  if hasSelectedMacro then
    self:ShowDetails();
    SimpleMacroCreateFrameDeleteButton:Enable();
    SimpleMacroNavigationFrame:GetMenu():Update()
  else
    self:HideDetails();
    SimpleMacroCreateFrameDeleteButton:Disable();
  end

  local inClickBinding = InClickBindingMode();

  --Update New Button
  local numMacros = self.MacroSelector.numMacros;
  SimpleMacroCreateFrameNewButton:SetEnabled(numMacros and (numMacros < self.macroMax) and not inClickBinding);

  -- Disable Buttons
  if SimpleMacroChangeFrame:IsShown() or inClickBinding then
    SimpleMacroCreateFrameChangeButton:Disable();
    SimpleMacroCreateFrameDeleteButton:Disable();
  else
    SimpleMacroCreateFrameChangeButton:Enable();
    SimpleMacroCreateFrameDeleteButton:Enable();
  end

  if not hasSelectedMacro then
    SimpleMacroCreateFrameDeleteButton:Disable();
  end

  -- Add disabled tooltip if in click binding mode
  local disabledInClickBinding = {
    SimpleMacroCreateFrameChangeButton,
    SimpleMacroCreateFrameDeleteButton,
    SimpleMacroCreateFrameNewButton,
  };
  local onEnterFunction, onLeaveFunction;
  if inClickBinding then
    onEnterFunction = function(button)
      GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
      GameTooltip:AddLine(CLICK_BINDING_BUTTON_DISABLED, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
      GameTooltip:Show();
    end;
    onLeaveFunction = function()
      GameTooltip:Hide();
    end;
  end
  for _, button in ipairs(disabledInClickBinding) do
    button:SetScript("OnEnter", onEnterFunction);
    button:SetScript("OnLeave", onLeaveFunction);
  end

  self.MacroSelector:UpdateAllSelectedTextures();
end

function SimpleMacroFrameMixin:GetMacroDataIndex(index)
  return self.macroBase + index;
end

function SimpleMacroFrameMixin:SelectMacro(index)
  if index then
    local macroCount = select(PanelTemplates_GetSelectedTab(self), GetNumMacros());
    if macroCount < index then
      index = nil;
    end
  end

  self.MacroSelector:SetSelectedIndex(index);

  if index then
    local actualIndex = self:GetMacroDataIndex(index);
    local name, texture, _ = GetMacroInfo(actualIndex);
    if name then
      SimpleMacroFrameSelectedMacroName:SetText(name);
      self.SelectedMacroButton.Icon:SetTexture(texture);
    end
    SimpleMacroNavigationFrame:GetMenu():SetText(index)
  end

  self:UpdateButtons();
end

function SimpleMacroFrameMixin:GetSelectedIndex()
  return self.MacroSelector:GetSelectedIndex();
end

function SimpleMacroFrameMixin:GetMenu()
  return SimpleMacroNavigationFrame:GetMenu()
end

function SimpleMacroFrameMixin:HideDetails()
  SimpleMacroFrameSelectedMacroBackground:Hide();
  SimpleMacroFrameSelectedMacroName:Hide();
  self.SelectedMacroButton:Hide();
  self:GetMenu():ShowDetails()
end

function SimpleMacroFrameMixin:ShowDetails()
  SimpleMacroFrameSelectedMacroBackground:Show();
  SimpleMacroFrameSelectedMacroName:Show();
  self.SelectedMacroButton:Show();
  self:GetMenu():ShowDetails()
end

function SimpleMacroFrameMixin:SaveMacro()
  local selectedMacroIndex = self:GetSelectedIndex();
  self:GetMenu():SaveMacro(selectedMacroIndex)
end

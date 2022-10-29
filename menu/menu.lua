local _, L = ...
local G = _G

UIPanelWindows["SimpleMacroFrame"] = { area = "left", pushable = 1, whileDead = 1, width = PANEL_DEFAULT_WIDTH };

local function getGlobalString(stringID)
  return G["SIMPLE_MACRO_STRING_"..stringID]
end

SimpleMacroFrameMixin = {};

function SimpleMacroFrameMixin:OnLoad()
  PanelTemplates_SetNumTabs(self, 2)
  PanelTemplates_SetTab(self, 1)
  self:RegisterForDrag("LeftButton")
  self:SetTitle(getGlobalString"MENU_TITLE")
end

function SimpleMacroFrameMixin:OnShow()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
end

function SimpleMacroFrameMixin:OnHide()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
  HideUIPanel(SimpleMacroEditorPopup)
end

function SimpleMacroFrameMixin:SelectTab(tab)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

  local tabID = tab:GetID()
  self:ChangeTab(tabID);
end

function SimpleMacroFrameMixin:ChangeTab(tabID)
  PanelTemplates_SetTab(self, tabID)

  if tabID == 1 then
    ShowUIPanel(SMCreateFrame)
    HideUIPanel(SimpleMacroFrameGroupTab)
  elseif tabID == 2 then
    ShowUIPanel(SimpleMacroFrameGroupTab)
    HideUIPanel(SMCreateFrame)
  end
end

SimpleMacroTabFrameMixin = {};

function SimpleMacroTabFrameMixin:SelectTab(tab)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

  local tabID = tab:GetID()
  self:ChangeTab(tabID);
end

function SimpleMacroTabFrameMixin:ChangeTab(tabID)
  PanelTemplates_SetTab(self, tabID)

  if tabID == 1 then
    self:SetAccountMacros()
  elseif tabID == 2 then
    self:SetCharacterMacros()
  end
end

function SimpleMacroTabFrameMixin:SetAccountMacros()
  self.macroBase = 0;
  self.macroMax = MAX_ACCOUNT_MACROS;
  self:Update();
  self:SelectMacro(1);
end

function SimpleMacroTabFrameMixin:SetCharacterMacros()
  self.macroBase = MAX_ACCOUNT_MACROS;
  self.macroMax = MAX_CHARACTER_MACROS;
  self:Update();
  self:SelectMacro(1);
end

function SimpleMacroTabFrameMixin:Update()
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

  self:UpdateButtons();
end
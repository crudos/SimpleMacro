local _, L = ...
local G = _G

UIPanelWindows["SimpleMacroFrame"] = { area = "left", pushable = 1, whileDead = 1, width = PANEL_DEFAULT_WIDTH };

local function getGlobalString(stringID)
  return G["SIMPLE_MACRO_STRING_"..stringID]
end

SimpleMacroFrameMixin = {};

function SimpleMacroFrameMixin:OnLoad()
  --tinsert(UISpecialFrames, self:GetName())
  PanelTemplates_SetNumTabs(self, 2)
  PanelTemplates_SetTab(self, 1)
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
    -- Create tab
  elseif tabID == 2 then
    -- Group tab
  end
end
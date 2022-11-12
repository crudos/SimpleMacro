SimpleMacroNavigationMixin = {};

function SimpleMacroNavigationMixin:OnLoad()
  PanelTemplates_SetNumTabs(self, 2)
  PanelTemplates_SetTab(self, 1)
end

function SimpleMacroNavigationMixin:OnShow()
  self:ChangeTab(1)
end

function SimpleMacroNavigationMixin:OnHide()
  -- do nothing
end

function SimpleMacroNavigationMixin:SelectTab(tab)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  self:ChangeTab(tab:GetID());
end

function SimpleMacroNavigationMixin:ChangeTab(tabID)
  PanelTemplates_SetTab(self, tabID)

  if tabID == 1 then
    ShowUIPanel(SMCreateFrame)
    HideUIPanel(SimpleMacroGroupFrame)
  elseif tabID == 2 then
    ShowUIPanel(SimpleMacroGroupFrame)
    HideUIPanel(SMCreateFrame)
  end
end

function SimpleMacroNavigationMixin:GetMenu()
  local tabID = PanelTemplates_GetSelectedTab(self)

  if tabID == 1 then
    return SMCreateFrame
  elseif tabID == 2 then
    return SimpleMacroGroupFrame
  end
end

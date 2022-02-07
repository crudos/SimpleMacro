local _, L = ...
local G = _G

UIPanelWindows["SimpleMacroMenu"] = { area = "left", pushable = 1, whileDead = 1, width = PANEL_DEFAULT_WIDTH };

function SimpleMacroMenu_OnLoad(self)
  tinsert(UISpecialFrames, self:GetName())
  self:RegisterForDrag("LeftButton")
  self.name = "SimpleMacro"
  self.elapsed = 0

  PanelTemplates_SetNumTabs(SimpleMacroMenu, 2)
end

function SimpleMacroMenu_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
  local tabNum = SimpleMacro.dbc.tab

  PanelTemplates_SetTab(SimpleMacroMenu, tabNum)
  G["SimpleMacroMenu" .. L["tabs"][tabNum] .. "Tab"]:Show()
end

function SimpleMacroMenu_OnHide(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE)
end

function SimpleMacroMenuTab_OnClick(self)
  PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())

  for i, tab in ipairs(L["tabs"]) do
    if i == self:GetID() then
      G["SimpleMacroMenu" .. tab .. "Tab"]:Show()
      SimpleMacro.dbc.tab = self:GetID()
    else
      G["SimpleMacroMenu" .. tab .. "Tab"]:Hide()
    end
  end
end

function SM_ExitButton_OnClick(_)
  G["SM_MacroEditor_AddNewLine"]:Enable()
  HideUIPanel(SimpleMacroMenu)
end

function OpenEditorPopup_OnClick(_)
  ShowUIPanel(SimpleMacroEditorPopup)
end

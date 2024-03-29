SimpleMacroTextButtonTemplateMixin = {}

function SimpleMacroTextButtonTemplateMixin:OnLoad()
  self.text = self.Text
  self.highlight = self:GetHighlightTexture()
  self.highlight:SetVertexColor(.196, .388, .8) -- default highlight color, light blue
  self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
end

function SimpleMacroTextButtonTemplateMixin:OnEnter()
  if (self.text:IsTruncated()) then
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(self:GetText(), NORMAL_FONT_COLOR[1], NORMAL_FONT_COLOR[2], NORMAL_FONT_COLOR[3], 1, true)
  end
end

function SimpleMacroTextButtonTemplateMixin:OnLeave()
  GetAppropriateTooltip():Hide()
end

function SimpleMacroTextButtonTemplateMixin:SetText(text)
  self.Text:SetText(text)
  self:SetWidth(self.Text:GetWidth())
end

function SimpleMacroTextButtonTemplateMixin:Unlock()
  self.highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
  self:UnlockHighlight()
end

function SimpleMacroTextButtonTemplateMixin:Lock()
  self.highlight:SetVertexColor(1, 1, 0, 0.6) -- selectedLine, yellow
  self:LockHighlight()
end

---@param lineNum number
---@param argumentNum number
function SimpleMacroTextButtonTemplateMixin:OnClick(lineId, argumentId)
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
  local previousTextButton = SimpleMacroCreateFrame:GetClickedTextButton()
  if previousTextButton then
    previousTextButton:Unlock()
  end

  self:Lock()
  SimpleMacroCreateFrame:SetClickedTextButton(self)
  SimpleMacroEditorPopup:SetSelected(lineId, argumentId)
  ShowUIPanel(SimpleMacroEditorPopup)
  SimpleMacroEditorPopup:Update()
end

function MacroLineTextButton_OnClick(self)
  local lineId = string.match(self:GetName(), ".-(%d).*")
  self:OnClick(tonumber(lineId), nil)
end

function MacroArgumentTextButton_OnClick(self)
  local lineId, argumentId = string.match(self:GetName(), ".-(%d).-(%d).*")
  self:OnClick(tonumber(lineId), tonumber(argumentId))
end
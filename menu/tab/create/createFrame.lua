local _, ns = ...
local C = ns.C["CREATE_FRAME"]
local L = ns.L["CREATE_FRAME"]
local G = _G

StaticPopupDialogs["SIMPLE_MACRO_CONFIRM_DELETE_SELECTED_MACRO"] = {
  text = CONFIRM_DELETE_MACRO,
  button1 = OKAY,
  button2 = CANCEL,
  OnAccept = function(_)
    SimpleMacroCreateFrame:DeleteMacro();
  end,
  timeout = 0,
  whileDead = 1,
  showAlert = 1
};

SimpleMacroCreateFrameMixin = {};

-- TODO fix first load where textChanged is always set
local function setTextChanged()
  SimpleMacroCreateFrame.textChanged = 1
end

function SimpleMacroCreateFrameMixin:OnLoad()
  self.ScrollFrame.EditBox:HookScript("OnTextChanged", setTextChanged)
  printall(self.EditBoxToggle.Text)
  self.EditBoxToggle.Text:SetText(L["SIMPLE_MODE"])
end

function SimpleMacroCreateFrameMixin:OnShow()
  if SimpleMacroFrame.macroBase ~= nil then
    self:SetText(self:GetSelectedIndex())
  end
end

function SimpleMacroCreateFrameMixin:OnHide()
  self:SaveMacro();
  self:UnclickLastTextButton()
  HideUIPanel(SimpleMacroEditorPopup)
  HideUIPanel(SimpleMacroEditorConditionalPopup)
end

function SimpleMacroCreateFrameMixin:GetMacroDataIndex(index)
  return SimpleMacroFrame:GetMacroDataIndex(index);
end

function SimpleMacroCreateFrameMixin:Update()
  self:SetText(self:GetSelectedIndex())

  -- TODO find better logic here
  if not SimpleMacroCreateFrame.keepPopupsOpen then
    self:UnclickLastTextButton()
    HideUIPanel(SimpleMacroEditorPopup)
    HideUIPanel(SimpleMacroEditorConditionalPopup)
  end
end

function SimpleMacroCreateFrameMixin:GetText()
  return self.ScrollFrame.EditBox:GetText()
end

function SimpleMacroCreateFrameMixin:SetText(index)
  local actualIndex = self:GetMacroDataIndex(index);
  local name, _, body = GetMacroInfo(actualIndex);
  if name then
    self:SetSMacro(actualIndex)
    self.ScrollFrame.EditBox:SetText(body);
    if SimpleMacroCreateFrameEditBoxToggle:GetChecked() then
      setupMacroTextButtons()
    end
  end
  self.textChanged = nil
end

function SimpleMacroCreateFrameMixin:SelectMacro(index)
  return SimpleMacroFrame:SelectMacro(index);
end

function SimpleMacroCreateFrameMixin:GetSelectedIndex()
  return SimpleMacroFrame:GetSelectedIndex();
end

function SimpleMacroCreateFrameMixin:DeleteMacro()
  local selectedMacroIndex = self:GetSelectedIndex();
  local actualIndex = self:GetMacroDataIndex(selectedMacroIndex);
  DeleteMacro(actualIndex);

  local macroCount = select(PanelTemplates_GetSelectedTab(SimpleMacroFrame), GetNumMacros());
  local newMacroIndex = math.min(macroCount, selectedMacroIndex);
  self:SelectMacro(newMacroIndex > 0 and newMacroIndex or nil);

  SimpleMacroFrame:Update();
end

function SimpleMacroCreateFrameMixin:SaveMacro(selectedMacroIndex)
  if self.textChanged and (selectedMacroIndex ~= nil) then
    local actualIndex = self:GetMacroDataIndex(selectedMacroIndex);
    EditMacro(actualIndex, nil, nil, self:GetText());
    self:SelectMacro(selectedMacroIndex);
    self.textChanged = nil;
  end
end

function SimpleMacroCreateFrameMixin:HideDetails()
  SimpleMacroCreateFrameChangeButton:Hide();
  self.ScrollFrame.EditBox:Hide()
end

function SimpleMacroCreateFrameMixin:ShowDetails()
  SimpleMacroCreateFrameChangeButton:Show();
  SimpleMacroCreateFrameEnterMacroText:Show();
  self.ScrollFrame.EditBox:Show()
end

---@param index number absolute index of macro
---@return SMacro SMacro for this macro
function SimpleMacroCreateFrameMixin:SetSMacro(index)
  local currentMacro = SMacro:new()
  currentMacro:set(index)
  self.SMacro = currentMacro
  return currentMacro
end

---@return SMacro current SMacro or nil if there is none
function SimpleMacroCreateFrameMixin:GetSMacro()
  return self.SMacro
end

-- OnClick functions
function SimpleMacroCreateFrame_NewButton_OnClick()
  SimpleMacroFrame:SaveMacro();
  SimpleMacroChangeFrame.mode = IconSelectorPopupFrameModes.New;
  SimpleMacroChangeFrame:Show();
end

function SimpleMacroCreateFrame_ChangeButton_OnClick()
  SimpleMacroFrame:SaveMacro();
  SimpleMacroChangeFrame.mode = IconSelectorPopupFrameModes.Edit;
  SimpleMacroChangeFrame:Show()
end

function SimpleMacroCreateFrame_SaveButton_OnClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  SimpleMacroFrame:SaveMacro();
  SimpleMacroFrame:Update();
  SimpleMacroChangeFrame:Hide();
end

-- TODO temp
function SimpleMacroCreateFrame_OpenEditor_OnClick(self)
  ShowUIPanel(SimpleMacroEditorPopup)
  SimpleMacroEditorPopup:Update()
end

-- click editor funcs
function SimpleMacroCreateFrameMixin:UnclickLastTextButton()
  if self:GetClickedTextButton() then
    self:GetClickedTextButton():Unlock()
  end
end

function SimpleMacroCreateFrameMixin:GetClickedTextButton()
  return SimpleMacroCreateFrame.clickedTextButton
end

function SimpleMacroCreateFrameMixin:SetClickedTextButton(button)
  SimpleMacroCreateFrame.clickedTextButton = button
end

local function HideArgumentButtons(lineNum, from)
  local argumentNum = from
  local argumentPrefix = "SimpleMacroLine"..lineNum.."Argument"
  while G[argumentPrefix..argumentNum] do
    G[argumentPrefix..argumentNum]:Hide()
    argumentNum = argumentNum + 1
  end
end

---@param from number
local function HideLineButtons(from)
  local lineNum = from
  while G["SimpleMacroLine"..lineNum] do
    local currentLineName = "SimpleMacroLine"..lineNum
    G[currentLineName]:Hide()
    HideArgumentButtons(lineNum, 1)
    lineNum = lineNum + 1
  end
end

---@param from number
local function ShowLineButtons(from)
  local lineNum = from
  while G["SimpleMacroLine"..lineNum] do
    G["SimpleMacroLine"..lineNum]:Show()
    lineNum = lineNum + 1
  end
end

function CreateLineButton(lineNum)
  local lineButton
  local name = "SimpleMacroLine"..lineNum

  if G[name] == nil then
    lineButton = CreateFrame("CheckButton", name, SimpleMacroCreateFrameTextBackground, "SimpleMacroLineTextButtonTemplate")
    if lineNum == 1 then
      lineButton:SetPoint("TOPLEFT", SimpleMacroCreateFrameTextBackground, "TOPLEFT", 6, -6)
    else
      lineButton:SetPoint("TOPLEFT", "SimpleMacroLine"..(lineNum - 1), "BOTTOMLEFT", 0, 0)
    end
  else
    lineButton = G[name]
    lineButton:Show()
  end

  local sMacro = SimpleMacroCreateFrame:GetSMacro()
  lineButton:SetText(sMacro:getCommand(lineNum))
  lineButton:SetID(lineNum)
  return name
end

function CreateArgumentButton(lineName, lineNum, argumentNum)
  local argumentButton
  local argumentName = lineName.."Argument"..argumentNum

  if G[argumentName] == nil then
    argumentButton = CreateFrame("CheckButton", argumentName, SimpleMacroCreateFrameTextBackground, "SimpleMacroArgumentTextButtonTemplate")
  else
    argumentButton = G[argumentName]
    argumentButton:Show()
  end

  local sMacro = SimpleMacroCreateFrame:GetSMacro()
  argumentButton:SetText(sMacro:composeAllConditionals(lineNum, argumentNum)..' '..sMacro:getArgument(lineNum, argumentNum))
  argumentButton:SetID(argumentNum)

  if argumentNum == 1 then
    argumentButton:SetPoint("LEFT", lineName, "RIGHT", 1, 0)
  else
    local previousArgumentName = lineName.."Argument"..(argumentNum - 1)
    argumentButton:SetPoint("LEFT", previousArgumentName, "RIGHT", -1, 0)
    G[previousArgumentName]:SetText(G[previousArgumentName]:GetText()..";")
  end

  return argumentButton
end

function setupMacroTextButtons()
  local sMacro = SimpleMacroCreateFrame:GetSMacro() ---@type SMacro
  local lineCount = #sMacro:getLines()
  for lineNum = 1, lineCount, 1 do
    local currentLineName = CreateLineButton(lineNum)
    local argumentCount = #sMacro:getArguments(lineNum)
    for argumentNum = 1, argumentCount do
      CreateArgumentButton(currentLineName, lineNum, argumentNum)
    end
    HideArgumentButtons(lineNum, argumentCount + 1)
  end
  HideLineButtons(lineCount + 1)
end

-- TODO temp
function SimpleMacroCreateFrame_EditBoxToggle_OnClick(self)
  if self:GetChecked() then
    SimpleMacroCreateFrameScrollFrame:Hide()

    ShowLineButtons(1)
    setupMacroTextButtons()
  else
    SimpleMacroCreateFrameScrollFrame:Show()

    HideLineButtons(1)
  end
end

function SimpleMacroCreateFrame_CancelButton_OnClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  SimpleMacroFrame:Update();
  SimpleMacroChangeFrame:Hide();
end
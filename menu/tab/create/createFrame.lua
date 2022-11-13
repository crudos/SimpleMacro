local _, ns = ...
local C = ns.C["CREATE_FRAME"]
local G = _G

--[[
  Macro edit box

  ]]

--[[
local function SM_HideEditorLines(num)
  local lc = num
  while G["SM_MacroEditorLine"..lc] do
    G["SM_MacroEditorLine"..lc]:Hide()

    local ac = 1
    while G["SM_MacroEditorLine"..lc.."Arg"..ac] do
      G["SM_MacroEditorLine"..lc.."Arg"..ac]:Hide()

      if G["SM_MacroEditorLine"..lc.."Arg"..ac.."Conds"] then
        G["SM_MacroEditorLine"..lc.."Arg"..ac.."Conds"]:Hide()
      end

      ac = ac + 1
    end

    lc = lc + 1
  end
end

local function SM_HideEditorArgs(entry_name, num)
  local ac = num
  while G[entry_name..ac] do
    G[entry_name..ac]:Hide()
    ac = ac + 1
  end
end

local function unlockHighlight(editorEntry)
  if editorEntry ~= nil then
    editorEntry.highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
    editorEntry:UnlockHighlight()
  end
end

local function lockHighlight(editorEntry)
  editorEntry.highlight:SetVertexColor(1, 1, 0, 0.6) -- selectedLine, yellow
  editorEntry:LockHighlight()
  SimpleMacroFrame.selectedEditorEntry = editorEntry
end

function SM_MacroEditor_UnlockHighlights()
  if SimpleMacroFrame.selectedLine and G["LineEntry"..SimpleMacroFrame.selectedLine] then
    unlockHighlight(G["LineEntry"..SimpleMacroFrame.selectedLine])
  end

  if SimpleMacroFrame.selectedEditorEntry ~= nil then
    unlockHighlight(SimpleMacroFrame.selectedEditorEntry)
  end
end

function SM_MacroEditor_CreateLineFrame(lineNum)
  local macroEditorLine
  local curLine = "SM_MacroEditorLine"..lineNum
  if G[curLine] == nil then
    macroEditorLine = CreateFrame("CheckButton", curLine, SimpleMacroCreateFrameMacroEditorScrollFrameChild, "SM_MacroEditorLineEntryTemplate")

    if lineNum == 1 then
      macroEditorLine:SetPoint("TOPLEFT", SimpleMacroCreateFrameMacroEditorScrollFrameChild, "TOPLEFT", 0, 0)
    else
      macroEditorLine:SetPoint("TOPLEFT", "SM_MacroEditorLine"..(lineNum - 1), "BOTTOMLEFT", 0, 0)
    end
  else
    macroEditorLine = G[curLine]
    macroEditorLine:Show()
  end

  local currentMacro = SM_CreateTab_GetCurrentMacro()
  G[curLine.."Data"]:SetText(currentMacro:getCommand(lineNum))
  macroEditorLine:SetSize(G[curLine.."Data"]:GetStringWidth(), C["EDITOR_HEIGHT"])
  macroEditorLine:SetID(lineNum)

  return curLine
end

function SM_MacroEditor_CreateArgumentFrame(currentLine, lineNum, argumentNum)
  local macroEditorArg
  local curArg = currentLine.."Arg"..argumentNum
  if G[curArg] == nil then
    macroEditorArg = CreateFrame("CheckButton", curArg, SimpleMacroCreateFrameMacroEditorScrollFrameChild, "SM_MacroEditorArgEntryTemplate")
  else
    macroEditorArg = G[curArg]
    macroEditorArg:Show()
  end

  local currentMacro = SM_CreateTab_GetCurrentMacro()
  local argumentWithConditionals = currentMacro:composeAllConditionals(lineNum, argumentNum)..' '..currentMacro:getArgument(lineNum, argumentNum)
  G[curArg.."Data"]:SetText(argumentWithConditionals)
  macroEditorArg:SetSize(G[curArg.."Data"]:GetStringWidth(), C["EDITOR_HEIGHT"])
  macroEditorArg:SetID(argumentNum)

  if argumentNum == 1 then
    macroEditorArg:SetPoint("LEFT", currentLine, "RIGHT", 2, 0)
  else
    local previousArg = currentLine.."Arg"..(argumentNum - 1)
    macroEditorArg:SetPoint("LEFT", previousArg, "RIGHT", 2, 0)
    G[previousArg.."Data"]:SetText(G[previousArg.."Data"]:GetText()..";")
    G[previousArg]:SetSize(G[previousArg.."Data"]:GetStringWidth(), C["EDITOR_HEIGHT"])
  end

  return curArg
end

function SM_MacroEditor_Update()
  local currentMacro = SM_CreateTab_GetCurrentMacro()
  for lc = 1, currentMacro.lines.count, 1 do
    local currentLine = SM_MacroEditor_CreateLineFrame(lc)
    for ac = 1, currentMacro.lines[lc].args.count do
      SM_MacroEditor_CreateArgumentFrame(currentLine, lc, ac)
    end
    SM_HideEditorArgs(currentLine.."Arg", currentMacro.lines[lc].args.count + 1)
  end

  SM_HideEditorLines(currentMacro.lines.count + 1)
  unlockHighlight(SimpleMacroFrame.selectedEditorEntry)
end

local function SM_MacroEditor_OnClick(self)
  G["SM_MacroEditor_AddNewLine"]:Disable()

  unlockHighlight(SimpleMacroFrame.selectedEditorEntry)
  lockHighlight(self)

  SimpleMacroEditorPopup:SetSelectedMacro(SimpleMacroFrame.createSelect + SimpleMacroFrame.macroStart)
  SimpleMacroEditorPopup:SetSelectedLine(SimpleMacroFrame.selectedLine)
  SimpleMacroEditorPopup:SetSelectedArgument(SimpleMacroFrame.selectedArgument)
  ShowUIPanel(SimpleMacroEditorPopup)
  SimpleMacroEditorPopup_Update()
end

function SM_MacroEditor_OnHide(_)
  G["SM_MacroEditor_AddNewLine"]:Enable()

  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end

function SM_MacroEditorLine_OnClick(self, _, _)
  local lineNum = string.match(self:GetName(), ".-(%d).*")
  SimpleMacroFrame.selectedLine = tonumber(lineNum)
  SimpleMacroFrame.selectedArgument = nil
  SM_MacroEditor_OnClick(self, SM_NewLineMenu)
end

function SM_MacroEditorArg_OnClick(self, _, _)
  local lineNum, argNum = string.match(self:GetName(), ".-(%d).-(%d).*")
  SimpleMacroFrame.selectedLine = tonumber(lineNum)
  SimpleMacroFrame.selectedArgument = tonumber(argNum)
  SM_MacroEditor_OnClick(self, SM_ArgMenu)
end

function SM_MacroEditor_OnLoad(self)
  local width, _ = self:GetSize()

  local addLineFrame = CreateFrame("CheckButton", "SM_MacroEditor_AddNewLine", self, "SM_MacroEditorLineEntryTemplate")
  addLineFrame:SetPoint("BOTTOM", self:GetParent(), "BOTTOM", 0, 0)
  addLineFrame:SetSize(width, 16)
  addLineFrame:SetScript("OnClick", MacroEditor_AddNewLine_OnClick)

  G["SM_MacroEditor_AddNewLineData"]:SetText("+ add new line +")
end

function MacroEditor_AddNewLine_OnClick(_, _, _)
  local currentMacro = SM_CreateTab_GetCurrentMacro()
  currentMacro:addLine()
  SM_CreateTab_Update()
end

--]]


-- new shit

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

function SimpleMacroCreateFrameMixin:OnLoad()
end

function SimpleMacroCreateFrameMixin:OnShow()
  if SimpleMacroFrame.macroBase ~= nil then
    self:SetText(self:GetSelectedIndex())
  end
end

function SimpleMacroCreateFrameMixin:OnHide()
  self:SaveMacro();
end

function SimpleMacroCreateFrameMixin:GetMacroDataIndex(index)
  return SimpleMacroFrame:GetMacroDataIndex(index);
end

function SimpleMacroCreateFrameMixin:Update()
  self:SetText(self:GetSelectedIndex())
end

function SimpleMacroCreateFrameMixin:SetText(index)
  local actualIndex = self:GetMacroDataIndex(index);
  local name, _, body = GetMacroInfo(actualIndex);
  if name then
    SimpleMacroCreateFrameText:SetText(body);
  end
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
  SimpleMacroCreateFrameText:ClearFocus();
end

function SimpleMacroCreateFrameMixin:SaveMacro(selectedMacroIndex)
  if self.textChanged and (selectedMacroIndex ~= nil) then
    local actualIndex = self:GetMacroDataIndex(selectedMacroIndex);
    EditMacro(actualIndex, nil, nil, SimpleMacroCreateFrameText:GetText());
    self:SelectMacro(selectedMacroIndex);
    self.textChanged = nil;
  end
end

function SimpleMacroCreateFrameMixin:HideDetails()
  SimpleMacroCreateFrameChangeButton:Hide();
  SimpleMacroCreateFrameCharLimitText:Hide();
  SimpleMacroCreateFrameText:Hide();
end

function SimpleMacroCreateFrameMixin:ShowDetails()
  SimpleMacroCreateFrameChangeButton:Show();
  SimpleMacroCreateFrameCharLimitText:Show();
  SimpleMacroCreateFrameEnterMacroText:Show();
  SimpleMacroCreateFrameText:Show();
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
  SimpleMacroCreateFrameText:ClearFocus();
end

-- TODO temp
function SimpleMacroCreateFrame_OpenEditor_OnClick(self)
  local parent = self:GetParent()

  SimpleMacroEditorPopup:SetSMacro(parent:GetMacroDataIndex(parent:GetSelectedIndex()))
  ShowUIPanel(SimpleMacroEditorPopup)
end


function MacroBodySelector_CreateArgumentFrame(currentLine, lineNum, argumentNum)
  local macroEditorArg
  local curArg = currentLine.."Arg"..argumentNum
  if G[curArg] == nil then
    macroEditorArg = CreateFrame("CheckButton", curArg, SimpleMacroCreateFrameScrollFrameChild, "SM_MacroEditorArgEntryTemplate")
  else
    macroEditorArg = G[curArg]
    macroEditorArg:Show()
  end

  local currentMacro = Sim()
  local argumentWithConditionals = currentMacro:composeAllConditionals(lineNum, argumentNum)..' '..currentMacro:getArgument(lineNum, argumentNum)
  G[curArg.."Data"]:SetText(argumentWithConditionals)
  macroEditorArg:SetSize(G[curArg.."Data"]:GetStringWidth(), C["EDITOR_HEIGHT"])
  macroEditorArg:SetID(argumentNum)

  if argumentNum == 1 then
    macroEditorArg:SetPoint("LEFT", currentLine, "RIGHT", 2, 0)
  else
    local previousArg = currentLine.."Arg"..(argumentNum - 1)
    macroEditorArg:SetPoint("LEFT", previousArg, "RIGHT", 2, 0)
    G[previousArg.."Data"]:SetText(G[previousArg.."Data"]:GetText()..";")
    G[previousArg]:SetSize(G[previousArg.."Data"]:GetStringWidth(), C["EDITOR_HEIGHT"])
  end

  return curArg
end

local function setupMacroBodySelector()

end

-- TODO temp
function SimpleMacroCreateFrame_EditBoxToggle_OnClick(self)
  if self:GetChecked() then
    SimpleMacroCreateFrameScrollFrame:Hide()
    SimpleMacroCreateFrameTextBackground:Hide()
    SimpleMacroCreateFrameTextButton:Hide()
    --SimpleMacroCreateFrameEnterMacroText:Hide()
    SimpleMacroCreateFrameCharLimitText:Hide()

    SimpleMacroCreateFrameScrollFrame2:Show()
    setupMacroBodySelector()
  else
    SimpleMacroCreateFrameScrollFrame:Show()
    SimpleMacroCreateFrameTextBackground:Show()
    SimpleMacroCreateFrameTextButton:Show()
    --SimpleMacroCreateFrameEnterMacroText:Show()
    SimpleMacroCreateFrameCharLimitText:Show()

    SimpleMacroCreateFrameScrollFrame2:Hide()
  end
end

function SimpleMacroCreateFrame_CancelButton_OnClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  SimpleMacroFrame:Update(retainScrollPosition);
  SimpleMacroChangeFrame:Hide();
  SimpleMacroCreateFrameText:ClearFocus();
end
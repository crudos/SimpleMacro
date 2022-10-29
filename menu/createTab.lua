local _, L = ...
local C = L["CREATE_TAB"]
local G = _G

local function setAccountMacros()
  SimpleMacroFrame.macroStart = 0
  SimpleMacroFrame.macroMax = MAX_ACCOUNT_MACROS

  local numAccountMacros, _ = GetNumMacros()

  if numAccountMacros > 0 then
    SM_CreateTab_SelectMacro(1)
  else
    SM_CreateTab_SelectMacro(nil)
  end
end

local function setCharacterMacros()
  SimpleMacroFrame.macroStart = MAX_ACCOUNT_MACROS
  SimpleMacroFrame.macroMax = MAX_CHARACTER_MACROS

  local _, numCharacterMacros = GetNumMacros()

  if numCharacterMacros > 0 then
    SM_CreateTab_SelectMacro(1)
  else
    SM_CreateTab_SelectMacro(nil)
  end
end

local function setMacros(tabNum)
  if tabNum == 1 then
    setAccountMacros()
  else
    setCharacterMacros()
  end
end

-- opens the selected popup menu and closes the others
local function SM_OpenPopupMenu(menuToShow)
  local menus = C["POPUP_MENUS"]

  for _, menu in ipairs(menus) do
    local panel = G[menu]
    if menuToShow and menu == menuToShow:GetName() then
      ShowUIPanel(panel)
    else
      HideUIPanel(panel)
    end
  end
end

-- Create tab
function SM_CreateTab_OnLoad(_)
  PanelTemplates_SetNumTabs(SMCreateFrame, 2)
  PanelTemplates_SetTab(SMCreateFrame, 2) -- TODO set to first tab
end

function SM_CreateTab_OnShow(_)
  if PanelTemplates_GetSelectedTab(SMCreateFrame) == 1 then
    setAccountMacros()
  else
    setCharacterMacros()
  end

  SM_CreateTab_Update()
end

function SM_CreateTab_OnHide(_)
  SM_OpenPopupMenu(nil)
end

function SM_CreateTab_MacroTab_OnClick(self)
  local tabNum = self:GetID()

  PanelTemplates_SetTab(SMCreateFrame, tabNum)
  setMacros(tabNum)
  SM_CreateTab_Update()
end

function SMCreateButtons_OnLoad(self)
  local button
  local macrosPerRow = C["MACROS_PER_ROW"]

  for i = 1, MAX_ACCOUNT_MACROS do
    button = CreateFrame("CheckButton", "SMCreateButton"..i, self, "SimpleMacroButtonTemplate")
    button:SetID(i)
    if i == 1 then
      button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
    elseif mod(i, macrosPerRow) == 1 then
      button:SetPoint("TOP", "SMCreateButton"..(i - macrosPerRow), "BOTTOM", 0, -10);
    else
      button:SetPoint("LEFT", "SMCreateButton"..(i - 1), "RIGHT", 13, 0);
    end
  end
end

function SM_CreateTab_Update()
  -- todo
end

function SM_CreateTab_SelectMacro(id)
  SM_CreateTab_SetCurrentMacro(id)
  SM_MacroEditor_UnlockHighlights()
  HideUIPanel(SimpleMacroEditorPopup)
end

function SM_CreateTab_SetCurrentMacro(id)
  SimpleMacroFrame.createSelect = id
  SimpleMacroFrame.selectedLine = 1

  local currentMacro = SMacro:new()
  currentMacro:set(SimpleMacroFrame.createSelect + SimpleMacroFrame.macroStart)
  SimpleMacroFrame.currentMacro = currentMacro
end

function SM_CreateTab_GetCurrentMacro()
  if SimpleMacroFrame.currentMacro then
    return SimpleMacroFrame.currentMacro
  elseif SimpleMacroFrame.createSelect then
    local currentMacro = SMacro:new()
    currentMacro:set(SimpleMacroFrame.createSelect + SimpleMacroFrame.macroStart)
    SimpleMacroFrame.currentMacro = currentMacro
    return currentMacro
  else
    return nil
  end
end

function SM_CreateTab_EnableButtons()
  SMCreateFrameChange:Enable()
  SMCreateFrameDeleteButton:Enable()
end

function SM_CreateTab_DisableButtons()
  SMCreateFrameChange:Disable()
  SMCreateFrame.DeleteButton:Disable()
  SMCreateFrame.NewButton:Disable()
end

function SM_SaveButton_OnClick(_)
  SM_SaveMacro()
  SM_CreateTab_Update()
end

function SM_SaveMacro()
  --
end

function SimpleMacroChangeMenu_OnLoad(_)
  G["SimpleMacroChangeMenuCreateText"]:SetText(L["CHANGE"]["Name"])
  G["SimpleMacroChangeMenuIconsChooseText"]:SetText(L["CHANGE"]["Icon"])
end

function SimpleMacro_IconScrollFrame_OnLoad(self)
  G[self:GetName().."ScrollBar"].scrollStep = C["ICON_ROW_HEIGHT"]
end

function SimpleMacro_LoadButtons(frame, name, buttonsPerRow, totalButtons)
  for i = 1, totalButtons do
    local button = CreateFrame("CheckButton", name..i, frame, "SimpleMacroButtonTemplate")
    button:SetID(i)
    if i == 1 then
      button:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
    elseif mod(i, buttonsPerRow) == 1 then
      button:SetPoint("TOP", name..(i - buttonsPerRow), "BOTTOM", 0, -10)

      if totalButtons - buttonsPerRow < i then
        SimpleMacroFrame[name.."LastRow"] = button:GetName()
      end
    else
      button:SetPoint("LEFT", name..(i - 1), "RIGHT", 13, 0)
    end
  end
end

function SimpleMacroIcons_OnLoad(self)
  SimpleMacro_LoadButtons(self, "SMIconButton", C["ICONS_PER_ROW"], C["NUM_ICON_FRAMES"])
end

function SM_ChangeMenu_NameChanged(self)
  if strlen(self:GetText()) > 0 then
    SimpleMacroChangeMenu.BorderBox.OkayButton:Enable()
  else
    SimpleMacroChangeMenu.BorderBox.OkayButton:Disable()
  end

  SMCreateFrameSelectedText:SetText(self:GetText())
end

function SM_ChangeMenu_SelectIcon(id, texture)
  SimpleMacroFrame.selectedTexture = texture or G["SMIconButton"..id.."Icon"]:GetTexture()
end

function SimpleMacroChangeMenu_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)

  local createSelect = SimpleMacroFrame.createSelect
  local macroStart = SimpleMacroFrame.macroStart
  local mode = SimpleMacroFrame.mode

  if mode == "new" then
    SimpleMacroChangeMenuName:SetText("")
    SM_ChangeMenu_SelectIcon(nil, C["ICON_TABLE"][1])
    SMCreateFrameMacroEditorScrollFrameChild:Hide()
    SM_ChangeMenu_OnVerticalScroll(SimpleMacroChangeMenuIcons, 0)
  elseif mode == "edit" then
    local name, texture, _ = GetMacroInfo(createSelect + macroStart)
    SimpleMacroChangeMenuName:SetText(name)
    local iconIndex = C["R_ICON_TABLE"][texture] - 1
    local iconOffset = floor(iconIndex / C["ICONS_PER_ROW"])
    FauxScrollFrame_SetOffset(SimpleMacroChangeMenuIcons, iconOffset)
    SM_ChangeMenu_SelectIcon(nil, texture)
    SM_ChangeMenu_OnVerticalScroll(SimpleMacroChangeMenuIcons, C["ICON_ROW_HEIGHT"] * iconOffset)
  end

  SimpleMacroChangeMenu_Update()
  SM_CreateTab_DisableButtons()
  SimpleMacroFrameTab1:Disable()
  SimpleMacroFrameTab2:Disable()
  SMCreateFrameTab1:Disable()
  SMCreateFrameTab2:Disable()
end

function SM_ChangeMenu_OnVerticalScroll(self, offset)
  -- for some reason having this twice properly sets the frame up
  FauxScrollFrame_OnVerticalScroll(self, offset, C["ICON_ROW_HEIGHT"], SimpleMacroChangeMenu_Update)
  FauxScrollFrame_OnVerticalScroll(self, offset, C["ICON_ROW_HEIGHT"], SimpleMacroChangeMenu_Update)
end

local function SimpleMacro_ArrangeButtons(frame, name, prevOffset, offset, numRows, numPerRow, _)
  local prevOffsetMod = mod(abs(prevOffset or 0), numRows)
  local offsetMod = mod(abs(offset), numRows)

  if prevOffsetMod == offsetMod then
    return
  end

  local newLeader = G[name..(offsetMod * numPerRow + 1)]
  local _, follower, _, _, _ = newLeader:GetPoint("TOP")
  newLeader:ClearAllPoints()

  local prevLeader = G[name..(prevOffsetMod * numPerRow + 1)]
  prevLeader:ClearAllPoints()

  newLeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
  prevLeader:SetPoint("TOP", G[SimpleMacroFrame[name.."LastRow"]], "BOTTOM", 0, -10)
  SimpleMacroFrame[name.."LastRow"] = follower:GetName()
end

function SimpleMacroChangeMenu_Update()
  local numIconFrames = C["NUM_ICON_FRAMES"]
  local iconsPerRow = C["ICONS_PER_ROW"]
  local iconTable = C["ICON_TABLE"]
  local numIconRows = numIconFrames / iconsPerRow
  local selectedTexture = SimpleMacroFrame.selectedTexture
  local offset = FauxScrollFrame_GetOffset(SimpleMacroChangeMenuIcons) or 0
  local scrollFrame = SimpleMacroChangeMenuIconsScrollChildFrame
  local buttonName, button, buttonIcon

  SimpleMacro_ArrangeButtons(scrollFrame, "SMIconButton", SimpleMacroFrame.prevOffset, offset, numIconRows, iconsPerRow, numIconFrames)
  SimpleMacroFrame.prevOffset = offset

  for i = 1, numIconFrames do
    local index = i + offset * iconsPerRow
    local indexMod = mod(index - 1, numIconFrames) + 1
    buttonName = "SMIconButton"..indexMod
    button = G[buttonName]
    buttonIcon = G[buttonName.."Icon"]

    local texture = iconTable[i + offset * iconsPerRow]
    if index <= #iconTable then
      buttonIcon:SetTexture(texture)
      button:Show()
    else
      button:Hide()
    end

    if selectedTexture and selectedTexture == texture then
      button:SetChecked(1)
      G["SMCreateFrameSelectedIcon"]:SetTexture(texture)
    else
      button:SetChecked(nil)
    end
  end

  FauxScrollFrame_Update(
      SimpleMacroChangeMenuIcons,
      ceil(#iconTable / iconsPerRow),
      floor(SimpleMacroChangeMenuIcons:GetHeight() / C["ICON_ROW_HEIGHT"]),
      C["ICON_ROW_HEIGHT"])
end

function SimpleMacroChangeMenu_OnHide(_)
  SM_CreateTab_EnableButtons()
  SM_CreateTab_Update()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end

function SimpleMacroChangeMenuCancel_OnClick(_)
  SimpleMacroChangeMenu:Hide()
end

function SimpleMacroChangeMenuOkay_OnClick(_)
  local selectedTexture = SimpleMacroFrame.selectedTexture
  local createSelect = SimpleMacroFrame.createSelect
  local macroStart = SimpleMacroFrame.macroStart
  local mode = SimpleMacroFrame.mode
  local name, texture, isCharacter

  if SimpleMacroFrame.macroStart ~= 0 then
    isCharacter = 1
  end

  name = G["SimpleMacroChangeMenuName"]:GetText()
  texture = selectedTexture

  local createdIdx
  if mode == "new" then
    createdIdx = CreateMacro(name, texture, "", isCharacter)
  elseif mode == "edit" then
    createdIdx = EditMacro(createSelect + macroStart, name, texture, nil)
  end

  SM_CreateTab_SelectMacro(createdIdx - macroStart)
  SimpleMacroChangeMenu:Hide()
end


--[[
  Macro edit box

  ]]

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
    macroEditorLine = CreateFrame("CheckButton", curLine, SMCreateFrameMacroEditorScrollFrameChild, "SM_MacroEditorLineEntryTemplate")

    if lineNum == 1 then
      macroEditorLine:SetPoint("TOPLEFT", SMCreateFrameMacroEditorScrollFrameChild, "TOPLEFT", 0, 0)
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
    macroEditorArg = CreateFrame("CheckButton", curArg, SMCreateFrameMacroEditorScrollFrameChild, "SM_MacroEditorArgEntryTemplate")
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




-- new shit

function SMCreateFrame_NewButton_OnClick(_)
  SimpleMacroFrame.mode = "new"
  SM_OpenPopupMenu(SimpleMacroChangeMenu)
end

function SMCreateFrame_ChangeButton_OnClick(_)
  SimpleMacroFrame.mode = "edit"
  SM_OpenPopupMenu(SimpleMacroChangeMenu)
end

function SMCreateFrame_SaveButton_OnClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
  SMCreateFrame:SaveMacro();

  local retainScrollPosition = true;
  SMCreateFrame:Update(retainScrollPosition);

  --MacroPopupFrame:Hide();
  SMCreateFrameText:ClearFocus();
end

function SMCreateFrame_CancelButton_OnClick()
  PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);

  --local retainScrollPosition = true;
  --MacroFrame:Update(retainScrollPosition);

  --MacroPopupFrame:Hide();
  SMCreateFrameText:ClearFocus();
end

function SMCreateFrame_DeleteButton_OnClick(_)
  local numAccountMacros, numCharacterMacros
  numAccountMacros, numCharacterMacros = GetNumMacros()

  DeleteMacro(SimpleMacroFrame.createSelect + SimpleMacroFrame.macroStart)

  if SimpleMacroFrame.macroStart == 0 and SimpleMacroFrame.createSelect == numAccountMacros then
    SM_CreateTab_SelectMacro(SimpleMacroFrame.createSelect - 1)
  elseif SimpleMacroFrame.macroStart ~= 0 and SimpleMacroFrame.createSelect == numCharacterMacros then
    SM_CreateTab_SelectMacro(SimpleMacroFrame.createSelect - 1)
  else
    SM_CreateTab_SelectMacro(SimpleMacroFrame.createSelect)
  end

  SM_CreateTab_Update()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end
local _, L = ...
local C = L["Create"]
local G = _G

local function setAccountMacros()
  SimpleMacroMenu.macroStart = 0
  SimpleMacroMenu.macroMax = MAX_ACCOUNT_MACROS

  local numAccountMacros, _ = GetNumMacros()

  if numAccountMacros > 0 then
    SM_CreateTab_SelectMacro(1)
  else
    SM_CreateTab_SelectMacro(nil)
  end
end

local function setCharacterMacros()
  SimpleMacroMenu.macroStart = MAX_ACCOUNT_MACROS
  SimpleMacroMenu.macroMax = MAX_CHARACTER_MACROS

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
  local menus = C["popupMenus"]

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
  PanelTemplates_SetNumTabs(SimpleMacroMenuCreateTab, 2)
  PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
end

function SM_CreateTab_OnShow(_)
  if PanelTemplates_GetSelectedTab(SimpleMacroMenuCreateTab) == 1 then
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

  PanelTemplates_SetTab(SimpleMacroMenuCreateTab, tabNum)
  setMacros(tabNum)
  SM_CreateTab_Update()
end

function SMCreateButtons_OnLoad(self)
  local button
  local macrosPerRow = C["macrosPerRow"]

  for i = 1, MAX_ACCOUNT_MACROS do
    button = CreateFrame("CheckButton", "SMCreateButton" .. i, self, "SimpleMacroButtonTemplate")
    button:SetID(i)
    if i == 1 then
      button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
    elseif mod(i, macrosPerRow) == 1 then
      button:SetPoint("TOP", "SMCreateButton" .. (i - macrosPerRow), "BOTTOM", 0, -10);
    else
      button:SetPoint("LEFT", "SMCreateButton" .. (i - 1), "RIGHT", 13, 0);
    end
  end
end

function SM_CreateTab_Update()
  local numAccountMacros, numCharacterMacros = GetNumMacros()
  local macroButtonName, macroButton, macroIcon, macroName
  local name, texture, body
  local createSelect = SimpleMacroMenu.createSelect
  local macroStart = SimpleMacroMenu.macroStart
  local macroMax = SimpleMacroMenu.macroMax

  if createSelect then
    EditMacro(createSelect + macroStart, nil, nil, SimpleMacroMenu.createParse:compose())
  end

  if macroStart == 0 then
    numMacros = numAccountMacros
  else
    numMacros = numCharacterMacros
  end

  for i = 1, MAX_ACCOUNT_MACROS do
    macroButtonName = "SMCreateButton" .. i
    macroButton = G[macroButtonName]
    macroIcon = G[macroButtonName .. "Icon"]
    macroName = G[macroButtonName .. "Name"]

    if i <= macroMax then
      if i <= numMacros then
        name, texture, body = GetMacroInfo(i + macroStart)
        macroIcon:SetTexture(texture)
        macroName:SetText(name)
        macroButton:Enable()

        if createSelect and createSelect == i then
          macroButton:SetChecked(true)

          G["SimpleMacroMenuCreateTabSelected"]:SetID(i)
          G["SimpleMacroMenuCreateTabSelectedText"]:SetText(name)
          G["SimpleMacroMenuCreateTabSelectedIcon"]:SetTexture(texture)
          SimpleMacroMenu.selectedTexture = texture
        else
          macroButton:SetChecked(false)
        end
      else
        macroIcon:SetTexture("");
        macroName:SetText("");
        macroButton:Disable();
        macroButton:SetChecked(false)
      end

      macroButton:Show()
    else
      macroButton:Hide()
    end
  end

  -- make any button/text field updates

  if numMacros < macroMax then
    SimpleMacroMenuCreateTabNewButton:Enable()
  else
    SimpleMacroMenuCreateTabNewButton:Disable()
  end

  if createSelect ~= nil then
    SM_MacroEditor_Update()
  end

  SimpleMacroMenuCreateTabMacroEditorScrollFrameChild:Show()
  PanelTemplates_UpdateTabs(SimpleMacroMenu)
  PanelTemplates_UpdateTabs(SimpleMacroMenuCreateTab)
  SM_OpenPopupMenu(nil)
end

function SM_CreateTab_SelectMacro(id)
  if SimpleMacroMenu.selectedLine then
    if G["LineEntry" .. SimpleMacroMenu.selectedLine] then
      G["LineEntry" .. SimpleMacroMenu.selectedLine].highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
      G["LineEntry" .. SimpleMacroMenu.selectedLine]:UnlockHighlight()
    end
  end

  if SimpleMacroMenu.selectedEditorEntry ~= nil then
    SimpleMacroMenu.selectedEditorEntry.highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
    SimpleMacroMenu.selectedEditorEntry:UnlockHighlight()
  end

  SimpleMacroMenu.createSelect = id
  SimpleMacroMenu.selectedLine = 1

  if id then
    SimpleMacroMenu.createParse = SMacro:new()
    SimpleMacroMenu.createParse:set(id + SimpleMacroMenu.macroStart)
  end
end

function SM_CreateTab_EnableButtons()
  SimpleMacroMenuCreateTabChange:Enable()
  SimpleMacroMenuCreateTabDeleteButton:Enable()
end

function SM_CreateTab_DisableButtons()
  SimpleMacroMenuCreateTabChange:Disable()
  SimpleMacroMenuCreateTabDeleteButton:Disable()
  SimpleMacroMenuCreateTabNewButton:Disable()
end

function SM_SaveButton_OnClick(_)
  SM_SaveMacro()
  SM_CreateTab_Update()
end

function SM_SaveMacro()
  --
end

function SM_DeleteButton_OnClick(_)
  local numAccountMacros, numCharacterMacros
  numAccountMacros, numCharacterMacros = GetNumMacros()

  DeleteMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart)

  if SimpleMacroMenu.macroStart == 0 and SimpleMacroMenu.createSelect == numAccountMacros then
    SM_CreateTab_SelectMacro(SimpleMacroMenu.createSelect - 1)
  elseif SimpleMacroMenu.macroStart ~= 0 and SimpleMacroMenu.createSelect == numCharacterMacros then
    SM_CreateTab_SelectMacro(SimpleMacroMenu.createSelect - 1)
  else
    SM_CreateTab_SelectMacro(SimpleMacroMenu.createSelect)
  end

  SM_CreateTab_Update()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end

function SM_ChangeButton_OnClick(_)
  SimpleMacroMenu.mode = "edit"
  SM_OpenPopupMenu(SimpleMacroChangeMenu)
end

function SM_NewButton_OnClick(_)
  SimpleMacroMenu.mode = "new"
  SM_OpenPopupMenu(SimpleMacroChangeMenu)
end

function SimpleMacroChangeMenu_OnLoad(_)
  G["SimpleMacroChangeMenuCreateText"]:SetText(L["CHANGE"]["Name"])
  G["SimpleMacroChangeMenuIconsChooseText"]:SetText(L["CHANGE"]["Icon"])
end

function SimpleMacro_IconScrollFrame_OnLoad(self)
  G[self:GetName() .. "ScrollBar"].scrollStep = C["iconRowHeight"]
end

function SimpleMacro_LoadButtons(frame, name, buttonsPerRow, totalButtons)
  local button

  for i = 1, totalButtons do
    button = CreateFrame("CheckButton", name .. i, frame, "SimpleMacroButtonTemplate")
    button:SetID(i)
    if i == 1 then
      button:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
    elseif mod(i, buttonsPerRow) == 1 then
      button:SetPoint("TOP", name .. (i - buttonsPerRow), "BOTTOM", 0, -10)

      if totalButtons - buttonsPerRow < i then
        SimpleMacroMenu[name .. "LastRow"] = button:GetName()
      end
    else
      button:SetPoint("LEFT", name .. (i - 1), "RIGHT", 13, 0)
    end
  end
end

function SimpleMacroIcons_OnLoad(self)
  SimpleMacro_LoadButtons(self, "SMIconButton", C["iconsPerRow"], C["numIconFrames"])
end

function SM_ChangeMenu_NameChanged(self)
  if strlen(self:GetText()) > 0 then
    SimpleMacroChangeMenu.BorderBox.OkayButton:Enable()
  else
    SimpleMacroChangeMenu.BorderBox.OkayButton:Disable()
  end

  SimpleMacroMenuCreateTabSelectedText:SetText(self:GetText())
end

function SM_ChangeMenu_SelectIcon(id, texture)
  SimpleMacroMenu.selectedTexture = texture or G["SMIconButton" .. id .. "Icon"]:GetTexture()
end

function SimpleMacroChangeMenu_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)

  local createSelect = SimpleMacroMenu.createSelect
  local macroStart = SimpleMacroMenu.macroStart
  local mode = SimpleMacroMenu.mode

  if mode == "new" then
    SimpleMacroChangeMenuName:SetText("")
    SM_ChangeMenu_SelectIcon(nil, C["iconTable"][1])
    SimpleMacroMenuCreateTabMacroEditorScrollFrameChild:Hide()
    SM_ChangeMenu_OnVerticalScroll(SimpleMacroChangeMenuIcons, 0)
  elseif mode == "edit" then
    local name, texture, _ = GetMacroInfo(createSelect + macroStart)
    SimpleMacroChangeMenuName:SetText(name)
    local iconIndex = C["rIconTable"][texture] - 1
    local iconOffset = floor(iconIndex / C["iconsPerRow"])
    FauxScrollFrame_SetOffset(SimpleMacroChangeMenuIcons, iconOffset)
    SM_ChangeMenu_SelectIcon(nil, texture)
    SM_ChangeMenu_OnVerticalScroll(SimpleMacroChangeMenuIcons, C["iconRowHeight"] * iconOffset)
  end

  SimpleMacroChangeMenu_Update()
  SM_CreateTab_DisableButtons()
  SimpleMacroMenuTab1:Disable()
  SimpleMacroMenuTab2:Disable()
  SimpleMacroMenuCreateTabTab1:Disable()
  SimpleMacroMenuCreateTabTab2:Disable()
end

function SM_ChangeMenu_OnVerticalScroll(self, offset)
  -- for some reason having this twice properly sets the frame up
  FauxScrollFrame_OnVerticalScroll(self, offset, C["iconRowHeight"], SimpleMacroChangeMenu_Update)
  FauxScrollFrame_OnVerticalScroll(self, offset, C["iconRowHeight"], SimpleMacroChangeMenu_Update)
end

local function SimpleMacro_ArrangeButtons(frame, name, prevOffset, offset, numRows, numPerRow, _)
  local prevOffsetMod = mod(abs(prevOffset or 0), numRows)
  local offsetMod = mod(abs(offset), numRows)

  if prevOffsetMod == offsetMod then
    return
  end

  local newLeader = G[name .. (offsetMod * numPerRow + 1)]
  local _, follower, _, _, _ = newLeader:GetPoint("TOP")
  newLeader:ClearAllPoints()

  local prevLeader = G[name .. (prevOffsetMod * numPerRow + 1)]
  prevLeader:ClearAllPoints()

  newLeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
  prevLeader:SetPoint("TOP", G[SimpleMacroMenu[name .. "LastRow"]], "BOTTOM", 0, -10)
  SimpleMacroMenu[name .. "LastRow"] = follower:GetName()
end

function SimpleMacroChangeMenu_Update()
  local numIconFrames = C["numIconFrames"]
  local iconsPerRow = C["iconsPerRow"]
  local iconTable = C["iconTable"]
  local numIconRows = numIconFrames / iconsPerRow
  local selectedTexture = SimpleMacroMenu.selectedTexture
  local offset = FauxScrollFrame_GetOffset(SimpleMacroChangeMenuIcons) or 0
  local scrollFrame = SimpleMacroChangeMenuIconsScrollChildFrame
  local buttonName, button, buttonIcon

  SimpleMacro_ArrangeButtons(scrollFrame, "SMIconButton", SimpleMacroMenu.prevOffset, offset, numIconRows, iconsPerRow, numIconFrames)
  SimpleMacroMenu.prevOffset = offset

  for i = 1, numIconFrames do
    local index = i + offset * iconsPerRow
    local indexMod = mod(index - 1, numIconFrames) + 1
    buttonName = "SMIconButton" .. indexMod
    button = G[buttonName]
    buttonIcon = G[buttonName .. "Icon"]

    local texture = iconTable[i + offset * iconsPerRow]
    if index <= #iconTable then
      buttonIcon:SetTexture(texture)
      button:Show()
    else
      button:Hide()
    end

    if selectedTexture and selectedTexture == texture then
      button:SetChecked(1)
      G["SimpleMacroMenuCreateTabSelectedIcon"]:SetTexture(texture)
    else
      button:SetChecked(nil)
    end
  end

  FauxScrollFrame_Update(
      SimpleMacroChangeMenuIcons,
      ceil(#iconTable / iconsPerRow),
      floor(SimpleMacroChangeMenuIcons:GetHeight() / C["iconRowHeight"]),
      C["iconRowHeight"])
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
  local selectedTexture = SimpleMacroMenu.selectedTexture
  local createSelect = SimpleMacroMenu.createSelect
  local macroStart = SimpleMacroMenu.macroStart
  local mode = SimpleMacroMenu.mode
  local name, texture, isCharacter

  if SimpleMacroMenu.macroStart ~= 0 then
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

-- Macro editor
local function SM_HideEditorLines(num)
  local lc, ac

  lc = num

  while G["SM_MacroEditorLine" .. lc] do
    G["SM_MacroEditorLine" .. lc]:Hide()

    ac = 1
    while G["SM_MacroEditorLine" .. lc .. "Arg" .. ac] do
      G["SM_MacroEditorLine" .. lc .. "Arg" .. ac]:Hide()

      if G["SM_MacroEditorLine" .. lc .. "Arg" .. ac .. "Conds"] then
        G["SM_MacroEditorLine" .. lc .. "Arg" .. ac .. "Conds"]:Hide()
      end

      ac = ac + 1
    end

    lc = lc + 1
  end
end

local function SM_HideEditorArgs(entry_name, num)
  local ac = num

  while G[entry_name .. ac] do
    G[entry_name .. ac]:Hide()

    if G[entry_name .. ac .. "Conds"] then
      G[entry_name .. ac .. "Conds"]:Hide()
    end

    ac = ac + 1
  end
end

function SM_MacroEditor_Update()
  local parsed, macroEditorLine, macroEditorArg, macroEditorConds, editorHeight
  local curLine, curArg

  editorHeight = C["editorHeight"]
  parsed = SimpleMacroMenu.createParse

  for lc = 1, parsed.lines.count, 1 do
    curLine = "SM_MacroEditorLine" .. lc
    if G[curLine] == nil then
      macroEditorLine = CreateFrame("CheckButton", curLine, SimpleMacroMenuCreateTabMacroEditorScrollFrameChild, "SM_MacroEditorLineEntryTemplate")

      if lc == 1 then
        macroEditorLine:SetPoint("TOPLEFT", SimpleMacroMenuCreateTabMacroEditorScrollFrameChild, "TOPLEFT", 0, 0)
      else
        macroEditorLine:SetPoint("TOPLEFT", "SM_MacroEditorLine" .. (lc - 1), "BOTTOMLEFT", 0, 0)
      end
    else
      macroEditorLine = G[curLine]
      macroEditorLine:Show()
    end

    G[curLine .. "Data"]:SetText(parsed:getCommand(lc))
    macroEditorLine:SetSize(G[curLine .. "Data"]:GetStringWidth(), editorHeight)
    macroEditorLine:SetID(lc)

    for ac = 1, parsed.lines[lc].args.count do
      curArg = curLine .. "Arg" .. ac
      if G[curArg] == nil then
        macroEditorArg = CreateFrame("CheckButton", curArg, SimpleMacroMenuCreateTabMacroEditorScrollFrameChild, "SM_MacroEditorArgEntryTemplate")
      else
        macroEditorArg = G[curArg]
        macroEditorArg:Show()
      end

      if parsed.lines[lc].args[ac].conds.count > 0 then
        if G[curArg .. "Conds"] == nil then
          macroEditorConds = CreateFrame("CheckButton", curArg .. "Conds", SimpleMacroMenuCreateTabMacroEditorScrollFrameChild, "SM_MacroEditorCondEntryTemplate")
        else
          macroEditorConds = G[curArg .. "Conds"]
          macroEditorConds:Show()
        end

        if ac == 1 then
          macroEditorConds:SetPoint("LEFT", curLine, "RIGHT", 3, 0)
        else
          local argumentFrameId = curLine .. "Arg" .. (ac - 1)

          macroEditorConds:SetPoint("LEFT", argumentFrameId, "RIGHT", 3, 0)

          if (G[argumentFrameId .. "Data"]:GetText() == nil) then
            G[argumentFrameId .. "Data"]:SetText(";")
            G[argumentFrameId]:SetSize(G[argumentFrameId .. "Data"]:GetStringWidth(), editorHeight)
          else
            G[argumentFrameId .. "Data"]:SetText(G[argumentFrameId .. "Data"]:GetText() .. ";")
            G[argumentFrameId]:SetSize(G[argumentFrameId .. "Data"]:GetStringWidth(), editorHeight)
          end
        end

        if parsed:composeConditionals(lc, ac) then
          G[curArg .. "CondsData"]:SetText(parsed:composeConditionals(lc, ac))
          macroEditorConds:SetSize(G[curArg .. "CondsData"]:GetStringWidth(), editorHeight)
          macroEditorArg:SetPoint("LEFT", macroEditorConds, "RIGHT", 3, 0)
        else
          G[curArg .. "Conds"]:Hide()
          macroEditorArg:SetPoint("LEFT", curLine, "RIGHT", 3, 0)
        end
      else
        if ac == 1 then
          macroEditorArg:SetPoint("LEFT", curLine, "RIGHT", 3, 0)
        else
          macroEditorArg:SetPoint("LEFT", curLine .. "Arg" .. (ac - 1), "RIGHT", 3, 0)
          G[curLine .. "Arg" .. (ac - 1) .. "Data"]:SetText(G[curLine .. "Arg" .. (ac - 1) .. "Data"]:GetText() .. ";")
          G[curLine .. "Arg" .. (ac - 1)]:SetSize(G[curLine .. "Arg" .. (ac - 1) .. "Data"]:GetStringWidth(), editorHeight)
        end

        if G[curArg .. "Conds"] then
          G[curArg .. "Conds"]:Hide()
        end
      end

      G[curArg .. "Data"]:SetText(parsed:getArguments(lc)[ac].arg)
      macroEditorArg:SetSize(G[curArg .. "Data"]:GetStringWidth(), editorHeight)
      macroEditorArg:SetID(lc)
    end

    SM_HideEditorArgs(curLine .. "Arg", parsed.lines[lc].args.count + 1)
  end

  SM_HideEditorLines(parsed.lines.count + 1)
end

local function SearchLineTable(command)
  local checkString

  checkString = string.match(command, "[/#]?(.*)")

  for categoryID, categoryData in ipairs(L.LINE_TYPE_TABLE) do
    for commandID, commandData in ipairs(categoryData) do
      for nameID, nameData in ipairs(commandData.COMMANDS) do
        if nameData == checkString then
          return categoryID, commandID, nameID
        end
      end
    end
  end
end

local function SM_MacroEditor_OnClick(self, menuToShow)
  SM_OpenPopupMenu(menuToShow)

  G["SM_MacroEditor_AddNewLine"]:Disable()

  if SimpleMacroMenu.selectedEditorEntry ~= nil then
    SimpleMacroMenu.selectedEditorEntry.highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
    SimpleMacroMenu.selectedEditorEntry:UnlockHighlight()
  end

  if self ~= nil then
    self.highlight:SetVertexColor(1, 1, 0, 0.6) -- selectedLine, yellow
    self:LockHighlight()
    SimpleMacroMenu.selectedEditorEntry = self
  end
end

function SM_MacroEditor_OnHide(_)
  G["SM_MacroEditor_AddNewLine"]:Enable()

  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end

function SM_MacroEditorLine_OnClick(self, _, _)
  local parsed, categoryID, commandID, nameID

  parsed = SimpleMacroMenu.createParse
  categoryID, commandID, nameID = SearchLineTable(parsed:getCommand(self:GetID()))

  SM_NewLineMenuCategoryDropDown:SetValue(L.LINE_TYPE_TABLE[categoryID].CATEGORY)
  SM_NewLineMenuCommandDropDown:SetValue(L.LINE_TYPE_TABLE[categoryID][commandID].COMMANDS[nameID])

  SM_NewLineMenu.isEdit = true
  SM_NewLineMenu.selectedLine = self:GetID()

  SM_NewLineMenuCategoryDropDown:RefreshValue()
  SM_NewLineMenuCommandDropDown:RefreshValue()
  SM_MacroEditor_OnClick(self, SM_NewLineMenu)
end

function SM_MacroEditorArg_OnClick(self, _, _)
  local parsed, lineNum, argNum

  parsed = SimpleMacroMenu.createParse
  lineNum, argNum = string.match(self:GetName(), ".-(%d).-(%d).*")

  SM_ArgMenuEditBox:SetText(parsed:getArguments(tonumber(lineNum))[tonumber(argNum)].arg)
  SM_MacroEditor_OnClick(self, SM_ArgMenu)
end

function SM_MacroEditorCond_OnClick(self, _, _)
  SimpleMacroMenu.selectedLine, SimpleMacroMenu.selectedArg = string.match(self:GetName(), ".-(%d).-(%d).*")

  SimpleMacroMenu.selectedLine = tonumber(SimpleMacroMenu.selectedLine)
  SimpleMacroMenu.selectedArg = tonumber(SimpleMacroMenu.selectedArg)

  SM_MacroEditor_OnClick(self, SM_CondMenu)
end

function SM_MacroEditor_OnLoad(self)
  local addLineFrame, height, width

  width, height = self:GetSize()

  addLineFrame = CreateFrame("CheckButton", "SM_MacroEditor_AddNewLine", self, "SM_MacroEditorLineEntryTemplate")
  addLineFrame:SetPoint("BOTTOM", self:GetParent(), "BOTTOM", 0, 0)
  addLineFrame:SetSize(width, 16)
  addLineFrame:SetScript("OnClick", MacroEditor_AddNewLine_OnClick)

  G["SM_MacroEditor_AddNewLineData"]:SetText("+ add new line +")
end

function MacroEditor_AddNewLine_OnClick(self, _, _)
  SM_NewLineMenu.isEdit = false

  SM_NewLineMenuCategoryDropDown:SetDefaultValue()
  SM_NewLineMenuCommandDropDown:SetDefaultValue()
  ShowUIPanel(SM_NewLineMenu)
  self:Disable()
end

-- Lines
function SM_NewLineMenu_OnLoad(_)
  SM_NewLineMenu.isEdit = false
  SM_NewLineMenu.selectedLine = 1
end

function SM_NewLineMenu_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)
  SM_NewLineMenuCategoryDropDown:RefreshValue()
  SM_NewLineMenuCommandDropDown:RefreshValue()
end

function SM_CategoryDropDown_OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    self.defaultValue = L.LINE_TYPE_TABLE[1].CATEGORY
    self.value = self.defaultValue
    self.tooltip = self.defaultValue .. " commands."

    self.SetDefaultValue = function(this)
      this.value = this.defaultValue
      UIDropDownMenu_SetSelectedValue(this, this.value)
      this.tooltip = this.value .. " commands."
    end
    self.SetValue = function(this, value)
      this.value = value
      UIDropDownMenu_SetSelectedValue(this, value)
      this.tooltip = value .. " commands."
    end
    self.GetValue = function(this)
      return UIDropDownMenu_GetSelectedValue(this)
    end
    self.GetID = function(this)
      for i = 1, C["maxMacroCategories"] do
        if this:GetValue() == L.LINE_TYPE_TABLE[i].CATEGORY then
          return i
        end
      end
    end
    self.RefreshValue = function(this)
      UIDropDownMenu_Initialize(this, SM_CategoryDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(this, this.value)
    end

    UIDropDownMenu_SetWidth(self, 120)
    UIDropDownMenu_Initialize(self, SM_CategoryDropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(self, self.value)

    G[self:GetName() .. "Label"]:SetText(L.LINE_TYPE_CATEGORY_LABEL)
    self:UnregisterEvent(event)
  end
end

function SM_CategoryDropDown_OnClick(self)
  SM_NewLineMenuCategoryDropDown:SetValue(self.value)

  local categoryID = SM_NewLineMenuCategoryDropDown:GetID()
  SM_CommandDropDown_Initialize()
  SM_NewLineMenuCommandDropDown:SetValue(L.LINE_TYPE_TABLE[categoryID][1].COMMANDS[1])
end

function SM_CategoryDropDown_Initialize()
  local selectedValue = SM_NewLineMenuCategoryDropDown:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for _, entry in ipairs(L.LINE_TYPE_TABLE) do
    info.text = entry.CATEGORY
    info.func = SM_CategoryDropDown_OnClick
    info.value = entry.CATEGORY
    if info.value == selectedValue then
      info.checked = 1
    else
      info.checked = nil
    end
    info.tooltipTitle = entry.CATEGORY
    info.tooltipText = entry.CATEGORY .. " commands."
    UIDropDownMenu_AddButton(info)
  end
end

function SM_CommandDropDown_OnEvent(self, event, ...)
  if event == "PLAYER_ENTERING_WORLD" then
    self.defaultValue = L.LINE_TYPE_TABLE[1][1].COMMANDS[1]
    self.value = self.defaultValue
    self.tooltip = L.LINE_TYPE_TABLE[1][1].DESCRIPTION

    self.SetDefaultValue = function(this)
      this.value = this.defaultValue
      UIDropDownMenu_SetSelectedValue(this, this.value)
      this.tooltip = L.LINE_TYPE_TABLE[1][1].DESCRIPTION
    end
    self.SetValue = function(this, value)
      local categoryID, commandID

      this.value = value
      UIDropDownMenu_SetSelectedValue(this, value)
      categoryID = SM_NewLineMenuCategoryDropDown:GetID()
      commandID = SM_NewLineMenuCommandDropDown:GetID() or 1

      this.tooltip = L.LINE_TYPE_TABLE[categoryID][commandID].DESCRIPTION
    end
    self.GetValue = function(this)
      return UIDropDownMenu_GetSelectedValue(this)
    end
    self.GetID = function(_)
      local category = SM_NewLineMenuCategoryDropDown:GetID()

      for i = 1, C["maxMacroCommands"] do
        if L.LINE_TYPE_TABLE[category][i] ~= nil then
          for _, cmd in pairs(L.LINE_TYPE_TABLE[category][i].COMMANDS) do
            if SM_NewLineMenuCommandDropDown:GetValue() == cmd then
              return i
            end
          end
        end
      end
    end
    self.RefreshValue = function(this)
      UIDropDownMenu_Initialize(this, SM_CommandDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(this, this.value)
    end

    UIDropDownMenu_SetWidth(self, 120)
    UIDropDownMenu_Initialize(self, SM_CommandDropDown_Initialize)
    UIDropDownMenu_SetSelectedValue(self, self.value)

    G[self:GetName() .. "Label"]:SetText(L.LINE_TYPE_COMMAND_LABEL)
    self:UnregisterEvent(event)
  end
end

function SM_CommandDropDown_OnClick(self)
  SM_NewLineMenuCommandDropDown:SetValue(self.value)
end

function SM_CommandDropDown_Initialize()
  local categoryID = SM_NewLineMenuCategoryDropDown:GetID()
  local selectedValue = SM_NewLineMenuCommandDropDown:GetValue()
  local info = UIDropDownMenu_CreateInfo()

  for _, entry in ipairs(L.LINE_TYPE_TABLE[categoryID]) do
    info.text = entry.COMMANDS[1]
    info.func = SM_CommandDropDown_OnClick
    info.value = entry.COMMANDS[1]
    if info.value == selectedValue then
      info.checked = 1
    else
      info.checked = nil
    end
    info.tooltipTitle = entry.COMMANDS[1]
    info.tooltipText = entry.DESCRIPTION
    UIDropDownMenu_AddButton(info)
  end
end

local function SM_MenuButton_OnClick(self)
  if SimpleMacroMenu.selectedEditorEntry ~= nil then
    SimpleMacroMenu.selectedEditorEntry.highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
    SimpleMacroMenu.selectedEditorEntry:UnlockHighlight()
  end

  HideUIPanel(self:GetParent())
  SM_CreateTab_Update()
end

function SM_NewLineMenu_AddArgButton_OnClick(self)
  local lineNum, newArg

  SM_NewLineMenu_OkayButton_OnClick(SM_NewLineMenu.OkayButton)
  SM_MacroEditorLine_OnClick(G["SM_MacroEditorLine" .. SimpleMacroMenu.createParse.lines.count], nil, nil)
  lineNum = string.match(SimpleMacroMenu.selectedEditorEntry:GetName(), ".-(%d)")
  newArg = SimpleMacroMenu.createParse:addArgument(tonumber(lineNum), "~")

  SM_MenuButton_OnClick(self)
  SM_MacroEditorArg_OnClick(G["SM_MacroEditorLine" .. lineNum .. "Arg" .. newArg], nil, nil)
end

function SM_NewLineMenu_CancelButton_OnClick(self)
  SM_MenuButton_OnClick(self)
end

function SM_NewLineMenu_OkayButton_OnClick(self)
  local parsed, newLine, slashOrHash, value

  parsed = SimpleMacroMenu.createParse
  value = SM_NewLineMenuCommandDropDown:GetValue()

  if SM_NewLineMenuCategoryDropDown:GetValue() == "Metacommands" then
    slashOrHash = "#"
  else
    slashOrHash = "/"
  end

  if SM_NewLineMenu.isEdit == true then
    parsed:setCommand(SM_NewLineMenu.selectedLine, slashOrHash .. value)
  else
    newLine = parsed:addLine()
    parsed:setCommand(newLine, slashOrHash .. value)
  end

  SM_MenuButton_OnClick(self)
end

function SM_NewLineMenu_DeleteButton_OnClick(self)
  local lineNum

  lineNum = string.match(SimpleMacroMenu.selectedEditorEntry:GetName(), ".-(%d)")
  SimpleMacroMenu.createParse:removeLine(tonumber(lineNum))

  SM_MenuButton_OnClick(self)
end

-- Arguments
function SM_ArgMenu_OnLoad(_)
  SM_ArgMenuEditBoxLabel:SetText("Enter argument:")
end

function SM_ArgMenu_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)

  SM_ArgMenuEditBox:SetFocus()
end

function SM_ArgMenu_SetCondButton_OnClick(_)
  local entry_name, sLine, sArg

  entry_name = SimpleMacroMenu.selectedEditorEntry:GetName()
  sLine, sArg = string.match(entry_name, ".-(%d).-(%d).*")

  SimpleMacroMenu.selectedLine = tonumber(sLine)
  SimpleMacroMenu.selectedArg = tonumber(sArg)

  SM_ArgMenu_OkayButton_OnClick(SM_ArgMenu.OkayButton)
  SM_MacroEditor_OnClick(nil, SM_CondMenu)
end

function SM_ArgMenu_CancelButton_OnClick(self)
  SM_MenuButton_OnClick(self)
end

function SM_ArgMenu_OkayButton_OnClick(self)
  local lineNum, argNum

  lineNum, argNum = string.match(SimpleMacroMenu.selectedEditorEntry:GetName(), ".-(%d).-(%d).*")
  lineNum = tonumber(lineNum)
  argNum = tonumber(argNum)

  SimpleMacroMenu.createParse:setArgument(lineNum, argNum, SM_ArgMenuEditBox:GetText())

  SM_MenuButton_OnClick(self)
end

function SM_ArgMenu_DeleteButton_OnClick(self)
  local lineNum, argNum

  lineNum, argNum = string.match(SimpleMacroMenu.selectedEditorEntry:GetName(), ".-(%d).-(%d).*")
  lineNum = tonumber(lineNum)
  argNum = tonumber(argNum)

  SimpleMacroMenu.createParse:removeArgument(lineNum, argNum)
  SM_MenuButton_OnClick(self)
end

-- Conditionals
function SM_CondMenu_OnLoad(_)
  local cond_cbox, condEntryInput, cbox_text
  local conditionalsPerCol = C["conditionalsPerCol"]
  local conditionalSpacing = C["conditionalSpacing"]

  for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
    cond_cbox = CreateFrame("CheckButton", "SM_CondCbox" .. cboxNum, SM_CondMenu, "SimpleMacroCheckButtonTemplate")
    cond_cbox:SetID(cboxNum)
    cbox_text = G["SM_CondCbox" .. cboxNum .. "Text"]
    cbox_text:SetText(cond.DEFAULT)

    if cboxNum == 1 then
      cond_cbox:SetPoint("TOPLEFT", SM_CondMenu, "TOPLEFT", 10, -10)
    elseif cboxNum % conditionalsPerCol == 1 then
      cond_cbox:SetPoint("LEFT", "SM_CondCbox" .. (cboxNum - conditionalsPerCol), "RIGHT", conditionalSpacing, 0)
    else
      cond_cbox:SetPoint("TOPLEFT", "SM_CondCbox" .. (cboxNum - 1), "BOTTOMLEFT", 0, -6)
    end

    if cond.INPUT == true then
      condEntryInput = CreateFrame("EditBox", "SM_CondCboxInput" .. cboxNum, SM_CondMenu, "InputBoxTemplate")
      condEntryInput:SetPoint("LEFT", cond_cbox, "RIGHT", cbox_text:GetStringWidth() + 10, 0)
      condEntryInput:SetSize(92, 22)
      condEntryInput:SetAutoFocus(false)
      condEntryInput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
      cond_cbox.tooltipText = L["CONDITIONAL_STRING"]["DESCRIPTION"][cboxNum] .. " (" .. cond.INPUT_HINT .. ")"
    else
      cond_cbox.tooltipText = L["CONDITIONAL_STRING"]["DESCRIPTION"][cboxNum]
    end
  end

  G["SM_CondMenuAlternateCheckButtonText"]:SetText(L.USE_ALTERNATES)
  SM_CondMenuAlternateCheckButton.tooltipText = L.USE_ALTERNATES_DESC
end

function SM_CondCheckButton_OnClick(checkButton)
  local cboxNum = checkButton:GetID()

  if L.CONDITIONAL_LIST[cboxNum].INPUT == true then
    if checkButton:GetChecked() then
      G["SM_CondCboxInput" .. cboxNum]:SetFocus()
    else
      G["SM_CondCboxInput" .. cboxNum]:ClearFocus()
    end
  end

  SM_CheckButton_OnClick(checkButton)
end

function SM_CondMenu_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)

  local sLine, sArg, parseConditionals, conditionalArray, foundIndex

  sLine = SimpleMacroMenu.selectedLine
  sArg = SimpleMacroMenu.selectedArg
  parseConditionals = SimpleMacroMenu.createParse:getConditionals(sLine, sArg)
  conditionalArray = table.clone(parseConditionals)

  for menuIndex, menuConditional in ipairs(L.CONDITIONAL_LIST) do
    G["SM_CondCbox" .. menuIndex]:SetChecked(false)

    if menuConditional.INPUT == true then
      G["SM_CondCboxInput" .. menuIndex]:SetText("")
    end

    for i, currentConditional in ipairs(conditionalArray) do
      if string.find(currentConditional.name, menuConditional.DEFAULT)
          or (menuConditional.ALTERNATE and string.find(currentConditional.name, menuConditional.ALTERNATE)) then
        G["SM_CondCbox" .. menuIndex]:SetChecked(true)
        G["SM_CondCbox" .. menuIndex .. "Text"]:SetText(currentConditional.name)

        if menuConditional.INPUT == true then
          G["SM_CondCboxInput" .. menuIndex]:SetText(currentConditional.input)
        end

        foundIndex = i
        break
      end
    end

    if (foundIndex ~= nil) then
      table.remove(conditionalArray, foundIndex)
      foundIndex = nil

      if (conditionalArray[1] == nil) then
        return
      end
    end
  end
end

function SM_AlternateCheck_OnClick(self)
  local cbox_text

  for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
    cbox_text = G["SM_CondCbox" .. cboxNum .. "Text"]

    if not G["SM_CondCbox" .. cboxNum]:GetChecked() then
      if self:GetChecked() and cond.ALTERNATE then
        cbox_text:SetText(cond.ALTERNATE)
      else
        cbox_text:SetText(cond.DEFAULT)
      end

      if cond.INPUT == true then
        G["SM_CondCboxInput" .. cboxNum]:SetPoint("LEFT", G["SM_CondCbox" .. cboxNum], "RIGHT", cbox_text:GetStringWidth() + 8, 0)
      end
    end
  end
end

function SM_CondMenu_OkayButton_OnClick(_)
  local parse, sLine, sArg, input

  sLine = SimpleMacroMenu.selectedLine
  sArg = SimpleMacroMenu.selectedArg
  parse = SimpleMacroMenu.createParse

  parse:resetConditionals(sLine, sArg)

  for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
    if G["SM_CondCbox" .. cboxNum]:GetChecked() then

      if cond.INPUT == true then
        input = G["SM_CondCboxInput" .. cboxNum]:GetText()
      else
        input = nil
      end

      parse:addConditional(sLine, sArg, G["SM_CondCbox" .. cboxNum .. "Text"]:GetText(), input)
    end
  end

  SM_CreateTab_Update()
end

function SM_CondMenu_CancelButton_OnClick(self)
  SM_MenuButton_OnClick(self)
end

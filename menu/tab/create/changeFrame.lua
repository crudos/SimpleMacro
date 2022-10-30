local _, L = ...
local C = L["CHANGE_FRAME"]
local G = _G

function SMChangeFrame_OnLoad(_)
  G["SMChangeFrameCreateText"]:SetText(L["CHANGE"]["Name"])
  G["SMChangeFrameIconsChooseText"]:SetText(L["CHANGE"]["Icon"])
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
    SMChangeFrame.BorderBox.OkayButton:Enable()
  else
    SMChangeFrame.BorderBox.OkayButton:Disable()
  end

  SMCreateFrameSelectedText:SetText(self:GetText())
end

function SM_ChangeMenu_SelectIcon(id, texture)
  SimpleMacroFrame.selectedTexture = texture or G["SMIconButton"..id.."Icon"]:GetTexture()
end

function SMChangeFrame_OnShow(_)
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN)

  local createSelect = SimpleMacroFrame.createSelect
  local macroStart = SimpleMacroFrame.macroStart
  local mode = SMChangeFrame.mode

  if mode == "new" then
    SMChangeFrameName:SetText("")
    SM_ChangeMenu_SelectIcon(nil, C["ICON_TABLE"][1])
    SMCreateFrameMacroEditorScrollFrameChild:Hide()
    SM_ChangeMenu_OnVerticalScroll(SMChangeFrameIcons, 0)
  elseif mode == "edit" then
    local name, texture, _ = GetMacroInfo(createSelect + macroStart)
    SMChangeFrameName:SetText(name)
    local iconIndex = C["R_ICON_TABLE"][texture] - 1
    local iconOffset = floor(iconIndex / C["ICONS_PER_ROW"])
    FauxScrollFrame_SetOffset(SMChangeFrameIcons, iconOffset)
    SM_ChangeMenu_SelectIcon(nil, texture)
    SM_ChangeMenu_OnVerticalScroll(SMChangeFrameIcons, C["ICON_ROW_HEIGHT"] * iconOffset)
  end

  SMChangeFrame_Update()
  SM_CreateTab_DisableButtons()
  SimpleMacroFrameTab1:Disable()
  SimpleMacroFrameTab2:Disable()
  SMCreateFrameTab1:Disable()
  SMCreateFrameTab2:Disable()
end

function SM_ChangeMenu_OnVerticalScroll(self, offset)
  -- for some reason having this twice properly sets the frame up
  FauxScrollFrame_OnVerticalScroll(self, offset, C["ICON_ROW_HEIGHT"], SMChangeFrame_Update)
  FauxScrollFrame_OnVerticalScroll(self, offset, C["ICON_ROW_HEIGHT"], SMChangeFrame_Update)
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

function SMChangeFrame_Update()
  local numIconFrames = C["NUM_ICON_FRAMES"]
  local iconsPerRow = C["ICONS_PER_ROW"]
  local iconTable = C["ICON_TABLE"]
  local numIconRows = numIconFrames / iconsPerRow
  local selectedTexture = SimpleMacroFrame.selectedTexture
  local offset = FauxScrollFrame_GetOffset(SMChangeFrameIcons) or 0
  local scrollFrame = SMChangeFrameIconsScrollChildFrame
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
      SMChangeFrameIcons,
      ceil(#iconTable / iconsPerRow),
      floor(SMChangeFrameIcons:GetHeight() / C["ICON_ROW_HEIGHT"]),
      C["ICON_ROW_HEIGHT"])
end

function SMChangeFrame_OnHide(_)
  SM_CreateTab_EnableButtons()
  SM_CreateTab_Update()
  PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
end

function SMChangeFrameCancel_OnClick()
  SMChangeFrame:Hide()
end

function SMChangeFrameOkay_OnClick()
  local selectedTexture = SimpleMacroFrame.selectedTexture
  local createSelect = SimpleMacroFrame.createSelect
  local macroStart = SimpleMacroFrame.macroStart
  local mode = SMChangeFrame.mode
  local name, texture, isCharacter

  if SimpleMacroFrame.macroStart ~= 0 then
    isCharacter = 1
  end

  name = G["SMChangeFrameName"]:GetText()
  texture = selectedTexture

  local createdIdx
  if mode == "new" then
    createdIdx = CreateMacro(name, texture, "", isCharacter)
  elseif mode == "edit" then
    createdIdx = EditMacro(createSelect + macroStart, name, texture, nil)
  end

  SM_CreateTab_SelectMacro(createdIdx - macroStart)
  SMChangeFrame:Hide()
end
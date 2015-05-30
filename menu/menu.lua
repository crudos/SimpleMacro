-- Author      : Crudos
-- Create Date : 2/27/2015 05:17:35 PM
CREATETAB_MACROS_PER_ROW = 6
CREATETAB_CONDITIONALS_PER_COL = 18
CREATETAB_CONDITIONALS_SPACING = 184
NUM_CONDITIONALS = 36

local _, L = ...
local G = _G

local function isempty(s)
   return s == nil or s == ''
end

-- sets the selected macro button
function SimpleMacroButton_OnClick(self, button, down)
   local name = self:GetName()
   local id = self:GetID()

   if name == "SMUserButton"..id then
      SM_UserButton_SelectMacro(MAX_ACCOUNT_MACROS + id)
      SM_UserButton_Update()
   elseif name == "SMGroupButton"..id then
      SM_GroupButton_SelectMacro(id)
      SM_GroupButton_Update()
   elseif name == "SMCreateButton"..id then
      --SM_SaveMacro()
      CreateTab_SelectMacro(id)
      CreateTab_Update()
      SimpleMacroMenuCreateTabTextScrollFrameMacroText:ClearFocus();
   end
end

-- picks up the correct macro when its in the group list
function SimplePickupMacro(self)
   local name = self:GetName()
   local id = self:GetID()

   if name == "SMUserButton"..self:GetID() then
      PickupMacro(MAX_ACCOUNT_MACROS + id)
   elseif name == "SMGroupButton"..id then
      PickupMacro(SimpleMacroMenu.groupButtons[id])
   elseif name == "SMCreateButton"..id then
      PickupMacro(id + SimpleMacroMenu.macroStart)
   else
      PickupMacro(id + SimpleMacroMenu.macroStart)
   end
end

function SimpleMacroMenu_OnShow(panel)
   PlaySound("UChatScrollButton")

   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
   SM_SetAccountMacros()
   CreateTab_Update()
end

function SimpleMacroMenu_OnHide(panel)
   PlaySound("UChatScrollButton")
end

function SimpleMacroMenu_OnLoad(panel)
   panel:RegisterForDrag("LeftButton")
   panel.name = "SimpleMacro"
   InterfaceOptions_AddCategory(panel)
   panel.elapsed = 0
   PanelTemplates_SetNumTabs(SimpleMacroMenu, 2)
   PanelTemplates_SetTab(SimpleMacroMenu, 1)

   PanelTemplates_SetNumTabs(SimpleMacroMenuCreateTab, 2)
   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
   SM_SetAccountMacros()
end

-- CREATE TAB
function SimpleMacroMenuCreateTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenu, self:GetID())
   SimpleMacroMenuCreateTab:Show()
   SimpleMacroMenuGroupTab:Hide()

   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
   SM_SetAccountMacros()
   CreateTab_Update()
end

function SM_CreateTabAccountMacroTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 1)
   SM_SetAccountMacros()
   CreateTab_Update()
end

function SM_CreateTabCharacterMacroTab_OnClick(self)
   PanelTemplates_SetTab(SimpleMacroMenuCreateTab, 2)
   SM_SetCharacterMacros()
   CreateTab_Update()
end

function SM_SetAccountMacros()
   SimpleMacroMenu.macroStart = 0
   SimpleMacroMenu.macroMax = MAX_ACCOUNT_MACROS

   local numAccountMacros, numCharacterMacros = GetNumMacros()

   if numAccountMacros > 0 then
      CreateTab_SelectMacro(1)
   else
      CreateTab_SelectMacro(nil)
   end
end

function SM_SetCharacterMacros()
   SimpleMacroMenu.macroStart = MAX_ACCOUNT_MACROS
   SimpleMacroMenu.macroMax = MAX_CHARACTER_MACROS

   local numAccountMacros, numCharacterMacros = GetNumMacros()

   if numCharacterMacros > 0 then
      CreateTab_SelectMacro(1)
   else
      CreateTab_SelectMacro(nil)
   end
end

function SMCreateButtons_OnLoad(self)
   local button
   for i = 1, MAX_ACCOUNT_MACROS do
      button = CreateFrame("CheckButton", "SMCreateButton"..i, self, "SimpleMacroButtonTemplate")
      button:SetID(i)
      if i == 1 then
         button:SetPoint("TOPLEFT", self, "TOPLEFT", 6, -6)
      elseif mod(i, CREATETAB_MACROS_PER_ROW) == 1 then
         button:SetPoint("TOP", "SMCreateButton"..(i-CREATETAB_MACROS_PER_ROW), "BOTTOM", 0, -10);
      else
         button:SetPoint("LEFT", "SMCreateButton"..(i-1), "RIGHT", 13, 0);
      end
   end
end

local function SM_HideEntries(entry_type, num)
   local count = num

   while G[entry_type..count] do
      G[entry_type..count]:Hide()
      count = count + 1
   end
end

-- creates a list for this element
-- reuses old frames 
local function SM_PopulateLineList()
   local lc, parsed, line_entry

   parsed = SimpleMacroMenu.createParse

   for lc = 1, parsed.lines.count, 1 do
      if G["LineEntry"..lc] == nil then
         line_entry = CreateFrame("CheckButton", "LineEntry"..lc, SimpleMacroMenuCreateTabLineList, "LineEntryTemplate")

         if lc == 1 then
            line_entry:SetPoint("TOPLEFT", SimpleMacroMenuCreateTabLineList, "BOTTOMLEFT", 0, 0)
         else
            line_entry:SetPoint("TOPLEFT", "LineEntry"..(lc - 1), "BOTTOMLEFT", 0, -6)
         end
      else
         line_entry = G["LineEntry"..lc]
         line_entry:Show()
      end
      
      G["LineEntry"..lc.."Number"]:SetText(lc)
      G["LineEntry"..lc.."Info"]:SetText(parsed:getLine(lc))
      line_entry:SetID(lc)

      if SimpleMacroMenu.selectedLine then
         if lc == SimpleMacroMenu.selectedLine then
            LineListEntry_OnClick(line_entry, _, _)
         end
      elseif lc == 1 then
         LineListEntry_OnClick(line_entry, _, _)
      end
   end

   SM_HideEntries("LineEntry", parsed.lines.count + 1)
end

local function SM_PopulateArgList()
   local ac, parsed, arg_entry, arguments

   parsed = SimpleMacroMenu.createParse
   arguments = parsed:getArguments(SimpleMacroMenu.selectedLine)

   if arguments.count == 0 then
      SM_HideEntries("CondEntry", 1)
      SM_DeleteArgButton:Disable()
      SM_SetCondButton:Disable()
   else
      SM_DeleteArgButton:Enable()
      SM_SetCondButton:Enable()
   end

   for ac = 1, arguments.count, 1 do
      if G["ArgEntry"..ac] == nil then
         arg_entry = CreateFrame("CheckButton", "ArgEntry"..ac, SimpleMacroMenuCreateTabArgList, "ArgEntryTemplate")

         if ac == 1 then
            arg_entry:SetPoint("TOPLEFT", SimpleMacroMenuCreateTabArgList, "BOTTOMLEFT", 0, 0)
         else
            arg_entry:SetPoint("TOPLEFT", "ArgEntry"..(ac - 1), "BOTTOMLEFT", 0, -6)
         end
      else
         arg_entry = G["ArgEntry"..ac]
         arg_entry:Show()
      end
      
      G["ArgEntry"..ac.."Number"]:SetText(ac)
      G["ArgEntry"..ac.."Info"]:SetText(arguments[ac].arg)
      arg_entry:SetID(ac)

      if SimpleMacroMenu.selectedArg then
         if ac == SimpleMacroMenu.selectedArg then
            ArgListEntry_OnClick(arg_entry, _, _)
         end
      elseif ac == 1 then
         ArgListEntry_OnClick(arg_entry, _, _)
      end
   end

   SM_HideEntries("ArgEntry", arguments.count + 1)
end

local function SM_PopulateCondList()
   local cc, parsed, cond_entry, conditionals, info

   parsed = SimpleMacroMenu.createParse
   conditionals = parsed:getConditionals(SimpleMacroMenu.selectedLine, SimpleMacroMenu.selectedArg)

   for cc = 1, conditionals.count, 1 do
      if G["CondEntry"..cc] == nil then
         cond_entry = CreateFrame("CheckButton", "CondEntry"..cc, SimpleMacroMenuCreateTabCondList, "CondEntryTemplate")

         if cc == 1 then
            cond_entry:SetPoint("TOPLEFT", SimpleMacroMenuCreateTabCondList, "BOTTOMLEFT", 0, 0)
         else
            cond_entry:SetPoint("TOPLEFT", "CondEntry"..(cc - 1), "BOTTOMLEFT", 0, -6)
         end
      else
         cond_entry = G["CondEntry"..cc]
         cond_entry:Show()
      end
      
      G["CondEntry"..cc.."Number"]:SetText(cc)
      G["CondEntry"..cc.."Info"]:SetText(conditionals[cc].cond..(conditionals[cc].input and conditionals[cc].input or ""))
      cond_entry:SetID(cc)

      if cc == 1 then
         --CondListEntry_OnClick(cond_entry, _, _)
      end
   end

   SM_HideEntries("CondEntry", conditionals.count + 1)
end

function CreateTab_Update()
   local numAccountMacros, numCharacterMacros = GetNumMacros()
   local numMacros, maxMacros
   local macroButtonName, macroButton, macroIcon, macroName
   local name, texture, body

   if SimpleMacroMenu.macroStart == 0 then
      numMacros = numAccountMacros
   else
      numMacros = numCharacterMacros
   end

   for i = 1, MAX_ACCOUNT_MACROS do
      macroButtonName = "SMCreateButton"..i
      macroButton = G[macroButtonName]
      macroIcon = G[macroButtonName.."Icon"]
      macroName = G[macroButtonName.."Name"]

      if i <= SimpleMacroMenu.macroMax then
         if i <= numMacros then
            name, texture, body = GetMacroInfo(i + SimpleMacroMenu.macroStart)
            macroIcon:SetTexture(texture)
            macroName:SetText(name)
            macroButton:Enable()

            if SimpleMacroMenu.createSelect and SimpleMacroMenu.createSelect == i then
               macroButton:SetChecked(true)
               SimpleMacroMenuCreateTabTextScrollFrameMacroText:SetText(body)

               G["SimpleMacroMenuCreateTabSelected"]:SetID(i)
               G["SimpleMacroMenuCreateTabSelectedText"]:SetText(name)
               G["SimpleMacroMenuCreateTabSelectedIcon"]:SetTexture(texture)
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

   if SimpleMacroMenu.createSelect ~= nil then
      SimpleMacroMenuCreateTab_ShowDetails()
      SM_PopulateLineList() -- will populate the args and conds within this
   else
      SimpleMacroMenuCreateTab_HideDetails()
   end

   HideUIPanel(SM_CondMenu)
end

function LineListEntry_OnClick(self, button, down)
   if SimpleMacroMenu.selectedLine then
      G["LineEntry"..SimpleMacroMenu.selectedLine].highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
      G["LineEntry"..SimpleMacroMenu.selectedLine]:UnlockHighlight()
   end

   SimpleMacroMenu.selectedLine = self:GetID()
   SimpleMacroMenuCreateTabLineTypeDropDown:SetValue(SimpleMacroMenu.createParse.lines[self:GetID()].cmd)
   self.highlight:SetVertexColor(1, 1, 0) -- selectedLine, yellow
   self:LockHighlight()

   SM_PopulateArgList()
end

function ArgListEntry_OnClick(self, button, down)
   if SimpleMacroMenu.selectedArg then
      G["ArgEntry"..SimpleMacroMenu.selectedArg].highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
      G["ArgEntry"..SimpleMacroMenu.selectedArg]:UnlockHighlight()
   end

   SimpleMacroMenu.selectedArg = self:GetID()
   self.highlight:SetVertexColor(1, 1, 0) -- selectedArg, yellow
   self:LockHighlight()

   SM_PopulateCondList()
end

function CondListEntry_OnClick(self, button, down)
   if SimpleMacroMenu.selectedCond then
      --G["CondEntry"..SimpleMacroMenu.selectedCond].highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
      --G["CondEntry"..SimpleMacroMenu.selectedCond]:UnlockHighlight()
   end

   SimpleMacroMenu.selectedCond = self:GetID()
   --self.highlight:SetVertexColor(1, 1, 0) -- selectedCond, yellow
   --self:LockHighlight()
end

function CreateTab_SelectMacro(id)
   if SimpleMacroMenu.selectedLine then
      if G["LineEntry"..SimpleMacroMenu.selectedLine] then
         G["LineEntry"..SimpleMacroMenu.selectedLine].highlight:SetVertexColor(0.196, 0.388, 0.8) -- default highlight color, light blue
         G["LineEntry"..SimpleMacroMenu.selectedLine]:UnlockHighlight()
      end
   end
   
   SimpleMacroMenu.createSelect = id
   SimpleMacroMenu.selectedLine = 1

   if id then 
      SimpleMacroMenu.createParse = SMacro:new()
      SimpleMacroMenu.createParse:set(id + SimpleMacroMenu.macroStart)
   end
end

function SimpleMacroMenuCreateTab_ShowDetails()
   SMCharLimitText:Show()
   SimpleMacroMenuCreateTabTextScrollFrameMacroText:Show()
end

function SimpleMacroMenuCreateTab_HideDetails()
   SMCharLimitText:Hide()
   SimpleMacroMenuCreateTabTextScrollFrameMacroText:Hide()
end

function SimpleMacroMenuCreateTabLineTypeDropDown_OnEvent(self, event, ...)
   if event == "PLAYER_ENTERING_WORLD" then
      self.defaultValue = ""
      self.value = self.defaultValue
      self.tooltip = L.LINE_TYPE_TOOLTIP_NONE

      UIDropDownMenu_SetWidth(self, 120)
      UIDropDownMenu_Initialize(self, SimpleMacroMenuCreateTabLineTypeDropDown_Initialize)
      UIDropDownMenu_SetSelectedValue(self, self.value)
      
      self.SetValue = 
         function (self, value)
            self.value = value
            UIDropDownMenu_SetSelectedValue(self, value)

            if value == L.LINE_TYPE_TABLE.NONE then
               self.tooltip = L.LINE_TYPE_TOOLTIP_NONE
            else
               if value then
                  self.tooltip = L.LINE_TYPE_TOOLTIP..(self.value == L.LINE_TYPE_TABLE.SHOWTOOLTIP and "#" or "/")..value.."."
               end
            end
         end
      self.GetValue =
         function (self)
            return UIDropDownMenu_GetSelectedValue(self)
         end
      self.RefreshValue =
         function (self)
            UIDropDownMenu_Initialize(self, SimpleMacroMenuCreateTabLineTypeDropDown_Initialize)
            UIDropDownMenu_SetSelectedValue(self, self.value)
         end

      SimpleMacroMenuCreateTabLineTypeDropDownLabel:SetText(L.LINE_TYPE_DROPDOWN_LABEL)
      self:UnregisterEvent(event)
   end
end

function SimpleMacroMenuCreateTabLineTypeDropDown_OnClick(self)
   local ltype, parse

   SimpleMacroMenuCreateTabLineTypeDropDown:SetValue(self.value)
   ltype = self.value == L.LINE_TYPE_TABLE.SHOWTOOLTIP and "#" or "/"
   parse = SimpleMacroMenu.createParse

   parse.lines[SimpleMacroMenu.selectedLine].type = ltype
   parse.lines[SimpleMacroMenu.selectedLine].cmd = self.value
   EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, parse:compose())
   CreateTab_Update()
end

function SimpleMacroMenuCreateTabLineTypeDropDown_Initialize()
   local selectedValue = UIDropDownMenu_GetSelectedValue(SimpleMacroMenuCreateTabLineTypeDropDown)
   local info = UIDropDownMenu_CreateInfo()

   for _, cmd in pairs(L.LINE_TYPE_TABLE) do
      info.text = cmd
      info.func = SimpleMacroMenuCreateTabLineTypeDropDown_OnClick
      info.value = cmd
      if info.value == selectedValue then
         info.checked = 1
      else
         info.checked = nil
      end
      info.tooltipTitle = cmd
      info.tooltipText = "The command "..cmd
      UIDropDownMenu_AddButton(info)
   end
end

function SimpleMacroMenuSaveButton_OnClick(self)
   SM_SaveMacro()
   CreateTab_Update()
end

local function makeconditionals(list)
   local condlist = ""
   local i = 0

   for conditional, _ in pairs(list) do
      i = i + 1
      if condlist == "" then
         condlist = condlist..conditional
      else
         condlist = condlist..", "..conditional
      end
   end

   if condlist == "" then
      return
   elseif i > 1 then
      return condlist
   end

   condlist = string.gsub(reverse(condlist), " ,", "", 1)
   return reverse(condlist)
end

function SimpleMacroMenuSetButton_OnClick(self)
   local spell = CreateTabSpellText:GetText()

   if GetSpellInfo(spell) ~= nil then
      local line = "/"..L.LINE.COMMAND
      line = line.." ["..makeconditionals(L.LINE.CONDITIONAL_LIST).."]"
      line = line.." "..spell
      SimpleMacroMenuCreateTabTextScrollFrameMacroText:SetText(line)
   else
      print("This spell doesn't exist.")
   end
end

function SM_SaveMacro()
   if SimpleMacroMenuCreateTab.textChanged and SimpleMacroMenu.createSelect then
      EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, SimpleMacroMenuCreateTabTextScrollFrameMacroText:GetText())
      SimpleMacroMenuCreateTab.textChanged = nil;
   end
end

function SM_AddLineButton_OnClick(self)
   local parse = SimpleMacroMenu.createParse

   parse:addLine()
   EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, parse:compose())
   CreateTab_Update()
end

function SM_DeleteLineButton_OnClick(self)
   local parse = SimpleMacroMenu.createParse

   parse:removeLine(SimpleMacroMenu.selectedLine)
   EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, parse:compose())
   CreateTab_Update()
end

function SM_AddArgToList(arg)
   local parse = SimpleMacroMenu.createParse
   
   parse:addArgument(SimpleMacroMenu.selectedLine, arg)
   EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, parse:compose())
   CreateTab_Update()
end

StaticPopupDialogs["ADD_ARGUMENT"] = {
   text = "Enter an argument to be added to this line.",
   button1 = "Accept",
   button2 = "Cancel",
   OnShow = function (self, data)
      self.editBox:SetText("")
      self.button1:Disable()
   end,
   OnAccept = function (self)
      SM_AddArgToList(self.editBox:GetText())
   end,
   EditBoxOnTextChanged = function (self, data)
      self:GetParent().button1:Enable() 
   end,
   hasEditBox = true,
   timeout = 0,
   whileDead = true,
   hideOnEscape = true,
   preferredIndex = 3
}

function SM_AddArgButton_OnClick(self)
   StaticPopup_Show("ADD_ARGUMENT")
end

function SM_DeleteArgButton_OnClick(self)
   local parse = SimpleMacroMenu.createParse

   parse:removeArgument(SimpleMacroMenu.selectedLine, SimpleMacroMenu.selectedArg)
   EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, parse:compose())
   CreateTab_Update()
end

function SimpleMacroMenuCancelButton_OnClick(self)
   HideUIPanel(SimpleMacroMenu)
end

function SM_CondMenu_OnLoad(panel)
   local cond_cbox, cboxNum, condEntryInput, cbox_text

   for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
      cond_cbox = CreateFrame("CheckButton", "SM_CondCbox"..cboxNum, SM_CondMenu, "SimpleMacroCheckButtonTemplate")
      cond_cbox:SetID(cboxNum)
      cbox_text = G["SM_CondCbox"..cboxNum.."Text"]
      cbox_text:SetText(cond.DEFAULT)

      if cboxNum == 1 then
         cond_cbox:SetPoint("TOPLEFT", SM_CondMenu, "TOPLEFT", 10, -10)
      elseif cboxNum % CREATETAB_CONDITIONALS_PER_COL == 1 then
         cond_cbox:SetPoint("LEFT", "SM_CondCbox"..(cboxNum - CREATETAB_CONDITIONALS_PER_COL), "RIGHT", CREATETAB_CONDITIONALS_SPACING, 0)
      else
         cond_cbox:SetPoint("TOPLEFT", "SM_CondCbox"..(cboxNum - 1), "BOTTOMLEFT", 0, -6)
      end

      if cond.INPUT == true then
         condEntryInput = CreateFrame("EditBox", "SM_CondCboxInput"..cboxNum, SM_CondMenu, "InputBoxTemplate")
         condEntryInput:SetPoint("LEFT", cond_cbox, "RIGHT", cbox_text:GetStringWidth() + 10, 0)
         condEntryInput:SetSize(92, 22)
         condEntryInput:SetAutoFocus(false)
         condEntryInput:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
         cond_cbox.tooltipText = cond.DESCRIPTION.." ("..cond.INPUT_HINT..")"
      else
         cond_cbox.tooltipText = cond.DESCRIPTION
      end
   end

   G["SM_CondMenuAlternateCheckButtonText"]:SetText(L.USE_ALTERNATES)
   SM_CondMenuAlternateCheckButton.tooltipText = L.USE_ALTERNATES_DESC
end

function SM_CondMenu_OnShow(panel)
   local parse, cc, cur

   sLine = SimpleMacroMenu.selectedLine
   sArg = SimpleMacroMenu.selectedArg
   parse = SimpleMacroMenu.createParse

   cc = 1
   for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
      cur = parse:getConditionals(sLine, sArg)[cc]
      G["SM_CondCbox"..cboxNum]:SetChecked(false)

      if cond.INPUT == true then
         G["SM_CondCboxInput"..cboxNum]:SetText("")
      end

      if cur then
         if string.find(cur.cond, cond.DEFAULT) or (cond.ALTERNATE and string.find(cur.cond, cond.ALTERNATE)) then
            G["SM_CondCbox"..cboxNum]:SetChecked(true)
            G["SM_CondCbox"..cboxNum.."Text"]:SetText(cur.cond)

            if cond.INPUT == true then
               G["SM_CondCboxInput"..cboxNum]:SetText(cur.input)
            end

            cc = cc + 1
         end
      end
   end

   SM_SetCondButton:Disable()
end

function SM_CondMenu_OnHide(panel)
   SM_SetCondButton:Enable()
end

function SM_CheckButton_OnClick(checkButton)
   local cboxNum = checkButton:GetID()

   if L.CONDITIONAL_LIST[cboxNum].INPUT == true then
      if checkButton:GetChecked() then
         G["SM_CondCboxInput"..cboxNum]:SetFocus()
      else
         G["SM_CondCboxInput"..cboxNum]:ClearFocus()
      end
   end

   if checkButton:GetChecked() and checkButton.interruptCheck then
      checkButton.interruptCheck(checkButton)
      checkButton:SetChecked(false)   --Make it look like the button wasn't changed, but after the interrupt function has had a chance to look at what it was set to.
      return
   elseif not checkButton:GetChecked() and checkButton.interruptUncheck then
      checkButton.interruptUncheck(checkButton)
      checkButton:SetChecked(true) --Make it look like the button wasn't changed, but after the interrupt function has had a chance to look at what it was set to.
      return
   end
end

function SM_AlternateCheck_OnClick(self)
   local cbox_text

   for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
      cbox_text = G["SM_CondCbox"..cboxNum.."Text"]

      if not G["SM_CondCbox"..cboxNum]:GetChecked() then
         if self:GetChecked() and cond.ALTERNATE then
            cbox_text:SetText(cond.ALTERNATE)
         else
            cbox_text:SetText(cond.DEFAULT)
         end

         if cond.INPUT == true then
            G["SM_CondCboxInput"..cboxNum]:SetPoint("LEFT", G["SM_CondCbox"..cboxNum], "RIGHT", cbox_text:GetStringWidth() + 8, 0)
         end
      end
   end
end

function SM_CondMenu_SaveButton_OnClick(self)
   local parse, cboxNum, sLine, sArg, condEntryInput, input

   sLine = SimpleMacroMenu.selectedLine
   sArg = SimpleMacroMenu.selectedArg
   parse = SimpleMacroMenu.createParse
   
   parse:resetConditionals(sLine, sArg)  

   for cboxNum, cond in ipairs(L.CONDITIONAL_LIST) do
      if G["SM_CondCbox"..cboxNum]:GetChecked() then

         if cond.INPUT == true then
            input = G["SM_CondCboxInput"..cboxNum]:GetText()
         else
            input = nil
         end

         parse:addConditional(sLine, sArg, G["SM_CondCbox"..cboxNum.."Text"]:GetText(), input)
      end
   end

   EditMacro(SimpleMacroMenu.createSelect + SimpleMacroMenu.macroStart, nil, nil, parse:compose())
   CreateTab_Update()

end

function SM_CondMenu_CancelButton_OnClick(self)
   HideUIPanel(SM_CondMenu)
end
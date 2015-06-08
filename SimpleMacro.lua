-- Author      : Crudos
-- Create Date : 1/27/2015 11:37:49 PM

-- MAX_CHARACTER_MACROS = 18
-- MAX_ACCOUNT_MACROS = 120

local addonName, L = ...

function SimpleMacroFrame_OnLoad(self)
   self:RegisterForDrag("LeftButton")
end

function SimpleMacroFrame_OnShow(self)
end

function SimpleMacroFrame_OnHide(self)
end

function SimpleMacro_Show()
   ShowUIPanel(SimpleMacroMenu)
end

function SimpleMacro_Hide(self)
   HideUIPanel(SimpleMacroMenu)
end

SLASH_SIMPLEMACRO1 = '/sm'
SLASH_SIMPLEMACRO2 = '/smacro'
SLASH_SIMPLEMACRO3 = '/simplemacro'
local function slashCmdHandler(msg, editbox)
   local command, args, group, index, target
   command, args = msg:match('^(%S*)%s*(.-)$')


   SimpleMacro_Show()
end

SlashCmdList["SIMPLEMACRO"] = slashCmdHandler
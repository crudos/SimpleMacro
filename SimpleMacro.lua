-- Author      : Crudos
-- Create Date : 1/27/2015 11:37:49 PM

-- MAX_CHARACTER_MACROS = 18
-- MAX_ACCOUNT_MACROS = 120

local addonName, L = ...

local listener = CreateFrame("Frame")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("PLAYER_LOGOUT")

function listener:OnEvent(event, arg1)
   if event == "ADDON_LOADED" and arg1 == addonName then
      if nil == GroupTable then
         GroupTable = {}
      end

      SimpleMacroMenu.groupTable = GroupTable
      end
   end

   if event == "PLAYER_LOGOUT" then
      GroupTable = SimpleMacroMenu.groupTable
   end
end

listener:SetScript("OnEvent", listener.OnEvent)

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
   if msg == "rg" then
      SimpleMacroMenu.groupTable = {}
      print("Reset group table")
   else
      SimpleMacro_Show()
   end
end
SlashCmdList["SIMPLEMACRO"] = slashCmdHandler
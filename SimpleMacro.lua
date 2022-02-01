local addonName, L = ...

local listener = CreateFrame("Frame", "SimpleMacro")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("PLAYER_LOGOUT")

function listener:OnEvent(event, arg1)
   if event == "ADDON_LOADED" and arg1 == addonName and SimpleMacro.loaded == nil then
      if SimpleMacroDBA == nil then
         SimpleMacroDBA = L["defaultsAccount"]
      end

      if SimpleMacroDBC == nil then
         SimpleMacroDBC = L["defaultsCharacter"]
      end

      SimpleMacro.dba = SimpleMacroDBA
      SimpleMacro.dbc = SimpleMacroDBC

      SimpleMacroSettings_Setup()
      SimpleMacro.loaded = true
   end

   if event == "PLAYER_LOGOUT" then
      SimpleMacroDBA = SimpleMacro.dba
      SimpleMacroDBC = SimpleMacro.dbc
   end
end

listener:SetScript("OnEvent", listener.OnEvent)

SLASH_SIMPLEMACRO1 = '/sm'
SLASH_SIMPLEMACRO2 = '/smacro'
SLASH_SIMPLEMACRO3 = '/simplemacro'
local function slashCmdHandler(msg, _)
   if msg == "rdb" then
      SimpleMacro.dba = L["defaultsAccount"]
      SimpleMacro.dbc = L["defaultsCharacter"]
   elseif msg == "rg" then
      SimpleMacro.dbc.groupTable = {}
      print("The group table has been reset.")
   elseif msg == "s" then
      InterfaceOptionsFrame_OpenToCategory("Simple Macro")
      InterfaceOptionsFrame_OpenToCategory("Simple Macro")
   else
      SimpleMacro_Show()
   end
end
SlashCmdList["SIMPLEMACRO"] = slashCmdHandler

function SimpleMacro_Show()
   ShowUIPanel(SimpleMacroMenu)
end

function SimpleMacro_Hide(_)
   HideUIPanel(SimpleMacroMenu)
end
local addonName, L = ...
local G = _G

local listener = CreateFrame("Frame", "SimpleMacro")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("PLAYER_LOGOUT")

function listener:OnEvent(event, arg1)
  if event == "ADDON_LOADED"
      and arg1 == addonName
      and SimpleMacro.loaded == nil then

    if SimpleMacroAccountDB == nil then
      SimpleMacroAccountDB = L["DEFAULTS_ACCOUNT"]
    end

    if SimpleMacroCharacterDB == nil then
      SimpleMacroCharacterDB = L["DEFAULTS_CHARACTER"]
    end

    SimpleMacro.dba = SimpleMacroAccountDB
    SimpleMacro.dbc = SimpleMacroCharacterDB

    SimpleMacroSettings_Setup()
    SimpleMacro.loaded = true
  end

  if event == "PLAYER_LOGOUT" then
    SimpleMacroAccountDB = SimpleMacro.dba
    SimpleMacroCharacterDB = SimpleMacro.dbc
  end
end

listener:SetScript("OnEvent", listener.OnEvent)

SLASH_SIMPLEMACRO1 = '/sm'
SLASH_SIMPLEMACRO2 = '/smacro'
SLASH_SIMPLEMACRO3 = '/simplemacro'
local function slashCmdHandler(msg, _)
  if msg == "open" or msg == "o" or msg == "" then
    ShowUIPanel(SimpleMacroFrame)
  elseif msg == "settings" or msg == "s" then
    InterfaceOptionsFrame_OpenToCategory(addonName)
  elseif msg == "rdb" then
    SimpleMacro.dba = L["DEFAULTS_ACCOUNT"]
    SimpleMacro.dbc = L["DEFAULTS_CHARACTER"]
  elseif msg == "rg" then
    SimpleMacro.dbc.GroupTable = {}
    print("The group table has been reset.")
  else
    print("usage: /sm [option]")
    print("  options:")
    print("    open, o, <empty> - Open main menu.")
    print("    settings, s - Open settings menu.")
    print("    rdb - Deletes all settings, revert back to defaults.")
    print("    rg - Deletes all group data.")
    print("    help, h - Print this message.")
  end
end
SlashCmdList["SIMPLEMACRO"] = slashCmdHandler
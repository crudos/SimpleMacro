local addonName, ns = ...
local C = ns.C
local G = _G

--function setupHooks(groupTable)
--  -- Post Hook for CreateMacro
--  local function postCreateHook(name, iconFileID, body, perCharacter, ...)
--    local macroId = ...
--    print('Custom Create')
--    groupTable:HandleCreateMacro(macroId + (G['SimpleMacroFrame'].macroBase or 0))
--    return macroId
--  end
--  local oldCreateMacro = CreateMacro
--  function CreateMacro(...)
--    local name, iconFileID, body, perCharacter = ...
--    return postCreateHook(name, iconFileID, body, perCharacter, oldCreateMacro(name, iconFileID, body, perCharacter, ...))
--  end
--
--  -- Post Hook for EditMacro
--  local function postEditHook(macroInfo, name, icon, body, ...)
--    local macroId = ...
--    print('Custom Edit')
--    groupTable:HandleEditMacro(macroInfo, macroId + (G['SimpleMacroFrame'].macroBase or 0))
--    return macroId
--  end
--  local oldEditMacro = EditMacro
--  function EditMacro(...)
--    local macroInfo, name, icon, body = ...
--    return postEditHook(macroInfo, name, icon, body, oldEditMacro(macroInfo, name, icon, body, ...))
--  end
--
--  -- hook for DeleteMacro
--  hooksecurefunc("DeleteMacro", groupTable.HandleDeleteMacro)
--end

local listener = CreateFrame("Frame", "SimpleMacro")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("PLAYER_LOGOUT")

-- Initialize database tables for startup
SimpleMacro.dba = C["SETTINGS"]["DEFAULT_ACCOUNT"]
SimpleMacro.dbc = C["SETTINGS"]["DEFAULT_CHARACTER"]

function listener:OnEvent(event, arg1)
  if event == "ADDON_LOADED" and arg1 == addonName and SimpleMacro.loaded == nil then
    if SimpleMacroAccountDB == nil or SimpleMacroAccountDB.SETTINGS == nil then
      print('Simple Macro: Account settings reset.')
      SimpleMacroAccountDB = C["SETTINGS"]["DEFAULT_ACCOUNT"]
    end
    SimpleMacro.dba = SimpleMacroAccountDB

    if SimpleMacroCharacterDB == nil or SimpleMacroAccountDB.SETTINGS == nil then
      print('Simple Macro: Character settings reset.')
      SimpleMacroCharacterDB = C["SETTINGS"]["DEFAULT_CHARACTER"]
    end
    SimpleMacro.dbc = SimpleMacroCharacterDB
    SimpleMacro.dbc.GROUP_TABLE = GroupTable:New(SimpleMacro.dbc.GROUP_TABLE)
    if SimpleMacro.dbc.SETTINGS == nil then
      SimpleMacro.dbc.SETTINGS = C["SETTINGS"]["DEFAULT_CHARACTER"]["SETTINGS"]
    end

    SimpleMacroSettings:LoadSettings()
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
    Settings.OpenToCategory(SimpleMacro.SettingsCategory:GetID())
  elseif msg == "rdb" then
    SimpleMacro.dba = C["SETTINGS"]["DEFAULT_ACCOUNT"]
    SimpleMacro.dbc = C["SETTINGS"]["DEFAULT_CHARACTER"]
    SimpleMacroSettings:LoadSettings()
    print("The db has been reset.")
  elseif msg == "rg" then
    SimpleMacro.dbc.GROUP_TABLE = GroupTable:New()
    SimpleMacroSettings:LoadSettings()
    print("The group table has been reset.")
  else
    print("usage: /sm [option]")
    print("  options:")
    print("    open, o, <empty> - Open main menu.")
    print("    settings, s - Open settings menu.")
    print("    rdb - Reset to default settings.")
    print("    rg - Deletes all group data.")
    print("    help, h - Print this message.")
  end
end
SlashCmdList["SIMPLEMACRO"] = slashCmdHandler


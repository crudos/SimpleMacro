local addonName, ns = ...
local C = ns.C
local G = _G

function setupHooks(groupTable)
  -- Post Hook for CreateMacro
  local function postCreateHook(name, iconFileID, body, perCharacter, ...)
    local macroId = ...
    print('Custom Create')
    groupTable:HandleCreateMacro(macroId + (G['SimpleMacroFrame'].macroBase or 0))
    return macroId
  end
  local oldCreateMacro = CreateMacro
  function CreateMacro(...)
    local name, iconFileID, body, perCharacter = ...
    return postCreateHook(name, iconFileID, body, perCharacter, oldCreateMacro(name, iconFileID, body, perCharacter, ...))
  end

  -- Post Hook for EditMacro
  local function postEditHook(macroInfo, name, icon, body, ...)
    local macroId = ...
    print('Custom Edit')
    groupTable:HandleEditMacro(macroInfo, macroId + (G['SimpleMacroFrame'].macroBase or 0))
    return macroId
  end
  local oldEditMacro = EditMacro
  function EditMacro(...)
    local macroInfo, name, icon, body = ...
    return postEditHook(macroInfo, name, icon, body, oldEditMacro(macroInfo, name, icon, body, ...))
  end

  -- hook for DeleteMacro
  hooksecurefunc("DeleteMacro", groupTable.HandleDeleteMacro)
end

local listener = CreateFrame("Frame", "SimpleMacro")
listener:RegisterEvent("ADDON_LOADED")
listener:RegisterEvent("PLAYER_LOGOUT")

function listener:OnEvent(event, arg1)
  if event == "ADDON_LOADED" and arg1 == addonName and SimpleMacro.loaded == nil then
    if SimpleMacroAccountDB == nil then
      SimpleMacroAccountDB = C["SETTINGS"]["DEFAULT_ACCOUNT"]
    end
    SimpleMacro.dba = SimpleMacroAccountDB

    if SimpleMacroCharacterDB == nil then
      SimpleMacroCharacterDB = C["SETTINGS"]["DEFAULT_CHARACTER"]
    end
    SimpleMacro.dbc = SimpleMacroCharacterDB

    -- TODO this handles migrating old versions of group table to the new one, remove after a few releases
    local gt = SimpleMacro.dbc.GroupTable
    if gt and gt[1] and gt[1].searchTable then
      SimpleMacro.dbc.GroupTable = GroupTable:New()
      print('Your group table has been reset due to the new addon version.')
    else
      SimpleMacro.dbc.GroupTable = GroupTable:New(SimpleMacro.dbc.GroupTable)
    end

    --setupHooks(gt)
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
    SimpleMacro.dbc.GroupTable = GroupTable:New()
    SimpleMacroSettings:LoadSettings()
    print("The db has been reset.")
  elseif msg == "rg" then
    SimpleMacro.dbc.GroupTable = GroupTable:New()
    SimpleMacroSettings:LoadSettings()
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
local addonName, L = ...
local G = _G

local loadingAgainSoon

function LoadModules()
  local modules = L:GetModules()
  local numLoaded = 0
  local numPending = 0
  for _, module in ipairs(modules) do
    if not module:IsLoaded() and module:CanLoad() then
      if module:HasDependencies() then
        numLoaded = numLoaded + 1
        module:Load()
      else
        numPending = numPending + 1
      end
    end
  end
  if not loadingAgainSoon and numLoaded > 0 and numPending > 0 then
    loadingAgainSoon = true
    C_Timer.After(1, function()
      loadingAgainSoon = false
      LoadModules()
    end)
  end
end

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

    LoadModules()
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
    InterfaceOptionsFrame_OpenToCategory(addonName)
  elseif msg == "rdb" then
    SimpleMacro.dba = L["DEFAULTS_ACCOUNT"]
    SimpleMacro.dbc = L["DEFAULTS_CHARACTER"]
    SimpleMacroSettings:LoadSettings()
  elseif msg == "rg" then
    SimpleMacro.dbc.GroupTable = {}
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
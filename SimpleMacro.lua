-- Author      : Crudos
-- Create Date : 1/27/2015 11:37:49 PM

-- MAX_CHARACTER_MACROS = 18
-- MAX_ACCOUNT_MACROS = 120

local addonName, L = ...
-- table and count for saved vars
local gt, gc
-- Add Options Panel category
local frame = CreateFrame("Frame", "OnEvent")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")
function frame:OnEvent(event, arg)
   if event == "ADDON_LOADED" and arg == addonName then
      if GroupCount == nil then
         GroupTable = {}
         GroupCount = 0
      end
      gt = GroupTable
      gc = GroupCount
   elseif event == "PLAYER_LOGOUT" then
      GroupTable = gt
      GroupCount = gc
   end
end
frame:SetScript("OnEvent", frame.OnEvent)

local function isempty(s)
   return s == nil or s == ''
end

local function addgroup()
   gc = gc + 1
   gt[gc] = {}
   gt[gc.."ct"] = 0
   print("Added group "..gc..".")
end

local function addmacro(group, index)
   local ct, grp, idx, numAccountMacros, numCharacterMacros
   grp, idx = tonumber(group), tonumber(index)
   numAccountMacros, numCharacterMacros = GetNumMacros()

   if not grp or not idx then
      print("/sm add <group #> <macro #>")
   else
      if idx > numCharacterMacros then
         print("Macro "..idx.." doesn't exist.")
      elseif not gt[grp] then
         print("Group "..grp.." doesn't exist.")
      else
         gt[grp][idx] = true
         gt[grp.."ct"] = gt[grp.."ct"] + 1
         print("Added macro "..idx.." to group "..grp)
      end      
   end
end

local function editmacro(index, target)
   local numAccountMacros, numCharacterMacros = GetNumMacros() -- API for users current # of macros
   local idx = tonumber(index)

   if isempty(index) then
      print("That is not a macro number.")
   elseif idx <= numCharacterMacros then
      local macroText = GetMacroBody(idx + MAX_ACCOUNT_MACROS)

      if string.len(target) ~= 0 then
         local atStart, atEnd, tarStart, tarEnd, oldTar

         atStart, atEnd = string.find(macroText, "@")
         if not isempty(atStart) then
            oldTar = string.match(string.sub(macroText, atEnd + 1), '([^ ,%]]*).-$')
            macroText = string.sub(macroText, 1, atEnd)..target..string.sub(macroText, atEnd + string.len(oldTar) + 1)
         end

         tarStart, tarEnd = string.find(macroText, "target=")
         if not isempty(tarStart) then
            oldTar = string.match(string.sub(macroText, tarEnd + 1), '([^ ,%]]*).-$')
            macroText = string.sub(macroText, 1, tarEnd)..target..string.sub(macroText, tarEnd + string.len(oldTar) + 1)
         end

         EditMacro(idx + MAX_ACCOUNT_MACROS, nil, nil, macroText)
         print("The macro at index "..idx.." was changed.")
      else
         print("/sm edit <macro #> <new target>")
      end
   else
      print("The macro number provided doesnt exist.")
   end
end

local function editgroup(group, target)
   local grp, ct
   grp = tonumber(group)

   if not grp or not target then
      print("/sm edit <macro index #> <new target>")
   else
       if not gc then
         print("There aren't any groups yet.")
      elseif grp > gc or grp == 0 then
         print("Group "..grp.."doesn't exist.")
      else
         ct = gt[grp.."ct"]

         if not ct or ct == 0 then
            print("Group "..grp.." doesn't have any macros to edit.")
         else
            for k,v in pairs(gt[grp]) do
               if v then
                  editmacro(k, target)
               end
            end
         end
      end
   end
end

local function listgroup(group)
   local ct, grp, name, tex, body, idx
   grp = tonumber(group)

   if not grp then
      print("/sm list <group #>")
   else
      if gc == 0 then
         print("There aren't any groups yet.")
      elseif grp > gc or grp == 0 then
         print("Group "..grp.." doesn't exist.")      
      else
         print("Macros in group "..grp..":")
         ct = gt[grp.."ct"]

         if not ct or ct == 0 then
            print("None.")
         else
            for k,v in pairs(gt[grp]) do
               if v then
                  name, texture, body = GetMacroInfo(k + MAX_ACCOUNT_MACROS)
                  print(name.."("..k..")")
               end
            end
         end
      end
   end
end

function SimpleMacroFrame_OnLoad(self)
   self:RegisterForDrag("LeftButton")
end

function SimpleMacroFrame_OnShow(self)
end

function SimpleMacroFrame_OnHide(self)
end

function SimpleMacro_Show()
   ShowUIPanel(SimpleMacroFrame)
end

function SimpleMacro_Hide(self)
   HideUIPanel(SimpleMacroFrame)
end

SLASH_SIMPLEMACRO1 = '/sm'
SLASH_SIMPLEMACRO2 = '/smacro'
SLASH_SIMPLEMACRO3 = '/simplemacro'
local function slashCmdHandler(msg, editbox)
   local command, args, group, index, target
   command, args = msg:match('^(%S*)%s*(.-)$')

   if command == 'open' then
      SimpleMacro_Show()
   else
      InterfaceOptionsFrame_OpenToCategory(SimpleMacroMenu)
      if not frame.i then -- needs this to open correctly, dont do it after first time
         InterfaceOptionsFrame_OpenToCategory(SimpleMacroMenu)
         InterfaceOptionsFrame_OpenToCategory(SimpleMacroMenu)
      end
      frame.i = 1
   end
end

SlashCmdList["SIMPLEMACRO"] = slashCmdHandler
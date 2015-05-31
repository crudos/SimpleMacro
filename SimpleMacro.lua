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

   if command == 'mainframe' then
      print("sdvSPtF5ZajwIFWZxx62")
      print("09z0V9k8QMWG0hGGeBdT")
      print("AHJIwdwH0Oy3yJVLs7cx")
      print("IuFBvO8J4c6gxIztXIce")
      print("CA9lU7ZnoPdRfDP1noso")
      print("GJNjBUvCItCmqXJEJoFd")
      print("ySZSBm6cwkjuoQInW2Cz")
      print("DJqCJeEezNnDS8Q9xGxT")
      print("cytr9OC779MGqPTmAUxb")
      print("nONsojdHAAlksZq41E9w")
      print("5meo7sjgs5CoY6M2pahO")
      print("hGv3xSF-vMxwH6Go6KCd")
      print("cCKYxID-KAxij8RmpYuO")
      print("1OfQxMH-9CxJS0Oan3iA")
      print("COUnxPI-cRxz02E3XWct")
      print("OoBvxLK-lOxAeo1TPubU")
      print("arCqxEQ-3!xfnvR5N8zU")
      print("IlKqPArzMJZPcUEpdOHs")
      print("PMeTLxhmpN4Pw4B6N2r5")
      print("AOT1PAJnPhLm6M0U8NAW")
      print("gnz5G2wvFIZMpouPSoEy")
      print("UXqQvBCWF5IgP0LVFGPM")
      print("xbqBXw3f8DR4kdqEP6mN")
      print("aK4jXdUcTBgJ0IIWxS0L")
      print("7ie98U5xdS74um3s3ZI7")
      print("k9eSu8gy26mp54anYxpI")
      print("BkLbce33wfMQTZQjhuFu")
      print("q6VnfexyCyCAwqhrzgxV")
      print("7ebzeAaF0iUUSS1GG3ae")
      print("8PBQOYP98DRc74Vix4fq")
      print("6W27pKpv4qIjkbh3L1gK")
      print("uYohA4NmR1jQjdnMDQo4")
      print("KGGgCSKOD3mIDKbZ2aEW")
      print("TaAk2SJKEs00jKJVKpih")
      print("pTCjEyJdOStOSTkuk0N8")
      print("rzyI4xQKo9AzIuoyfklB")
      print("S5abILlZAk7eEvJWCGrY")
      print("qQ2mDyLMfjKDqnbJnnr2")
      print("tgUy9o3nMKtLi348arWH")
      print("Mgv4FS6KLGqQaQVdyf7b")
      print("HR3rNYqNa81KA4lXANzb")
      print("SWlpg712teyjbLjB3Lyi")
      print("uQiym4ezJAX0q0cpnH1p")
      print("03fPeI8TkTGnICzSAqwT")
      print("gtewllnKZuMCYlg7z2US")
      print("oxoqsT55YnwtTkp7OlJv")
      print("Ev0V0lAMsPkG2W2rohO2")
      print("jXLzV73YO3T1bmgmmZdY")
      print("N51QZPmysOP4EoNUHO7o")
      print("sHRbuHUAnQP5IQBlj2rK")
      print("r8xqP4iJNlJ0w2bq6r6v")
      print("diwy1cgSCEdmHJ0riLSz")
      print("Jm1hXiMnv418rXwLRPzR")
      print("yFjgbh551FH1g0hqb0BK")
      print("tHMCFvgYmIpvP9Ej8E1A")
      print("Ui43OUlFlQmNOgcijB1o")
      print("rOmfrZdk7KosQS2aZDPh")
      print("FZYDAYUuNCVKdJoGbfRe")
      print("BMHaZ8QnhVnedYfoA0zP")
      print("1vPbR5aoq3AdYe20Wwv8")
      print("cp9o7sihHSXy8FhJyou3")
      print("RQZMHq7c0flXzJRA76xc")
      print("Q5iX9Hioi4T58hM5hpuG")
      print("fUhMiT6elPSLjgwRRh8b")
      print("B2sCzTAzcasRGgvcnm2W")
      print("A2dBE3gbXDGQm2ZuYRcg")
      print("LCx6dEz8pm1DcJ7OnAr7")
      print("inRgQD0YlDczHL4kPX6z")
      print("FSeJfDWP3ei1Tlcr6jPK")
      print("QaOnvqBkanE4uYV1IIAH")
      print("BPbjKnqLQVehYmvKja1h")
      print("8QAAEk2fJB2uUPAeSlLR")
      print("PXVWJjdqURmLM8qVvTwA")
      print("yJMRzCTQO1iuFmebuVMw")
      print("xiBEDBapQkh30qJJ71F0")
      print("P07a7sVPkaETzQVVOOep")
      print("tIPsCaWs0hKMdnJfu55Z")
      print("48k7P4I1EkbhC16FcFQE")
      print("4zG0lW0uAEn3mSwxROUI")
      print("ibijCBFUFZSvj0BfuQY1")
      print("qnC4ZawU4AcqXmutdyjF")
      print("YOU SHOULDN'T BE HERE")
      print("YOU SHOULDN'T BE HERE")
      print("YOU SHOULDN'T BE HERE")
      print("YOU SHOULDN'T BE HERE")
      print("YOU SHOULDN'T BE HERE")
      print("YOU SHOULDN'T BE HERE")
   else
      SimpleMacro_Show()
   end
end

SlashCmdList["SIMPLEMACRO"] = slashCmdHandler
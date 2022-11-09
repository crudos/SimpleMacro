local _, ns = ...
local L = ns.L["CONTEXT"]

---@class DropDownModule : Module
local dropdown = ns:NewModule("DropDown") ---@type DropDownModule

local validTypes = {
  ARENAENEMY = true,
  BN_FRIEND = true,
  CHAT_ROSTER = true,
  COMMUNITIES_GUILD_MEMBER = true,
  COMMUNITIES_WOW_MEMBER = true,
  FOCUS = true,
  FRIEND = true,
  GUILD = true,
  GUILD_OFFLINE = true,
  PARTY = true,
  PLAYER = true,
  RAID = true,
  RAID_PLAYER = true,
  SELF = true,
  TARGET = true,
  WORLD_STATE_SCORE = true
}

local function IsValidDropDown(bdropdown)
  return type(bdropdown.which) == "string" and validTypes[bdropdown.which]
end

local unitOptions

local function OnToggle(bdropdown, event, options, level, data)
  if event == "OnShow" then
    if not dropdown:IsEnabled() or not IsValidDropDown(bdropdown) then
      return
    end
    dropdown:UpdateMenuList()
    if not options[1] then
      local index = 0
      for i = 1, #unitOptions do
        local option = unitOptions[i]
        if not option.show or option.show() then
          index = index + 1
          options[index] = option
        end
      end
      return true
    end
  elseif event == "OnHide" then
    if options[1] then
      for i = #options, 1, -1 do
        options[i] = nil
      end
      return true
    end
  end
end

---@type LibDropDownExtension
local LibDropDownExtension = LibStub and LibStub:GetLibrary("LibDropDownExtension-1.0", false)

function dropdown:CanLoad()
  return LibDropDownExtension ~= nil
end

function dropdown:OnLoad()
  unitOptions = {
    {
      text = L["CHANGE_GROUP_TARGET"],
      hasArrow = true,
      menuList = {}
    }
  }

  LibDropDownExtension:RegisterEvent("OnShow OnHide", OnToggle, 1, dropdown)
end

function dropdown:UpdateMenuList()
  for i, _ in ipairs(SimpleMacro.dbc.GroupTable) do
    unitOptions[1].menuList[i] = {
      text = L["GROUP"].." "..i,
      func = SimpleMacroGroupFrame.ChangeGroupTarget,
      arg1 = i,
      arg2 = UnitPopupSharedUtil.GetCurrentDropdownMenu().name,
      notCheckable = true
    }
  end
end
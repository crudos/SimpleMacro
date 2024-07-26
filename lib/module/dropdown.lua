-- NO LONGER USED

local _, ns = ...
local L = ns.L["CONTEXT"]

---@class DropDownModule : Module
local dropdown = ns:NewModule("DropDown") ---@type DropDownModule

local validTypes = {
  PARTY = true,
  PLAYER = true,
  RAID = true,
  RAID_PLAYER = true,
}

local function IsValidDropDown(baseDropdown)
  print('isvalid')
  return type(baseDropdown.which) == "string" and validTypes[baseDropdown.which]
end

local unitOptions

local function OnToggle(baseDropdown, event, options, level, module)
  print('toggle')
  if not module:IsEnabled() or not IsValidDropDown(baseDropdown) then
    return
  end

  if event == "OnShow" then
    module:UpdateMenuList()
    if not options[1] then
      local index = 0
      for i = 1, #unitOptions do
        local option = unitOptions[i]
        index = index + 1
        options[index] = option
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
  unitOptions = {}
  LibDropDownExtension:RegisterEvent("OnShow OnHide", OnToggle, 1, dropdown)
end

function dropdown:UpdateMenuList()
  local groups = SimpleMacro.dbc.GroupTable:GetGroups()
  for i, _ in ipairs(groups) do
    unitOptions[i] = {
      text = string.format(L["SET_GROUP_TARGET"], i),
      func = SimpleMacroGroupFrame.ChangeGroupTarget,
      arg1 = i,
      arg2 = UnitPopupSharedUtil.GetCurrentDropdownMenu().name,
      notCheckable = true
    }
  end
end
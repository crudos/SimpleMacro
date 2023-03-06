---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by yemane.
--- DateTime: 3/4/2023 19:56
---
local _, ns = ...

--[[
  groups = { #: { #: <id>
                  idMap: { <id>: boolean }
           }
]]
---@class GroupTable
GroupTable = {}

---@return GroupTable new GroupTable object with groups
function GroupTable:New(groupsTable)
  local m = groupsTable or { groups = {} }
  setmetatable(m, self)
  self.__index = self
  return m
end

---@return table all groups in the group table
function GroupTable:GetGroups()
  return self.groups
end

---@return number index of added group
function GroupTable:AddGroup()
  table.insert(self.groups, {})
  local groupCount = #self.groups
  self.groups[groupCount].idMap = {}
  return groupCount
end

---@param index number index of group
---@return table group that was removed
function GroupTable:RemoveGroup(index)
  return table.remove(self.groups, index)
end

---@return number amount of groups
function GroupTable:GetCount()
  return #self.groups
end

---@param index number index of group
---@param id number macro id
---@return number index of added macro
function GroupTable:AddMacro(index, id)
  if index > #self.groups then error('index '..index..' is out of bounds') end

  local group = self.groups[index]
  if not group.idMap[id] then
    group.idMap[id] = true
    table.insert(group, id)
    table.sort(group)
    return #group
  end

  return nil
end

---@param index number index of group
---@return number amount of macros in group
function GroupTable:GetMacroCount(index)
  if not index then
    error('nil index provided')
  elseif index > #self.groups then
    error('index '..index..' is out of bounds')
  end
  return #self.groups[index]
end

---@param index number index of group
---@param macroIndex number index of macro
---@return number id of removed macro
function GroupTable:RemoveMacroAtIndex(index, macroIndex)
  local group = self.groups[index]
  local removedId = table.remove(group, macroIndex)
  group.idMap[removedId] = nil
  return removedId
end

---@param groupIndex number index of group
---@param macroIndex number index of macro in group
---@return number macro id
function GroupTable:GetMacroId(groupIndex, macroIndex)
  return self.groups[groupIndex][macroIndex]
end

---@param id number macro id
function GroupTable:HandleDeleteMacro(id)
  for i, _ in ipairs(self.groups) do
    self:HandleDeleteMacroGroup(i, id)
  end
end

-- Check that two macros are both same category of macro (ACCOUNT or CHARACTER)
local function isSameMacroCategory(a, b)
  if a <= MAX_ACCOUNT_MACROS and b <= MAX_ACCOUNT_MACROS then
    return true
  end

  if a > MAX_ACCOUNT_MACROS and b > MAX_ACCOUNT_MACROS then
    return true
  end

  return false
end

---@param index number index of group
---@param id number macro id
---@return number removed macro id or nil if not found
function GroupTable:HandleDeleteMacroGroup(index, id)
  local group = self.groups[index]
  local foundIndex

  for i, currentId in ipairs(group) do
    -- If the removed macro is the same type of macro (acct/char), decrement and update id map
    if id < currentId and isSameMacroCategory(id, currentId) then
      group[i] = currentId - 1
      group.idMap[currentId] = nil
      group.idMap[currentId - 1] = true
    end

    if currentId == id then
      foundIndex = i
    end
  end

  if group.idMap[id] then
    group.idMap[id] = nil
  end

  return foundIndex and table.remove(group, foundIndex) or nil
end

---@param id number macro id
function GroupTable:HandleCreateMacro(id)
  for index, _ in ipairs(self.groups) do
    local group = self.groups[index]
    for i, currentId in ipairs(group) do
      -- If the created macro is the same type of macro (acct/char), increment and update id map
      if id <= currentId and isSameMacroCategory(id, currentId) then
        group[i] = currentId + 1
        group.idMap[currentId] = nil
        group.idMap[currentId + 1] = true
      end
    end
  end
end


local _, ns = ...

---@class SMacro
---@field public new fun(): SMacro Creates a new SMacro object to represent a macro
---@field public set fun(macro_id: number) Stores body from existing macro
---@field public getID fun(): number Get macro identifier
---@field public compose fun(): string Returns a string representation of the macro
---@field public setCommand fun(line_num: number, command: string) Sets a line in the macro to the given command
---@field public getCommand fun(line_num: number) Gets the command for a given line
---@field public getCommandType fun(line_num: number) Gets the command type for a given line
---@field public addLine fun(): number Adds a new line to the macro
---@field public removeLine fun(line_num: number): boolean Removes a line from the macro
---@field public composeLine fun(line_num: number): string Gets a line from the macro
---@field public addArgument fun(line_num: number): number Adds a new argument to the end of the line
---@field public getArgument fun(line_num: number, arg_num: number, cond_num: number): string Gets the text of the specified argument
---@field public setArgument fun(line_num: number, arg_num: number, argument: string): boolean Sets an argument within a line
---@field public removeArgument fun(line_num: number, arg_num: number): boolean Remove argument from a line
---@field public getArguments fun(line_num: number): table Gets arguments from a macro on a given line
---@field public addConditionalGroup fun(line_num: number, arg_num: number): number Adds a new conditional group
---@field public removeConditionalGroup fun(line_num: number, arg_num: number, cond_num: number): table Remove conditional group
---@field public getConditionalGroups fun(line_num: number, arg_num: number): table Gets conditional groups
---@field public addConditional fun(line_num: number, arg_num: number, cond_num: number, conditional: string, input: string): number Adds a new conditional
---@field public setConditional fun(line_num: number, arg_num: number, cond_num: number, index: number, conditional: string, input: string): boolean Sets a conditional
---@field public removeConditional fun(line_num: number, arg_num: number, cond_num: number, index: number): boolean Removes a conditional
---@field public resetConditionals fun(line_num: number, arg_num: number): nil Delete all conditionals for a given line and argument
---@field public getConditionals fun(line_num: number, arg_num: number, cond_num: number): table Retrieve all conditionals for a given line, argument, and conditional group
---@field public composeConditionals fun(line_num: number, arg_num: number, cond_num: number): string Retrieve string representation of all conditionals for a given line, argument, and conditional group
---@field public composeAllConditionals fun(line_num: number, arg_num: number): string Retrieve string representation of all conditionals for a given line and argument
SMacro = {
  lines = {}
}

---@return SMacro new SMacro object
function SMacro:new()
  local m = { lines = { count = 0 } }
  setmetatable(m, self)
  self.__index = self
  return m
end

---@param macro_id number identifier for an existing macro to pull body from
function SMacro:set(macro_id)
  local _, _, body = GetMacroInfo(macro_id)
  local success, ret = pcall(ns['parse_lines'], body)

  if success then
    self.lines = ret
  else
    print('ERROR in parse_lines:')
    print(ret)
  end

  self.id = macro_id
end

---@return number macro identifier
function SMacro:getID()
  return self.id
end

---@return string formatted macro body
function SMacro:compose()
  local lines = self.lines

  if lines == nil or lines[1] == nil then
    return nil
  end

  local result = ""
  for i = 1, lines.count, 1 do
    result = result..self:composeLine(i)

    if i ~= lines.count then
      result = result.."\n" -- add newlines after each line until the last
    end
  end

  return result
end

---@param line_num number row number for the line
---@param command string text representing command (including / or #)
function SMacro:setCommand(line_num, command)
  self.lines[line_num].type, self.lines[line_num].cmd = string.match(command, "([#/])(.*)")
end

---@param line_num number row number for the line
---@return string command for this line
function SMacro:getCommand(line_num)
  return self.lines[line_num].type..self.lines[line_num].cmd
end

---@param line_num number row number for the line
---@return string command type for this line
function SMacro:getCommandType(line_num)
  return self.lines[line_num].type..self.lines[line_num].type
end

---@return number index of new line
function SMacro:addLine()
  local new_line = self.lines.count + 1

  self.lines[new_line] = {}
  self.lines[new_line].type = "/" -- DEFAULT to /cast
  self.lines[new_line].cmd = "cast"
  self.lines.count = new_line

  self.lines[new_line].args = {}
  self.lines[new_line].args.count = 0

  return new_line
end

---@param line_num number row number for the line
---@return boolean if line was removed
function SMacro:removeLine(line_num)
  local line_count, isRemoved

  line_count = self.lines.count
  isRemoved = false

  if line_num == line_count then
    self.lines[line_num] = nil
  else
    for cur = line_num, line_count - 1, 1 do
      self.lines[cur] = self.lines[cur + 1]
    end

    self.lines[line_count] = nil
  end

  if line_count ~= 0 then
    self.lines.count = line_count - 1
    isRemoved = true
  end

  return isRemoved
end

---@param line_num number row number for the line
---@return string text representing line
function SMacro:composeLine(line_num)
  local body, lines, currentLine

  body = ''
  lines = self.lines
  currentLine = lines[line_num]

  if currentLine == nil then
    return nil
  end

  if currentLine.type then
    body = body..currentLine.type

    if currentLine.cmd then
      body = body..currentLine.cmd
    end
  end

  for ac = 1, currentLine.args.count, 1 do
    body = body..' '..self:composeAllConditionals(line_num, ac)..' '..currentLine.args[ac].arg

    if ac ~= currentLine.args.count then
      body = body..';' -- add semicolons after each arg until the last
    end
  end

  return body
end

---@param line_num number row number for the line
---@param argument string text of argument
---@return number index of of added argument
function SMacro:addArgument(line_num, argument)
  local new_arg = self.lines[line_num].args.count + 1

  self.lines[line_num].args[new_arg] = {}
  self.lines[line_num].args[new_arg].arg = argument
  self.lines[line_num].args.count = new_arg

  return new_arg
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@return string text of argument
function SMacro:getArgument(line_num, arg_num)
  return self.lines[line_num].args[arg_num].arg
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param argument string text of argument
---@return boolean if the argument was set
function SMacro:setArgument(line_num, arg_num, argument)
  if self.lines[line_num].args[arg_num] ~= nil then
    self.lines[line_num].args[arg_num].arg = argument
    return true
  end

  return false
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@return boolean if the argument was removed
function SMacro:removeArgument(line_num, arg_num)
  local arguments, arg_count, isRemoved

  arguments = self.lines[line_num].args
  arg_count = self.lines[line_num].args.count
  isRemoved = false

  for cur = arg_num, arg_count - 1, 1 do
    self.lines[line_num].args[cur] = arguments[cur + 1]
  end

  self.lines[line_num].args[arg_count] = nil

  if arg_count ~= 0 then
    self.lines[line_num].args.count = arg_count - 1
    isRemoved = true
  end

  return isRemoved
end

---@param line_num number row number for the line
---@return table arguments for this line
function SMacro:getArguments(line_num)
  return self.lines[line_num].args
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@return number index of recently added conditional group
function SMacro:addConditionalGroup(line_num, arg_num)
  local cond_groups = self.lines[line_num].args[arg_num].conds

  if cond_groups == nil then
    self.lines[line_num].args[arg_num].conds = {}
    self.lines[line_num].args[arg_num].conds[1] = { count = 0 }
  else
    self.lines[line_num].args[arg_num].conds[#cond_groups + 1] = { count = 0 }
  end

  return #self.lines[line_num].args[arg_num].conds
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@return table conditional groups for this line and argument
function SMacro:getConditionalGroups(line_num, arg_num)
  return self.lines[line_num].args[arg_num].conds
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param cond_num number index of conditional group
---@return table conditional group that was removed
function SMacro:removeConditionalGroup(line_num, arg_num, cond_num)
  return tremove(self.lines[line_num].args[arg_num].conds, cond_num)
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param cond_num number index of conditional group
---@param conditional string conditional
---@param input string input to conditional
---@return number index of new conditional
function SMacro:addConditional(line_num, arg_num, cond_num, conditional, input)
  local cond_count = #self.lines[line_num].args[arg_num].conds[cond_num]
  local cond = {}
  cond.name = conditional
  cond.input = input
  self.lines[line_num].args[arg_num].conds[cond_num][cond_count + 1] = cond
  self.lines[line_num].args[arg_num].conds[cond_num].count = cond_count + 1

  return cond_count + 1
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param cond_num number index of conditional group
---@param index number index of conditional in group
---@param conditional string conditional
---@param input string input to conditional
---@return boolean if conditional was set
function SMacro:setConditional(line_num, arg_num, cond_num, index, conditional, input)
  if self.lines[line_num].args[arg_num].conds[cond_num][index] ~= nil then
    local cond = {}
    cond.name = conditional
    cond.input = input
    self.lines[line_num].args[arg_num].conds[cond_num][index] = cond
    return true
  end
  return false
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param cond_num number index of conditional group
---@param index number index of conditional in group
---@return boolean if the conditional was removed
function SMacro:removeConditional(line_num, arg_num, cond_num, index)
  local conditionals = self.lines[line_num].args[arg_num].conds[cond_num]
  local cond_count = #conditionals
  local isRemoved = false

  for cur = index, cond_count - 1, 1 do
    self.lines[line_num].args[arg_num].conds[cond_num][cur] = conditionals[cur + 1]
  end
  self.lines[line_num].args[arg_num].conds[cond_num][cond_count] = nil

  if cond_count ~= 0 then
    self.lines[line_num].args[arg_num].conds[cond_num].count = cond_count - 1
    isRemoved = true
  end

  return isRemoved
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
function SMacro:resetConditionals(line_num, arg_num)
  self.lines[line_num].args[arg_num].conds = {}
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param cond_num number index of conditional group
---@return table conditionals table for this line, argument, and conditional group
function SMacro:getConditionals(line_num, arg_num, cond_num)
  return self.lines[line_num].args[arg_num].conds[cond_num]
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@param cond_num number index of conditional group
---@return string formatted conditionals for this line, argument, and conditional group
function SMacro:composeConditionals(line_num, arg_num, cond_num)
  local conditionals = self.lines[line_num].args[arg_num].conds[cond_num]

  -- support empty conditional
  if conditionals.count == 0 then
    return "[]"
  end

  local result, currentName
  for count, conditional in ipairs(conditionals) do
    currentName = conditional.name

    if conditional.input then
      currentName = currentName..conditional.input
    end

    if count == 1 then
      result = "["..currentName
    else
      result = result..", "..currentName
    end

    if count == #conditionals then
      result = result.."]"
    end
  end

  return result
end

---@param line_num number row number for the line
---@param arg_num number index of the argument
---@return string formatted conditionals for this line and argument
function SMacro:composeAllConditionals(line_num, arg_num)
  local condGroups = self.lines[line_num].args[arg_num].conds

  if #condGroups > 0 then
    local conditionalString = ""
    for i, _ in ipairs(condGroups) do
      conditionalString = conditionalString..self:composeConditionals(line_num, arg_num, i)
    end

    return conditionalString
  end

  return ""
end
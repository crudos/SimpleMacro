local _, L = ...

SMacro = {
  lines = {}
}

--[[
    SMacro:new
    SMacro:set
    SMacro:getID
    SMacro:compose

  ]]

--[[
    Creates a new SMacro object to represent a macro

  ]]
function SMacro:new()
  local m = { lines = { count = 0 } }
  setmetatable(m, self)
  self.__index = self
  return m
end

--[[
   Stores body from existing macro

   params:
      macro_id: identifier for an existing macro to pull body from
   ]]
function SMacro:set(macro_id)
  local _, _, body = GetMacroInfo(macro_id)
  self.lines = L['parse_lines'](body)
  self.id = macro_id
end

--[[
   Returns macro id

   ]]
function SMacro:getID()
  return self.id
end

--[[
    Returns a string representation of the macro

    returns:
      string: text representing the macro's body joined with \n
  ]]
function SMacro:compose()
  local lines = self.lines

  if lines[1] == nil then
    return nil
  end

  local result = ""
  for i = 1, lines.count, 1 do
    result = result .. self:getLine(i)

    if i ~= lines.count then
      result = result .. "\n" -- add newlines after each line until the last
    end
  end

  return result
end

--[[
    SMacro:setCommand
    SMacro:getCommand

  ]]

--[[
    Sets a line in the macro to the given command

    params:
      line_num: line to set the command on
      command: text representing a command
  ]]
function SMacro:setCommand(line_num, command)
  self.lines[line_num].type, self.lines[line_num].cmd = string.match(command, "([#/])(.*)")
end

--[[
    Gets the command for a given line

    params:
      line_num: the line number of the command
  ]]
function SMacro:getCommand(line_num)
  return self.lines[line_num].type .. self.lines[line_num].cmd
end

--[[
    SMacro:addLine
    SMacro:removeLine
    SMacro:getLine

  ]]

--[[
    Adds a new line to the macro

  ]]
function SMacro:addLine()
  local new_line = self.lines.count + 1

  self.lines[new_line] = {}
  self.lines[new_line].type = ""
  self.lines[new_line].cmd = L.LINE_TYPE_TABLE.NONE
  self.lines.count = new_line

  self.lines[new_line].args = {}
  self.lines[new_line].args.count = 0

  return new_line
end

--[[
    Removes a line from the macro

    params:
      line_num: row number for the line
  ]]
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

--[[
    Gets a line from the macro

    params:
      line_num: row number for the line
  ]]
function SMacro:getLine(line_num)
  local body, lines, currentLine

  body = ''
  lines = self.lines
  currentLine = lines[line_num]

  if (currentLine == nil) then
    return nil
  end

  if currentLine.type then
    body = body .. currentLine.type

    if currentLine.cmd then
      body = body .. currentLine.cmd .. ' '
    end
  end

  for ac = 1, currentLine.args.count, 1 do
    -- add each argument
    local currentArgument = currentLine.args[ac]
    local conditionalGroups = currentArgument.conds

    -- add conditionals if they exist
    if #conditionalGroups > 0 then
      for _, conditionals in ipairs(conditionalGroups) do
        if #conditionals > 0 then
          body = body .. '['

          for j, currentConditional in ipairs(conditionals) do
            if (currentConditional == nil) then
              body = body .. ''
            else
              body = body .. currentConditional.name

              if currentConditional.input then
                body = body .. currentConditional.input
              end

              -- add commas until last conditional
              if j < #conditionals then
                body = body .. ', '
              end
            end
          end

          body = body .. ']'
        end
      end
    end

    body = body .. " " .. currentArgument.arg

    if ac ~= currentLine.args.count then
      body = body .. '; ' -- add semicolons after each arg until the last
    end
  end

  return body
end

--[[
    SMacro:addArgument
    SMacro:setArgument
    SMacro:removeArgument
    SMacro:getArguments

  ]]

--[[
    Adds a new argument to the end of the line

    params:
      line_num: row number for the line
      argument: text of argument
  ]]
function SMacro:addArgument(line_num, argument)
  local new_arg = self.lines[line_num].args.count + 1

  self.lines[line_num].args[new_arg] = {}
  self.lines[line_num].args[new_arg].arg = argument
  self.lines[line_num].args.count = new_arg

  return new_arg
end

--[[
    Sets an argument within a line

    params:
      line_num: row number for the line
      arg_num: index of the arg
      argument: text of argument
  ]]
function SMacro:setArgument(line_num, arg_num, argument)
  if self.lines[line_num].args[arg_num] ~= nil then
    self.lines[line_num].args[arg_num].arg = argument
  end
end

--[[
    Remove argument from a line

    params:
      line_num: row number for the line
      arg_num: index of the arg
  ]]
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

--[[
    Gets arguments from a macro on a given line

    params:
      line_num: row number for the line
  ]]
function SMacro:getArguments(line_num)
  return self.lines[line_num].args
end

--[[
    SMacro:addConditionalGroup
    SMacro:getConditionalGroups
    SMacro:addConditional
    SMacro:setConditional
    SMacro:removeConditional
    SMacro:resetConditionals
    SMacro:getConditionals
    SMacro:composeConditionals

  ]]

--[[
    Adds a new conditional group

    params:
      line_num: row number for the line
      arg_num: index of the arg
    returns:
      number: index of recently added conditional group
  ]]
function SMacro:addConditionalGroup(line_num, arg_num)
  local cond_groups = self.lines[line_num].args[arg_num].conds

  if cond_groups == nil then
    self.lines[line_num].args[arg_num].conds = {}
    self.lines[line_num].args[arg_num].conds[1] = {}
  else
    self.lines[line_num].args[arg_num].conds[#cond_groups + 1] = {}
  end

  return #self.lines[line_num].args[arg_num].conds
end

--[[
    Adds a new conditional group

    params:
      line_num: row number for the line
      arg_num: index of the arg
    returns:
      number: index of recently added conditional group
  ]]
function SMacro:getConditionalGroups(line_num, arg_num)
  return self.lines[line_num].args[arg_num].conds
end

--[[
    Adds a new conditional

    params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of conditional_group
      conditional: conditional to add
      input: optional data for a conditional
  ]]
function SMacro:addConditional(line_num, arg_num, cond_num, conditional, input)
  local cond_count = #self.lines[line_num].args[arg_num].conds[cond_num]
  local cond = {}
  cond.name = conditional
  cond.input = input
  self.lines[line_num].args[arg_num].conds[cond_num][cond_count + 1] = cond
end

--[[
    Sets a conditional

    params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of conditional group
      conditional: conditional to add
      input: optional data for a conditional
  ]]
function SMacro:setConditional(line_num, arg_num, cond_num, index, conditional, input)
  if self.lines[line_num].args[arg_num].conds[cond_num][index] ~= nil then
    local cond = {}
    cond.name = conditional
    cond.input = input
    self.lines[line_num].args[arg_num].conds[cond_num][index] = cond
  end
end

--[[
    Removes a conditional

    params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of the conditional group
      index: index of conditional in group
    returns:
      boolean: if the conditional was removed
  ]]
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

--[[
    Delete all conditionals for a given line and argument

    params:
      line_num: row number for the line
      arg_num: index of the arg
  ]]
function SMacro:resetConditionals(line_num, arg_num)
  self.lines[line_num].args[arg_num].conds = {}
end

--[[
    Retrieve all conditionals for a given line and argument

    params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of conditional group
  ]]
function SMacro:getConditionals(line_num, arg_num, cond_num)
  return self.lines[line_num].args[arg_num].conds[cond_num]
end

--[[
    Retrieve string representation of all conditionals for a given line and argument

    params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of conditional group
  ]]
function SMacro:composeConditionals(line_num, arg_num, cond_num)
  local conditionals = self.lines[line_num].args[arg_num].conds[cond_num]

  -- support empty conditional
  if #conditionals == 1 and conditionals[1] == nil then
    return "[]"
  end

  local result, currentName
  for count, conditional in ipairs(conditionals) do
    currentName = conditional.name

    if conditional.input then
      currentName = currentName .. conditional.input
    end

    if count == 1 then
      result = "[" .. currentName
    else
      result = result .. ", " .. currentName
    end

    if count == #conditionals then
      result = result .. "]"
    end
  end

  return result
end
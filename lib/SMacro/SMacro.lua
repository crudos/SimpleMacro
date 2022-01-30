local _, L = ...

--[[
      SMacro:new
      SMacro:set
      SMacro:compose

   ]]

SMacro = {
   lines = {}
}

--[[
   Creates a new SMacro object to represent a macro

   ]]
function SMacro:new()
   local m = { lines = { count =  0 } }
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
end

--[[
   Returns a string representation of the macro

   returns:
      string: text representing the macro's body joined with \n
   ]]
function SMacro:compose()
   local lines, i, result

   lines = self.lines

   if lines[1] == nil then
      return nil
   end

   result = ""
   for i = 1, lines.count, 1 do
      result = result..self:getLine(i)

      if i ~= lines.count then
         result = result.."\n" -- add newlines after each line until the last
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
   return self.lines[line_num].type..self.lines[line_num].cmd
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
      local cur

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
   local body, lines, lc

   lines = self.lines
   body = ''
   lc = line_num

   if (lines[lc] == nil) then
      return nil
   end

   if lines[lc].type then
      body = body..lines[lc].type

      if lines[lc].cmd then
         body = body..lines[lc].cmd..' '
      end
   end

   for ac = 1, lines[lc].args.count, 1 do -- add each argument
      if lines[lc].args[ac].conds.count > 0 then -- add conditionals if they exist
         body = body..'['

         for cc = 1, lines[lc].args[ac].conds.count, 1 do
            body = body..lines[lc].args[ac].conds[cc].cond

            if lines[lc].args[ac].conds[cc].input then
               body = body..lines[lc].args[ac].conds[cc].input
            end

            if cc ~= lines[lc].args[ac].conds.count then
               body = body..', ' -- add commas after each cond until the last
            end
         end

         body = body..'] '
      end

      body = body..lines[lc].args[ac].arg

      if ac ~= lines[lc].args.count then
         body = body..'; ' -- add semicolons after each arg until the last
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

   self.lines[line_num].args[new_arg].conds = {}
   self.lines[line_num].args[new_arg].conds.count = 0

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
   local arguments, arg_count, isRemoved, cur

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
      SMacro:addConditional
      SMacro:setConditional
      SMacro:removeConditional
      SMacro:resetConditionals
      SMacro:getConditionals
      SMacro:composeConditionals

   ]]

--[[
   Adds a new conditional

   params:
      line_num: row number for the line
      arg_num: index of the arg
      conditional: conditional to add
      input: optional data for a conditional
   ]]
function SMacro:addConditional(line_num, arg_num, conditional, input)
   local cond_count, cond

   cond = {}
   cond.cond = conditional
   cond.input = input
   cond_count = self.lines[line_num].args[arg_num].conds.count

   self.lines[line_num].args[arg_num].conds[cond_count + 1] = cond
   self.lines[line_num].args[arg_num].conds.count = cond_count + 1;
end

--[[
   Sets a conditional

   params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of the conditional
      conditional: conditional to add
      input: optional data for a conditional
   ]]
function SMacro:setConditional(line_num, arg_num, cond_num, conditional, input)
   if self.lines[line_num].args[arg_num].conds[cond_num] ~= nil then
      local cond = {}

      cond.cond = conditional
      cond.input = input
      self.lines[line_num].args[arg_num].conds[cond_num] = cond
   end
end

--[[
   Removes a conditional

   params:
      line_num: row number for the line
      arg_num: index of the arg
      cond_num: index of the conditional
   returns:
      boolean: if the conditional was removed
   ]]
function SMacro:removeConditional(line_num, arg_num, cond_num)
   local conditionals, cond_count, isRemoved, cur

   conditionals = self.lines[line_num].args[arg_num].conds
   cond_count = self.lines[line_num].args[arg_num].conds.count
   isRemoved = false

   for cur = cond_num, cond_count - 1, 1 do
      self.lines[line_num].args[arg_num].conds[cur] = conditionals[cur + 1]
   end

   self.lines[line_num].args[arg_num].conds[cond_count] = nil

   if cond_count ~= 0 then
      self.lines[line_num].args[arg_num].conds.count = cond_count - 1
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
   self.lines[line_num].args[arg_num].conds.count = 0
end

--[[
   Retrieve all conditionals for a given line and argument

   params:
      line_num: row number for the line
      arg_num: index of the arg
   ]]
function SMacro:getConditionals(line_num, arg_num)
   return self.lines[line_num].args[arg_num].conds
end

--[[
   Retrieve string representation of all conditionals for a given line and argument

   params:
      line_num: row number for the line
      arg_num: index of the arg
   ]]
function SMacro:composeConditionals(line_num, arg_num)
   local result, thisArg, curCond

   thisArg = self.lines[line_num].args[arg_num]

   for count, conditional in ipairs(thisArg.conds) do
      curCond = conditional.cond

      if conditional.input then
         curCond = curCond..conditional.input
      end

      if count == 1 then
         result = "["..curCond
      else
         result = result..", "..curCond
      end

      if count == thisArg.conds.count then
         result = result.."]"
      end
   end

   return result
end
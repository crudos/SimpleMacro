-- Author      : Crudos
-- Create Date : 4/6/2015 08:39:11 PM

--[[
   This library's purpose is to parse and recreate macros.

   SMacro:new()
   SMacro:set(macro_id)
   SMacro:compose()

   SMacro:setCommand(line_num, command)
   SMacro:getCommand(line_num)

   SMacro:removeLine(line_num)
   SMacro:getLine(line_num)

   SMacro:addArgument(line_num, argument)
   SMacro:setArgument(line_num, arg_num, argument)
   SMacro:removeArgument(line_num, arg_num)
   SMacro:getArguments(line_num)

   SMacro:addConditional(line_num, arg_num, conditional)
   SMacro:setConditional(line_num, arg_num, cond_num, conditional)
   SMacro:removeConditional(line_num, arg_num, cond_num)
   SMacro:getConditionals(line_num, arg_num)
   SMacro:composeConditionals(line_num, arg_num)

   Table reference:

   Macro
      new()
      parse(body)
      compose()

   lines
      #, {line}
      count, int

   line
      type, string
      cmd, string
      args, {args}

   args
      #, {arg}
      count, int

   arg
      arg, string
      conds, {conds}

   conds
      #, {cond}
      count, int

   cond
      cond, string
      input, string

   ]]

local _, L = ...

local function isempty(s)
   return s == nil or s == ''
end

local function trim(s)
   return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

--[[
   params:
      cond_body: conditionals for an arg
   returns:
      table: list of args for this line
   ]]
local function parse_conds(cond_body)
   local conds, i, cur, rest, temp, cond

   conds = {}

   if isempty(cond_body) then
      rest = ""
   else
      rest = string.match(cond_body, "[%[](.-)[%]]") -- remove brackets
   end

   i = 0
   while not isempty(rest) do
      i = i + 1

      if string.match(rest, "^.-(,).*") then
         cur, rest = string.match(rest, "^(.-),(.*)")
      else
         cur = rest
         rest = nil
      end

      if isempty(trim(cur)) then -- remove unecessary conditionals [dead,   ] or [  ]
         i = i - 1
      else
         cond = {}
         temp = trim(cur)

         if string.match(temp, ".-[@:=](.*)") then
            cond.cond, cond.input = string.match(temp, "(.-[@:=])(.*)")
         else
            cond.cond = temp
         end

         conds[i] = cond
      end
   end

   conds.count = i
   return conds
end

--[[
   params:
      arg_body: body of a line without the cmd
   returns:
      table: list of args for this line
   ]]
local function parse_args(arg_body)
   local text, conds, arg, rest, args, i

   args = {}
   text = arg_body

   i = 0
   while not isempty(text) do
      text = trim(text)
      i = i + 1

      if string.match(text, "^([%[]).*") then -- check for bracket
         conds, text = string.match(text, "^(.-[%]])(.*)")
      else
         conds = ""
      end

      if string.match(text, "^.-([;])") ~= nil then
         arg, text = string.match(text, "^(.-)[;](.*)")
      else
         arg = text
         text = nil
      end

      args[i] = {}
      args[i].arg = trim(arg)
      args[i].conds = parse_conds(conds)
   end

   args.count = i
   return args
end

--[[
   params:
      line_body: body of a line
   returns:
      string: type of command (/, #, etc.)
      string: command for this line
      string: rest of the line
   ]]
local function parse_cmd(line_body)
   local type, cmd, text

   type, cmd, text = string.match(line_body, "([/#])([^ ]*)(.-)$") -- grabs '/ or #', (non spaces), (the rest)

   return type, cmd, trim(text)
end

--[[
   params:
      line_body: body of a line
   returns:
      table: parsed line
   ]]
local function parse_line(line_body)
   local line_data, text

   line_data = {}
   text = line_body

   line_data.type, line_data.cmd, text = parse_cmd(text)
   line_data.args = parse_args(text)

   return line_data
end

--[[
   params:
      body: body of macro
   returns:
      table: list of parsed lines for this body
   ]]
local function parse_lines(body)
   local cur, text, i, lines

   lines = {}
   text = body
   i = 0
   while not isempty(text) do
      i = i + 1
      if string.match(text, ".-([\n])") then -- check for newline
         cur, text = string.match(text, "^(.-)[\n](.-)$")
      else
         cur = text
         text = nil
      end

      lines[i] = parse_line(cur)
   end

   lines.count = i
   return lines
end

-- setup Macro class

SMacro = {
   lines = {}
}

function SMacro:new()
   m = { lines = {} }

   setmetatable(m, self)
   self.__index = self

   -- add this macro

   return m
end

--[[
   stores parsed information about the macro

   params:
      body: body of a macro to be parsed
   ]]

function SMacro:set(macro_id)
	local body

	_, _, body = GetMacroInfo(macro_id)

	self.lines = parse_lines(body)
end

function SMacro:getLine(line_num)
   local body, lines, lc

   lines = self.lines
   body = ""
   lc = line_num

   if lines[lc].type then
      body = body..lines[lc].type

      if lines[lc].cmd then
         body = body..lines[lc].cmd.." "
      end
   end

   for ac = 1, lines[lc].args.count, 1 do -- add each argument
      if lines[lc].args[ac].conds.count > 0 then -- add conditionals if they exist
         body = body.."["

         for cc = 1, lines[lc].args[ac].conds.count, 1 do
            body = body..lines[lc].args[ac].conds[cc].cond

            if lines[lc].args[ac].conds[cc].input then
               body = body..lines[lc].args[ac].conds[cc].input
            end

            if cc ~= lines[lc].args[ac].conds.count then
               body = body..", " -- add commas after each cond until the last
            end
         end

         body = body.."] "
      end

      body = body..lines[lc].args[ac].arg

      if ac ~= lines[lc].args.count then
         body = body.."; " -- add semicolons after each arg until the last
      end
   end

   return body
end


--[[
   takes the lines table and composes a string for a macro

   returns:
      string: text for the composed body of the macro
   ]]
function SMacro:compose()
   local lines, body, lc, ac, cc

   lines = self.lines

   if lines[1] == nil then
      return nil
   end

   body = ""
   for lc = 1, lines.count, 1 do
      body = body..self:getLine(lc)

      if lc ~= lines.count then
         body = body.."\n" -- add newlines after each line until the last
      end
   end

   return body
end

function SMacro:setCommand(line_num, command)
   self.lines[line_num].type, self.lines[line_num].cmd = string.match(command, "([#/])(.*)")
end

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

function SMacro:addArgument(line_num, argument)
   local new_arg = self.lines[line_num].args.count + 1

   self.lines[line_num].args[new_arg] = {}
   self.lines[line_num].args[new_arg].arg = argument
   self.lines[line_num].args.count = new_arg

   self.lines[line_num].args[new_arg].conds = {}
   self.lines[line_num].args[new_arg].conds.count = 0

   return new_arg
end

function SMacro:setArgument(line_num, arg_num, argument)
   if self.lines[line_num].args[arg_num] ~= nil then
      self.lines[line_num].args[arg_num].arg = argument
   end
end

-- remove argument from this line, returns true if the argument was removed
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

function SMacro:addConditional(line_num, arg_num, conditional, input)
   local cond_count, cond

   cond = {}
   cond.cond = conditional
   cond.input = input
   cond_count = self.lines[line_num].args[arg_num].conds.count

   self.lines[line_num].args[arg_num].conds[cond_count + 1] = cond
   self.lines[line_num].args[arg_num].conds.count = cond_count + 1;
end

function SMacro:setConditional(line_num, arg_num, cond_num, conditional, input)
   if self.lines[line_num].args[arg_num].conds[cond_num] ~= nil then
      local cond = {}

      cond.cond = conditional
      cond.input = input
      self.lines[line_num].args[arg_num].conds[cond_num] = cond
   end
end

-- removes conditional from this line and arg, returns true if the conditional was removed
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

function SMacro:resetConditionals(line_num, arg_num)
   self.lines[line_num].args[arg_num].conds = {}
   self.lines[line_num].args[arg_num].conds.count = 0
end

-- get the command for line |line_num|
function SMacro:getCommand(line_num)
   return self.lines[line_num].type..self.lines[line_num].cmd
end

-- get the list arguments for line |line_num|
function SMacro:getArguments(line_num)
   return self.lines[line_num].args
end

-- get the list of conditionals for line |line_num| and argument |arg_num|
function SMacro:getConditionals(line_num, arg_num)
   return self.lines[line_num].args[arg_num].conds
end

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
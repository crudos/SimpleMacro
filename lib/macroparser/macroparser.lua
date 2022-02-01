--[[
   This library parses macros into a custom internal representation.

   Macro structure:

   LINES
      #, {LINE}
      count, int

   LINE
      type, string
      cmd, string
      args, {ARGS}

   ARGS
      #, {ARG}
      count, int

   ARG
      arg, string
      conds, {CONDS}

   CONDS
      #, {COND}
      count, int

   COND
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

      if isempty(trim(cur)) then -- remove unnecessary conditionals [dead,   ] or [  ]
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
   local text, conds, arg, args, i

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
function parse_lines(body)
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

L['parse_lines'] = parse_lines
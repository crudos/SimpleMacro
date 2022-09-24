--[[
  This library parses macros into an object representation.

  Macro structure:


  { lines = { count = <count>,
              # = { type = <type>,
                    cmd = <command>,
                    args = { count = <count>,
                             # = { arg = <argument>,
                                   conds = { count = <count>
                                             # = { count = <count>,
                                                   # = { name = <name>,
                                                         input = <input>
                                                       }
                                                 }
                                           }
                                 }
                           }
                  }
            }
  }

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
    conds, {COND_GROUPS}

  COND_GROUPS
    #, {CONDS}
    count, int

  CONDS
    #, {COND}
    count, int

  COND
    name, string
    input, string
  ]]
local _, L = ...

local function isempty(s)
  return s == nil or s == ''
end

local function trim(s)
  return s:match '^()%s*$' and '' or s:match '^%s*(.*%S)'
end

--[[
   params:
      cond_body: conditionals for a conditional group
   returns:
      table: list of conditionals for this group
   ]]
local function parse_conds(cond_body)
  local conds = {}

  local rest
  if isempty(cond_body) then
    conds.count = 0
    return conds
  else
    rest = string.match(cond_body, "[%[](.-)[%]]") -- remove brackets

    -- Found an empty conditional
    if isempty(trim(rest)) then
      conds.count = 0
      return conds
    end
  end

  local i = 0
  while not isempty(rest) do
    i = i + 1

    local cur
    if string.match(rest, "^.-(,).*") then
      cur, rest = string.match(rest, "^(.-),(.*)")
    else
      cur = rest
      rest = nil
    end

    if isempty(trim(cur)) then
      -- remove unnecessary conditionals [dead,   ] -> [dead]
      i = i - 1
    else
      local cond = {}
      local temp = trim(cur)

      if string.match(temp, ".-[@:=](.*)") then
        cond.name, cond.input = string.match(temp, "(.-[@:=])(.*)")
      else
        cond.name = temp
      end

      conds[i] = cond
    end
  end

  conds.count = i
  return conds
end

--[[
   params:
      cond_group_body: conditional groups for an arg
   returns:
      table: list of conditional groups
   ]]
local function parse_cond_groups(cond_group_body)
  local cond_groups = {}
  local text = cond_group_body
  local i = 0
  while not isempty(text) do
    text = trim(text)
    i = i + 1

    local group
    if string.match(text, "^([%[]).*") then
      group, text = string.match(text, "^([%[].-[%]])(.*)$")
      cond_groups[i] = parse_conds(group)
    end
  end

  return cond_groups
end

--[[
   params:
      arg_body: body of a line without the cmd
   returns:
      table: argument with conditional group table
   ]]
local function parse_args(arg_body)
  local args = {}
  local text = arg_body
  local i = 0

  while not isempty(text) do
    text = trim(text)
    i = i + 1

    local conds = ""
    -- parse all cond groups
    while string.match(text, "^%s?([%[]).*")
    do
      local condition
      condition, text = string.match(text, "^(.-[%]])(.*)")
      conds = conds..condition
    end

    local arg
    if string.match(text, "^.-([;])") ~= nil then
      arg, text = string.match(text, "^(.-)[;](.*)")
    else
      arg = text
      text = nil
    end

    args[i] = {}
    args[i].arg = trim(arg)
    args[i].conds = parse_cond_groups(conds)
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
  local type, cmd, text = string.match(line_body, "([/#])([^ ]*)(.-)$") -- grabs '/ or #', (non spaces), (the rest)
  return type, cmd, trim(text)
end

--[[
   params:
      line_body: body of a line
   returns:
      table: parsed line
   ]]
local function parse_line(line_body)
  local line_data = {}
  local text = line_body

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
    if string.match(text, ".-([\n])") then
      -- check for newline
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
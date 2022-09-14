if WoWUnit ~= nil then
  local AreEqual, IsTrue, Replace, IsFalse = WoWUnit.AreEqual, WoWUnit.Exists, WoWUnit.Replace, WoWUnit.IsFalse
  local SMacroTest = WoWUnit('SMacro')
  local mockBody = '#showtooltip [equipped:Two-Hand] 16; [noequipped:Two-Hand] 17\n/equipset [noequipped:Two-Hand] 2h; [equipped:Two-Hand] 1hsh'

  function mockGetMacroInfo(id)
    if id == 123 then
      return '', '', mockBody
    elseif id == 111 then
      return '', '', 'bad macro text'
    end
    return nil
  end

  function SMacroTest:SetTest()
    Replace('GetMacroInfo', mockGetMacroInfo)
    local macro = SMacro:new()
    macro:set(123)

    AreEqual(mockBody, macro:compose())
  end

  function SMacroTest:SetHandlesErrorTest()
    local macro = SMacro:new()
    macro:set(111)

    IsFalse(macro:compose())
  end

  function SMacroTest:AddLineTest()
    local macro = SMacro:new()
    macro:addLine()

    AreEqual('/cast ', macro:getLine(1))
  end

  function SMacroTest:RemoveLineTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:removeLine(1)

    IsFalse(macro:getLine(1))
  end

  function SMacroTest:SetArgumentTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addArgument(1, 'arg2')
    macro:setArgument(1, 2, 'set')

    AreEqual({ { arg = 'arg1' },
               { arg = 'set' },
               count = 2 },
        macro:getArguments(1))
  end

  function SMacroTest:RemoveArgumentTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:removeArgument(1, 1)

    AreEqual({ count = 0 }, macro:getArguments(1))
  end

  function SMacroTest:SetConditionalTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addConditionalGroup(1, 1)
    macro:addConditional(1, 1, 1, 'harm', nil)
    macro:setConditional(1, 1, 1, 1, 'dead', nil)

    AreEqual({ { name = 'dead' }, count = 1 }, macro:getConditionals(1, 1, 1))
  end

  function SMacroTest:RemoveConditionalTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addConditionalGroup(1, 1)
    macro:addConditional(1, 1, 1, 'harm', nil)

    IsTrue(macro:removeConditional(1, 1, 1, 1))
    IsFalse(macro:getConditionals(1, 1, 1)[1])
  end

  function SMacroTest:ResetConditionalTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addConditionalGroup(1, 1)
    macro:addConditional(1, 1, 1,'harm', nil)
    macro:resetConditionals(1, 1)

    AreEqual(nil, macro:getConditionals(1, 1, 1))
  end

  function SMacroTest:GetConditionalTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addConditionalGroup(1, 1)
    macro:addConditional(1, 1, 1,'harm', nil)

    AreEqual({ { name = 'harm' }, count = 1 }, macro:getConditionals(1, 1, 1))
  end

  function SMacroTest:ComposeConditionalTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addConditionalGroup(1, 1)
    macro:addConditional(1, 1, 1, 'harm', nil)

    AreEqual('[harm]', macro:composeConditionals(1, 1, 1))
  end

  function SMacroTest:ComposeEmptyConditionalTest()
    local macro = SMacro:new()
    macro:addLine()
    macro:addArgument(1, 'arg1')
    macro:addConditionalGroup(1, 1)
    macro:addConditional(1, 1, 1, '', nil)

    AreEqual('[]', macro:composeConditionals(1, 1, 1))
  end
end

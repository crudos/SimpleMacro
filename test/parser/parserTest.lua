if WoWUnit ~= nil then
  local AreEqual, IsTrue, Replace, IsFalse = WoWUnit.AreEqual, WoWUnit.Exists, WoWUnit.Replace, WoWUnit.IsFalse
  local SMacroTest = WoWUnit('parser')

  local mockBody = '#showtooltip [equipped:Two-Hand] 16; [noequipped:Two-Hand] 17\n/equipset [noequipped:Two-Hand] 2h; [equipped:Two-Hand] 1hsh'
  local mockEmptyConditional = '/focus [@mouseover, exists, nodead] ; []'

  function SMacroTest:ParseLinesTest()
    lines = parse_lines(mockBody)

    AreEqual(2, lines.count)
  end

  function SMacroTest:ParseLinesEmptyConditionalTest()
    lines = parse_lines(mockEmptyConditional)

    AreEqual(1, lines.count)
  end
end
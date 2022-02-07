local _, L = ...

-- All the conditionals in the game with alternate text and boolean expressing if they require user input
L["CONDITIONAL_LIST"] = {}
L["CONDITIONAL_LIST"][1] = { DEFAULT = "target=", ALTERNATE = "@", INPUT = true, INPUT_HINT = "<target name>" }
L["CONDITIONAL_LIST"][2] = { DEFAULT = "actionbar:", ALTERNATE = "bar:", INPUT = true, INPUT_HINT = "1/.../6" }
L["CONDITIONAL_LIST"][3] = { DEFAULT = "bonusbar:", ALTERNATE = nil, INPUT = true, INPUT_HINT = "1/..." }
L["CONDITIONAL_LIST"][4] = { DEFAULT = "button:", ALTERNATE = "btn:", INPUT = true, INPUT_HINT = "1/.../5/<virtual click>" }
L["CONDITIONAL_LIST"][5] = { DEFAULT = "canexitvehicle", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][6] = { DEFAULT = "channeling:", ALTERNATE = nil, INPUT = true, INPUT_HINT = "<spell name>" }
L["CONDITIONAL_LIST"][7] = { DEFAULT = "cursor", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][8] = { DEFAULT = "combat", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][9] = { DEFAULT = "dead", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][10] = { DEFAULT = "equipped:", ALTERNATE = "worn:", INPUT = true, INPUT_HINT = "<item type>" }
L["CONDITIONAL_LIST"][11] = { DEFAULT = "exists", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][12] = { DEFAULT = "extrabar", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][13] = { DEFAULT = "flyable", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][14] = { DEFAULT = "flying", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][15] = { DEFAULT = "stance:", ALTERNATE = "form:", INPUT = true, INPUT_HINT = "<0/.../n>" }
L["CONDITIONAL_LIST"][16] = { DEFAULT = "group:", ALTERNATE = nil, INPUT = true, INPUT_HINT = "party/raid" }
L["CONDITIONAL_LIST"][17] = { DEFAULT = "harm", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][18] = { DEFAULT = "help", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][19] = { DEFAULT = "indoors", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][20] = { DEFAULT = "modifier:", ALTERNATE = "mod:", INPUT = true, INPUT_HINT = "shift/ctrl/alt" }
L["CONDITIONAL_LIST"][21] = { DEFAULT = "mounted", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][22] = { DEFAULT = "outdoors", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][23] = { DEFAULT = "overridebar", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][24] = { DEFAULT = "party", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][25] = { DEFAULT = "pet:", ALTERNATE = nil, INPUT = true, INPUT_HINT = "<pet name or type>" }
L["CONDITIONAL_LIST"][26] = { DEFAULT = "petbattle", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][27] = { DEFAULT = "possessbar", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][28] = { DEFAULT = "raid", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][29] = { DEFAULT = "resting", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][30] = { DEFAULT = "shapeshift", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][31] = { DEFAULT = "spec:", ALTERNATE = nil, INPUT = true, INPUT_HINT = "1/2" }
L["CONDITIONAL_LIST"][32] = { DEFAULT = "stealth", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][33] = { DEFAULT = "swimming", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][34] = { DEFAULT = "talent:", ALTERNATE = nil, INPUT = true, INPUT_HINT = "<row#>/<column#>" }
L["CONDITIONAL_LIST"][35] = { DEFAULT = "unithasvehicleui", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }
L["CONDITIONAL_LIST"][36] = { DEFAULT = "vehicleui", ALTERNATE = nil, INPUT = false, INPUT_HINT = nil }

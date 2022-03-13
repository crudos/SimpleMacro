local _, L = ...

-- All the conditionals in the game with alternate text and boolean expressing if they require user input
L["CONDITIONAL_LIST"] = {}
L["CONDITIONAL_LIST"][1] = { ALIASES = { "target=", "@" }, INPUT_HINT = "<target name>" }
L["CONDITIONAL_LIST"][2] = { ALIASES = { "actionbar:", "bar:" }, INPUT_HINT = "1/.../6" }
L["CONDITIONAL_LIST"][3] = { ALIASES = { "bonusbar:" }, INPUT_HINT = "1/..." }
L["CONDITIONAL_LIST"][4] = { ALIASES = { "button:", "btn:"}, INPUT_HINT = "1/.../5/<virtual click>" }
L["CONDITIONAL_LIST"][5] = { ALIASES = { "canexitvehicle" } }
L["CONDITIONAL_LIST"][6] = { ALIASES = { "channeling:" }, INPUT_HINT = "<spell name>" }
L["CONDITIONAL_LIST"][7] = { ALIASES = { "cursor" } }
L["CONDITIONAL_LIST"][8] = { ALIASES = { "combat" } }
L["CONDITIONAL_LIST"][9] = { ALIASES = { "dead" } }
L["CONDITIONAL_LIST"][10] = { ALIASES = { "equipped:", "worn:" }, INPUT_HINT = "<item type>" }
L["CONDITIONAL_LIST"][11] = { ALIASES = { "exists" } }
L["CONDITIONAL_LIST"][12] = { ALIASES = { "extrabar" } }
L["CONDITIONAL_LIST"][13] = { ALIASES = { "flyable" } }
L["CONDITIONAL_LIST"][14] = { ALIASES = { "flying" } }
L["CONDITIONAL_LIST"][15] = { ALIASES = { "stance:", "form:" }, INPUT_HINT = "<0/.../n>" }
L["CONDITIONAL_LIST"][16] = { ALIASES = { "group:" }, INPUT_HINT = "party/raid" }
L["CONDITIONAL_LIST"][17] = { ALIASES = { "harm" } }
L["CONDITIONAL_LIST"][18] = { ALIASES = { "help" } }
L["CONDITIONAL_LIST"][19] = { ALIASES = { "indoors" } }
L["CONDITIONAL_LIST"][20] = { ALIASES = { "modifier:", "mod:" }, INPUT_HINT = "shift/ctrl/alt" }
L["CONDITIONAL_LIST"][21] = { ALIASES = { "mounted" } }
L["CONDITIONAL_LIST"][22] = { ALIASES = { "outdoors" } }
L["CONDITIONAL_LIST"][23] = { ALIASES = { "overridebar" } }
L["CONDITIONAL_LIST"][24] = { ALIASES = { "party" } }
L["CONDITIONAL_LIST"][25] = { ALIASES = { "pet:" }, INPUT_HINT = "<pet name or type>" }
L["CONDITIONAL_LIST"][26] = { ALIASES = { "petbattle" } }
L["CONDITIONAL_LIST"][27] = { ALIASES = { "possessbar" } }
L["CONDITIONAL_LIST"][28] = { ALIASES = { "raid" } }
L["CONDITIONAL_LIST"][29] = { ALIASES = { "resting" } }
L["CONDITIONAL_LIST"][30] = { ALIASES = { "shapeshift" } }
L["CONDITIONAL_LIST"][31] = { ALIASES = { "spec:" }, INPUT_HINT = "1/2" }
L["CONDITIONAL_LIST"][32] = { ALIASES = { "stealth" } }
L["CONDITIONAL_LIST"][33] = { ALIASES = { "swimming" } }
L["CONDITIONAL_LIST"][34] = { ALIASES = { "talent:" }, INPUT_HINT = "<row#>/<column#>" }
L["CONDITIONAL_LIST"][35] = { ALIASES = { "unithasvehicleui" } }
L["CONDITIONAL_LIST"][36] = { ALIASES = { "vehicleui" } }

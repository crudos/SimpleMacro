local _, ns = ...
local C = ns.C

C["CONDITIONAL_EDITOR"] = {}
C["CONDITIONAL_EDITOR"]["MAX_CONDITIONALS"] = 5

-- All the conditionals in the game with alternate text and boolean expressing if they require user input
C["CONDITIONAL_EDITOR"]["CONDITIONALS"] = {}
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][1] = { ALIASES = { "target=", "@" }, INPUT_HINT = "<target name>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][2] = { ALIASES = { "actionbar:", "bar:" }, INPUT_HINT = "1/.../6" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][3] = { ALIASES = { "bonusbar:" }, INPUT_HINT = "1/..." }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][4] = { ALIASES = { "button:", "btn:"}, INPUT_HINT = "1/.../5/<virtual click>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][5] = { ALIASES = { "canexitvehicle" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][6] = { ALIASES = { "channeling:" }, INPUT_HINT = "<spell name>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][7] = { ALIASES = { "cursor" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][8] = { ALIASES = { "combat" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][9] = { ALIASES = { "dead" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][10] = { ALIASES = { "equipped:", "worn:" }, INPUT_HINT = "<item type>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][11] = { ALIASES = { "exists" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][12] = { ALIASES = { "extrabar" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][13] = { ALIASES = { "flyable" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][14] = { ALIASES = { "flying" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][15] = { ALIASES = { "stance:", "form:" }, INPUT_HINT = "<0/.../n>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][16] = { ALIASES = { "group:" }, INPUT_HINT = "party/raid" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][17] = { ALIASES = { "harm" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][18] = { ALIASES = { "help" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][19] = { ALIASES = { "indoors" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][20] = { ALIASES = { "known:" }, INPUT_HINT = "<spell name or ID>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][21] = { ALIASES = { "modifier:", "mod:" }, INPUT_HINT = "shift/ctrl/alt" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][22] = { ALIASES = { "mounted" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][23] = { ALIASES = { "outdoors" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][24] = { ALIASES = { "overridebar" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][25] = { ALIASES = { "party" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][26] = { ALIASES = { "pet:" }, INPUT_HINT = "<pet name or type>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][27] = { ALIASES = { "petbattle" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][28] = { ALIASES = { "possessbar" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][29] = { ALIASES = { "raid" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][30] = { ALIASES = { "resting" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][31] = { ALIASES = { "shapeshift" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][32] = { ALIASES = { "spec:" }, INPUT_HINT = "1/2" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][33] = { ALIASES = { "stealth" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][34] = { ALIASES = { "swimming" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][35] = { ALIASES = { "talent:" }, INPUT_HINT = "<row#>/<column#>" }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][36] = { ALIASES = { "unithasvehicleui" } }
C["CONDITIONAL_EDITOR"]["CONDITIONALS"][37] = { ALIASES = { "vehicleui" } }

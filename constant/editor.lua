local _, ns = ...
local C = ns.C

C["MACRO_EDITOR"] = {}
C["MACRO_EDITOR"]["NUM_MACRO_CATEGORIES"] = 12
C["MACRO_EDITOR"]["NUM_MACRO_COMMANDS"] = 32
C["MACRO_EDITOR"]["MAX_CONDITIONAL_GROUPS"] = 5
C["MACRO_EDITOR"]["MAX_CONDITIONALS"] = 5
C["MACRO_EDITOR"]["HASH_CATEGORY"] = "Metacommands"

-- All the conditionals in the game with alternate text and boolean expressing if they require user input
C["CONDITIONAL_LIST"] = {}
C["CONDITIONAL_LIST"][1] = { ALIASES = { "target=", "@" }, INPUT_HINT = "<target name>" }
C["CONDITIONAL_LIST"][2] = { ALIASES = { "actionbar:", "bar:" }, INPUT_HINT = "1/.../6" }
C["CONDITIONAL_LIST"][3] = { ALIASES = { "bonusbar:" }, INPUT_HINT = "1/..." }
C["CONDITIONAL_LIST"][4] = { ALIASES = { "button:", "btn:"}, INPUT_HINT = "1/.../5/<virtual click>" }
C["CONDITIONAL_LIST"][5] = { ALIASES = { "canexitvehicle" } }
C["CONDITIONAL_LIST"][6] = { ALIASES = { "channeling:" }, INPUT_HINT = "<spell name>" }
C["CONDITIONAL_LIST"][7] = { ALIASES = { "cursor" } }
C["CONDITIONAL_LIST"][8] = { ALIASES = { "combat" } }
C["CONDITIONAL_LIST"][9] = { ALIASES = { "dead" } }
C["CONDITIONAL_LIST"][10] = { ALIASES = { "equipped:", "worn:" }, INPUT_HINT = "<item type>" }
C["CONDITIONAL_LIST"][11] = { ALIASES = { "exists" } }
C["CONDITIONAL_LIST"][12] = { ALIASES = { "extrabar" } }
C["CONDITIONAL_LIST"][13] = { ALIASES = { "flyable" } }
C["CONDITIONAL_LIST"][14] = { ALIASES = { "flying" } }
C["CONDITIONAL_LIST"][15] = { ALIASES = { "stance:", "form:" }, INPUT_HINT = "<0/.../n>" }
C["CONDITIONAL_LIST"][16] = { ALIASES = { "group:" }, INPUT_HINT = "party/raid" }
C["CONDITIONAL_LIST"][17] = { ALIASES = { "harm" } }
C["CONDITIONAL_LIST"][18] = { ALIASES = { "help" } }
C["CONDITIONAL_LIST"][19] = { ALIASES = { "indoors" } }
C["CONDITIONAL_LIST"][20] = { ALIASES = { "known" }, INPUT_HINT = "<spell name or ID>" }
C["CONDITIONAL_LIST"][21] = { ALIASES = { "modifier:", "mod:" }, INPUT_HINT = "shift/ctrl/alt" }
C["CONDITIONAL_LIST"][22] = { ALIASES = { "mounted" } }
C["CONDITIONAL_LIST"][23] = { ALIASES = { "outdoors" } }
C["CONDITIONAL_LIST"][24] = { ALIASES = { "overridebar" } }
C["CONDITIONAL_LIST"][25] = { ALIASES = { "party" } }
C["CONDITIONAL_LIST"][26] = { ALIASES = { "pet:" }, INPUT_HINT = "<pet name or type>" }
C["CONDITIONAL_LIST"][27] = { ALIASES = { "petbattle" } }
C["CONDITIONAL_LIST"][28] = { ALIASES = { "possessbar" } }
C["CONDITIONAL_LIST"][29] = { ALIASES = { "raid" } }
C["CONDITIONAL_LIST"][30] = { ALIASES = { "resting" } }
C["CONDITIONAL_LIST"][31] = { ALIASES = { "shapeshift" } }
C["CONDITIONAL_LIST"][32] = { ALIASES = { "spec:" }, INPUT_HINT = "1/2" }
C["CONDITIONAL_LIST"][33] = { ALIASES = { "stealth" } }
C["CONDITIONAL_LIST"][34] = { ALIASES = { "swimming" } }
C["CONDITIONAL_LIST"][35] = { ALIASES = { "talent:" }, INPUT_HINT = "<row#>/<column#>" }
C["CONDITIONAL_LIST"][36] = { ALIASES = { "unithasvehicleui" } }
C["CONDITIONAL_LIST"][37] = { ALIASES = { "vehicleui" } }

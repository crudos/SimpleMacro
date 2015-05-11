local _, L = ...

-- Constants

-- Popup Menu
L["LINES_TITLE"] = "Lines"
L["ARGS_TITLE"] = "Arguments"
L["LINES_COMMAND_COLUMN"] = "Command"
L["ARGS_ARGUMENT_COLUMN"] = "Argument"

-- Create 

L["LINE_TYPE_TABLE"] = {}
L["LINE_TYPE_TABLE"]["NONE"]           = ""
L["LINE_TYPE_TABLE"]["SHOWTOOLTIP"]    = "showtooltip"
L["LINE_TYPE_TABLE"]["CAST"]           = "cast"
L["LINE_TYPE_TABLE"]["USE"]            = "use"
L["LINE_TYPE_TABLE"]["CASTSEQUENCE"]   = "castsequence"
L["LINE_TYPE_TABLE"]["SAY"]            = "say"
L["LINE_TYPE_TABLE"]["YELL"]           = "yell"
L["LINE_TYPE_TABLE"]["WHISPER"]        = "whisper"
L["LINE_TYPE_TABLE"]["PARTY"]          = "party"
L["LINE_TYPE_TABLE"]["CANCELAURA"]     = "cancelaura"
L["LINE_TYPE_TABLE"]["TARGET"]         = "target"
L["LINE_TYPE_TABLE"]["TAR"]            = "tar"

L["LINE_TYPE_DROPDOWN_LABEL"] = "Line Type"
L["LINE_TYPE_TOOLTIP"] = "This line will start with "
L["LINE_TYPE_TOOLTIP_NONE"] = "Doesn't start with any command."

L["CONDITIONAL_LIST"] = {} -- 36 total, all the conditionals in the game with alternate text and boolean expressing if they require user input
L["CONDITIONAL_LIST"][1] = { DEFAULT = "target=",           ALTERNATE = "@",        INPUT = true,     INPUT_HINT = "<target name>"              }
L["CONDITIONAL_LIST"][2] = { DEFAULT = "actionbar:",        ALTERNATE = "bar:",     INPUT = true,     INPUT_HINT = "1/.../6"                    }
L["CONDITIONAL_LIST"][3] = { DEFAULT = "bonusbar:",         ALTERNATE = nil,        INPUT = true,     INPUT_HINT = "1/..."                      }
L["CONDITIONAL_LIST"][4] = { DEFAULT = "button:",           ALTERNATE = "btn:",     INPUT = true,     INPUT_HINT = "1/.../5/<virtual click>"    }
L["CONDITIONAL_LIST"][5] = { DEFAULT = "canexitvehicle",    ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][6] = { DEFAULT = "channeling:",       ALTERNATE = nil,        INPUT = true,     INPUT_HINT = "<spell name>"               }
L["CONDITIONAL_LIST"][7] = { DEFAULT = "cursor",            ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][8] = { DEFAULT = "combat",            ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][9] = { DEFAULT = "dead",              ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][10] = { DEFAULT = "equipped:",        ALTERNATE = "worn:",    INPUT = true,     INPUT_HINT = "<item type>"                }
L["CONDITIONAL_LIST"][11] = { DEFAULT = "exists",           ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][12] = { DEFAULT = "extrabar",         ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][13] = { DEFAULT = "flyable",          ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][14] = { DEFAULT = "flying",           ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][15] = { DEFAULT = "stance:",          ALTERNATE = "form:",    INPUT = true,     INPUT_HINT = "<0/.../n>"                  }
L["CONDITIONAL_LIST"][16] = { DEFAULT = "group:",           ALTERNATE = nil,        INPUT = true,     INPUT_HINT = "party/raid"                 }
L["CONDITIONAL_LIST"][17] = { DEFAULT = "harm",             ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][18] = { DEFAULT = "help",             ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][19] = { DEFAULT = "indoors",          ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][20] = { DEFAULT = "modifier:",        ALTERNATE = "mod:",     INPUT = true,     INPUT_HINT = "shift/ctrl/alt"             }
L["CONDITIONAL_LIST"][21] = { DEFAULT = "mounted",          ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][22] = { DEFAULT = "outdoors",         ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][23] = { DEFAULT = "overridebar",      ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][24] = { DEFAULT = "party",            ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][25] = { DEFAULT = "pet:",             ALTERNATE = nil,        INPUT = true,     INPUT_HINT = "<pet name or type>"         }
L["CONDITIONAL_LIST"][26] = { DEFAULT = "petbattle",        ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][27] = { DEFAULT = "possessbar",       ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][28] = { DEFAULT = "raid",             ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][29] = { DEFAULT = "resting",          ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][30] = { DEFAULT = "shapeshift",       ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][31] = { DEFAULT = "spec:",            ALTERNATE = nil,        INPUT = true,     INPUT_HINT = "1/2"                        }
L["CONDITIONAL_LIST"][32] = { DEFAULT = "stealth",          ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][33] = { DEFAULT = "swimming",         ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][34] = { DEFAULT = "talent:",          ALTERNATE = nil,        INPUT = true,     INPUT_HINT = "<row#>/<column#>"           }
L["CONDITIONAL_LIST"][35] = { DEFAULT = "unithasvehicleui", ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }
L["CONDITIONAL_LIST"][36] = { DEFAULT = "vehicleui",        ALTERNATE = nil,        INPUT = false,    INPUT_HINT = nil                          }

L["CONDITIONAL_LIST"][1]["DESCRIPTION"] = "Use this as the target. Can be a name or a special identifier such as focus/mouseover/party1/arena1."
L["CONDITIONAL_LIST"][2]["DESCRIPTION"] = "Given action bar page is selected."
L["CONDITIONAL_LIST"][3]["DESCRIPTION"] = "a (specific) bonus action bar is currently overriding the player's main action bar."
L["CONDITIONAL_LIST"][4]["DESCRIPTION"] = "Macro activated with the given mouse button."
L["CONDITIONAL_LIST"][5]["DESCRIPTION"] = "Player is in a vehicle and can exit it at will."
L["CONDITIONAL_LIST"][6]["DESCRIPTION"] = "Player is channeling the given spell."
L["CONDITIONAL_LIST"][7]["DESCRIPTION"] = "The mouse cursor is currently holding an item/ability/macro/etc."
L["CONDITIONAL_LIST"][8]["DESCRIPTION"] = "Player is in combat."
L["CONDITIONAL_LIST"][9]["DESCRIPTION"] = "Conditional target exists and is dead."
L["CONDITIONAL_LIST"][10]["DESCRIPTION"] = "item type is equipped (item type can be an inventory slot, item type, or item subtype)."
L["CONDITIONAL_LIST"][11]["DESCRIPTION"] = "Conditional target exists."
L["CONDITIONAL_LIST"][12]["DESCRIPTION"] = "Player currently has an extra action bar/button."
L["CONDITIONAL_LIST"][13]["DESCRIPTION"] = "The player can use a flying mount in this zone (though incorrect in Wintergrasp during a battle)."
L["CONDITIONAL_LIST"][14]["DESCRIPTION"] = "Mounted or in flight form AND in the air."
L["CONDITIONAL_LIST"][15]["DESCRIPTION"] = "In a form or stance such as  [Bear Form],  [Shadowform],  [Metamorphosis],  [Battle Stance], etc."
L["CONDITIONAL_LIST"][16]["DESCRIPTION"] = "Player is in the given type of group (if argument is omitted, defaults to party)."
L["CONDITIONAL_LIST"][17]["DESCRIPTION"] = "Conditional target exists and can be targeted by harmful spells (e.g.  [Fireball])."
L["CONDITIONAL_LIST"][18]["DESCRIPTION"] = "Conditional target exists and can be targeted by helpful spells (e.g.  [Heal])."
L["CONDITIONAL_LIST"][19]["DESCRIPTION"] = "Player is indoors."
L["CONDITIONAL_LIST"][20]["DESCRIPTION"] = "Holding the given key."
L["CONDITIONAL_LIST"][21]["DESCRIPTION"] = "Player is mounted."
L["CONDITIONAL_LIST"][22]["DESCRIPTION"] = "Player is outdoors."
L["CONDITIONAL_LIST"][23]["DESCRIPTION"] = "Player's main action bar is currently replaced by the override action bar."
L["CONDITIONAL_LIST"][24]["DESCRIPTION"] = " Conditional target exists and is in your party."
L["CONDITIONAL_LIST"][25]["DESCRIPTION"] = "The given pet is out."
L["CONDITIONAL_LIST"][26]["DESCRIPTION"] = "Currently participating in a pet battle."
L["CONDITIONAL_LIST"][27]["DESCRIPTION"] = "Player's main action bar is currently replaced by the possess action bar."
L["CONDITIONAL_LIST"][28]["DESCRIPTION"] = "Conditional target exists and is in your raid/party."
L["CONDITIONAL_LIST"][29]["DESCRIPTION"] = "Player is currently resting."
L["CONDITIONAL_LIST"][30]["DESCRIPTION"] = "Player's main action bar is currently replaced by a temporary shapeshift action bar."
L["CONDITIONAL_LIST"][31]["DESCRIPTION"] = "Player's active specialization group (spec, talents and glyphs)."
L["CONDITIONAL_LIST"][32]["DESCRIPTION"] = "Player is stealthed."
L["CONDITIONAL_LIST"][33]["DESCRIPTION"] = "Player is swimming."
L["CONDITIONAL_LIST"][34]["DESCRIPTION"] = "Conditional talent activated."
L["CONDITIONAL_LIST"][35]["DESCRIPTION"] = "Conditional target has vehicle UI."
L["CONDITIONAL_LIST"][36]["DESCRIPTION"] = "Player has vehicle UI."

L["USE_ALTERNATES"] = "Use alternate text"
L["USE_ALTERNATES_DESC"] = "This will replace any eligible conditionals with shorter alternatives." 

-- Group Page
local _, L = ...

-- Constants

-- Popup Menu
L["LINES_TITLE"] = "Lines"
L["ARGS_TITLE"] = "Arguments"
L["LINES_COMMAND_COLUMN"] = "Command"
L["ARGS_ARGUMENT_COLUMN"] = "Argument"

-- Create 

L["LINE_TYPE_DROPDOWN_LABEL"] = "Line Type"
L["LINE_TYPE_CATEGORY_LABEL"] = "Category"
L["LINE_TYPE_COMMAND_LABEL"] = "Command"
L["LINE_TYPE_TOOLTIP"] = "This line will start with "
L["LINE_TYPE_TOOLTIP_NONE"] = "No command."

L["LINE_TYPE_TABLE"] = {}
L["LINE_TYPE_TABLE"][1] = {}
L["LINE_TYPE_TABLE"][2] = {}
L["LINE_TYPE_TABLE"][3] = {}
L["LINE_TYPE_TABLE"][4] = {}
L["LINE_TYPE_TABLE"][5] = {}
L["LINE_TYPE_TABLE"][6] = {}
L["LINE_TYPE_TABLE"][7] = {}
L["LINE_TYPE_TABLE"][8] = {}
L["LINE_TYPE_TABLE"][9] = {}
L["LINE_TYPE_TABLE"][10] = {}
L["LINE_TYPE_TABLE"][11] = {}
L["LINE_TYPE_TABLE"][12] = {}

L["LINE_TYPE_TABLE"][1]["CATEGORY"] = "PVP"
L["LINE_TYPE_TABLE"][2]["CATEGORY"] = "Blizzard Interface"
L["LINE_TYPE_TABLE"][3]["CATEGORY"] = "Chat"
L["LINE_TYPE_TABLE"][4]["CATEGORY"] = "Character"
L["LINE_TYPE_TABLE"][5]["CATEGORY"] = "Emotes"
L["LINE_TYPE_TABLE"][6]["CATEGORY"] = "Combat"
L["LINE_TYPE_TABLE"][7]["CATEGORY"] = "Guild"
L["LINE_TYPE_TABLE"][8]["CATEGORY"] = "Party/Raid"
L["LINE_TYPE_TABLE"][9]["CATEGORY"] = "Pet"
L["LINE_TYPE_TABLE"][10]["CATEGORY"] = "System"
L["LINE_TYPE_TABLE"][11]["CATEGORY"] = "Targeting"
L["LINE_TYPE_TABLE"][12]["CATEGORY"] = "Metacommands"

-- PVP Commands
L["LINE_TYPE_TABLE"][1][1] = { COMMANDS = { "teamcaptain", "tcaptain" }, DESCRIPTION = "Sets the captain of an arena team you are in." }
L["LINE_TYPE_TABLE"][1][2] = { COMMANDS = { "teamdisband", "tdisband" }, DESCRIPTION = "Disbands an arena team you are in." }
L["LINE_TYPE_TABLE"][1][3] = { COMMANDS = { "teaminvite", "tinvite" }, DESCRIPTION = "Invites a member to your arena team." } 
L["LINE_TYPE_TABLE"][1][4] = { COMMANDS = { "teamquit", "tquit" }, DESCRIPTION = "Leaves an arena team you are in." } 
L["LINE_TYPE_TABLE"][1][5] = { COMMANDS = { "teamremove", "tremove" }, DESCRIPTION = "Removes a member of a team you are in from that team." } 
L["LINE_TYPE_TABLE"][1][6] = { COMMANDS = { "wargame", "wg" }, DESCRIPTION = "Starts a War Game." } 

-- Blizzard Interface Commands
L["LINE_TYPE_TABLE"][2][1] = { COMMANDS = { "achievements", "ach", "achieve", "achievement" }, DESCRIPTION = "Opens the Achievements interface." } 
L["LINE_TYPE_TABLE"][2][2] = { COMMANDS = { "calendar" }, DESCRIPTION = "Opens the Calendar interface." }
L["LINE_TYPE_TABLE"][2][3] = { COMMANDS = { "guildfinder", "gf" }, DESCRIPTION = "Opens the Guild Finder tool." }
L["LINE_TYPE_TABLE"][2][4] = { COMMANDS = { "lfg", "lfd", "df", "dungeonfinder" }, DESCRIPTION = "Opens the Dungeon Finder interface." }
L["LINE_TYPE_TABLE"][2][5] = { COMMANDS = { "lfr", "raidbrowser", "rb", "or", "otherraids" }, DESCRIPTION = "Opens the Raid Browser." }
L["LINE_TYPE_TABLE"][2][6] = { COMMANDS = { "macro", "m" }, DESCRIPTION = "Opens the Macro interface." }
L["LINE_TYPE_TABLE"][2][7] = { COMMANDS = { "stopwatch", "timer", "sw" }, DESCRIPTION = "Opens the Stopwatch interface." }

-- Chat Commands
L["LINE_TYPE_TABLE"][3][1] = { COMMANDS = { "afk", "away" }, DESCRIPTION = "Marks you as \"Away From Keyboard\"." }
L["LINE_TYPE_TABLE"][3][2] = { COMMANDS = { "announce", "ann" }, DESCRIPTION = "Toggle channel announcements." }
L["LINE_TYPE_TABLE"][3][3] = { COMMANDS = { "ban" }, DESCRIPTION = "Bans a user from a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][4] = { COMMANDS = { "battleground", "bg" }, DESCRIPTION = "Sends a chat message to your battleground." }
L["LINE_TYPE_TABLE"][3][5] = { COMMANDS = { "csay", "c" }, DESCRIPTION = "Sends chat text to a channel." }
L["LINE_TYPE_TABLE"][3][6] = { COMMANDS = { "cinvite", "chatinvite" }, DESCRIPTION = "Invite a user to a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][7] = { COMMANDS = { "chatlist", "chatwho", "chatinfo" }, DESCRIPTION = "Displays a list of users in a chat channel, or what channels you are currently a member of." }
L["LINE_TYPE_TABLE"][3][8] = { COMMANDS = { "chatlog" }, DESCRIPTION = "Enables/disables chat logging." }
L["LINE_TYPE_TABLE"][3][9] = { COMMANDS = { "combatlog" }, DESCRIPTION = "Enables/disables combat logging." }
L["LINE_TYPE_TABLE"][3][10] = { COMMANDS = { "chat", "chathelp" }, DESCRIPTION = "Displays a list of commonly used chat commands." }
L["LINE_TYPE_TABLE"][3][11] = { COMMANDS = { "ckick" }, DESCRIPTION = "Kicks a user from a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][12] = { COMMANDS = { "emote", "em", "e", "me" }, DESCRIPTION = "Perform an emote with the given text." }
L["LINE_TYPE_TABLE"][3][13] = { COMMANDS = { "dnd", "busy" }, DESCRIPTION = "Marks you as \"Do Not Disturb\"." }
L["LINE_TYPE_TABLE"][3][14] = { COMMANDS = { "guild", "g", "gc" }, DESCRIPTION = "Sends a chat message to your guild." }
L["LINE_TYPE_TABLE"][3][15] = { COMMANDS = { "join", "channel", "chan" }, DESCRIPTION = "Joins or creates a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][16] = { COMMANDS = { "leave", "chatleave", "chatexit" }, DESCRIPTION = "Leaves a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][17] = { COMMANDS = { "moderator", "mod" }, DESCRIPTION = "Sets moderation in a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][18] = { COMMANDS = { "mute", "squelch", "unvoice" }, DESCRIPTION = "Prevents a user from speaking (voice or text) in a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][19] = { COMMANDS = { "officer", "o", "osay" }, DESCRIPTION = "Sends a chat message to your guild's officer channel." }
L["LINE_TYPE_TABLE"][3][20] = { COMMANDS = { "owner" }, DESCRIPTION = "Displays or changes the owner of a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][21] = { COMMANDS = { "password", "pass" }, DESCRIPTION = "Sets or removes a password on a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][22] = { COMMANDS = { "party", "p" }, DESCRIPTION = "Sends a chat message to your party." }
L["LINE_TYPE_TABLE"][3][23] = { COMMANDS = { "raid", "rsay" }, DESCRIPTION = "Sends a chat message to your raid." }
L["LINE_TYPE_TABLE"][3][24] = { COMMANDS = { "raidwarning", "rw" }, DESCRIPTION = "Sends a raid warning to your raid." }
L["LINE_TYPE_TABLE"][3][25] = { COMMANDS = { "reply", "r" }, DESCRIPTION = "Replies to the last user to send you a whisper with a message." }
L["LINE_TYPE_TABLE"][3][26] = { COMMANDS = { "resetchat" }, DESCRIPTION = "Resets chat settings to default." }
L["LINE_TYPE_TABLE"][3][27] = { COMMANDS = { "say", "s" }, DESCRIPTION = "Sends a chat message to players in your immediate local area." }
L["LINE_TYPE_TABLE"][3][28] = { COMMANDS = { "unban" }, DESCRIPTION = "Unbans a user from a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][29] = { COMMANDS = { "unmoderator", "unmod" }, DESCRIPTION = "Removes moderation from a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][30] = { COMMANDS = { "unmute", "unsquelch", "voice" }, DESCRIPTION = "Allows a user to speak (voice or text) in a user-created chat channel." }
L["LINE_TYPE_TABLE"][3][31] = { COMMANDS = { "whisper", "w", "tell", "t", "send" }, DESCRIPTION = "Sends a private chat message to a player in a whisper." }
L["LINE_TYPE_TABLE"][3][32] = { COMMANDS = { "yell", "y", "sh", "shout" }, DESCRIPTION = "Sends a chat message to all players in your zone." }

-- Character Commands
L["LINE_TYPE_TABLE"][4][1] = { COMMANDS = { "dismount" }, DESCRIPTION = "Dismounts your character." }
L["LINE_TYPE_TABLE"][4][2] = { COMMANDS = { "equip", "eq" }, DESCRIPTION = "Equip an item to its default slot." }
L["LINE_TYPE_TABLE"][4][3] = { COMMANDS = { "equipset" }, DESCRIPTION = "Change equipped items to a set stored in the Equipment Manager." }
L["LINE_TYPE_TABLE"][4][4] = { COMMANDS = { "equipslot" }, DESCRIPTION = "Equip an item to a specific slot." }
L["LINE_TYPE_TABLE"][4][5] = { COMMANDS = { "friend", "friends" }, DESCRIPTION = "Adds a player to your Friends list." }
L["LINE_TYPE_TABLE"][4][6] = { COMMANDS = { "follow", "fol", "f" }, DESCRIPTION = "Set yourself to follow the selected target." }
L["LINE_TYPE_TABLE"][4][7] = { COMMANDS = { "ignore" }, DESCRIPTION = "Adds a player to your ignore list." }
L["LINE_TYPE_TABLE"][4][8] = { COMMANDS = { "inspect", "ins" }, DESCRIPTION = "Opens the Inspection interface of the selected target." }
L["LINE_TYPE_TABLE"][4][9] = { COMMANDS = { "leavevehicle" }, DESCRIPTION = "Allows your character to exit their current vehicle." }
L["LINE_TYPE_TABLE"][4][10] = { COMMANDS = { "randompet" }, DESCRIPTION = "Summons a random companion pet (non-combat pet)." }
L["LINE_TYPE_TABLE"][4][11] = { COMMANDS = { "removefriend", "remfriend" }, DESCRIPTION = "Removes a friend from your friend list." }
L["LINE_TYPE_TABLE"][4][12] = { COMMANDS = { "settitle" }, DESCRIPTION = "Sets the active title for your character." }
L["LINE_TYPE_TABLE"][4][13] = { COMMANDS = { "trade" }, DESCRIPTION = "Opens the trade interface with your current target." }
L["LINE_TYPE_TABLE"][4][14] = { COMMANDS = { "unignore" }, DESCRIPTION = "Removes a player from your ignore list" }
L["LINE_TYPE_TABLE"][4][15] = { COMMANDS = { "usetalents" }, DESCRIPTION = "Swap to a saved talent spec." }

-- Emotes (not implemented fully yet)
L["LINE_TYPE_TABLE"][5][1] = { COMMANDS = { "absent" }, DESCRIPTION = "" }

-- Combat Commands
L["LINE_TYPE_TABLE"][6][1] = { COMMANDS = { "cancelaura" }, DESCRIPTION = "Cancels (turns off) an aura you have." }
L["LINE_TYPE_TABLE"][6][2] = { COMMANDS = { "cancelqueuedspell", "cqs" }, DESCRIPTION = "Cancels casting of the spell you have in the queue." }
L["LINE_TYPE_TABLE"][6][3] = { COMMANDS = { "cancelform" }, DESCRIPTION = "Cancels your current shapeshift form." }
L["LINE_TYPE_TABLE"][6][4] = { COMMANDS = { "cast", "spell", "use" }, DESCRIPTION = "Uses the given item or casts the given spell." }
L["LINE_TYPE_TABLE"][6][5] = { COMMANDS = { "castglyph" }, DESCRIPTION = "Activates a glyph." }
L["LINE_TYPE_TABLE"][6][6] = { COMMANDS = { "castrandom", "userandom" }, DESCRIPTION = "Casts a random spell from the given list." }
L["LINE_TYPE_TABLE"][6][7] = { COMMANDS = { "castsequence" }, DESCRIPTION = "Casts the given spells in sequential order." }
L["LINE_TYPE_TABLE"][6][8] = { COMMANDS = { "changeactionbar" }, DESCRIPTION = "Changes your current action bar page." }
L["LINE_TYPE_TABLE"][6][9] = { COMMANDS = { "duel" }, DESCRIPTION = "Challenge another player to a duel" }
L["LINE_TYPE_TABLE"][6][10] = { COMMANDS = { "forfeit", "yield", "concede" }, DESCRIPTION = "Forfeit a duel." }
L["LINE_TYPE_TABLE"][6][11] = { COMMANDS = { "pvp" }, DESCRIPTION = "Sets whether or not you are attackable by other players." }
L["LINE_TYPE_TABLE"][6][12] = { COMMANDS = { "startattack" }, DESCRIPTION = "Turns on auto-attack." }
L["LINE_TYPE_TABLE"][6][13] = { COMMANDS = { "stopattack" }, DESCRIPTION = "Turns off auto-attack." }
L["LINE_TYPE_TABLE"][6][14] = { COMMANDS = { "stopcasting" }, DESCRIPTION = "Stops casting or channeling." }
L["LINE_TYPE_TABLE"][6][15] = { COMMANDS = { "swapactionbar" }, DESCRIPTION = "Swaps between two given action bars." }

--[[
guilddemote - /gdemote,/guilddemote - Demotes a guild-member.
guilddisband - /gdisband,/guilddisband - Disbands a guild.
guildinfo - /ginfo,/guildinfo - Displays information about your guild.
guildinvite - /ginvite,/guildinvite - Invites a player to join your guild.
guildleader - /gleader,/guildleader - Makes another guild member the new Guild Master.
guildquit - /gquit,/guildquit - Removes your character from your current guild.
guildmotd - /gmotd,/guildmotd - Sets the guild Message of the Day.
guildpromote - /gpromote,/guildpromote - Promotes a guild member to the next higher rank.
guildroster - /groster,/guildroster - Opens the Guild window.
guildremove - /guildremove,/gremove,/gkick - Removes a member of your guild from your guild.
]]
-- Guild Commands
L["LINE_TYPE_TABLE"][7][1] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][2] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][3] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][4] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][5] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][6] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][7] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][8] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][9] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][7][10] = { COMMANDS = { "" }, DESCRIPTION = "" }

--[[
clearmainassist - /clearmainassist,/clearma,/mainassistoff,/maoff - Clears the current Main Assist.
clearmaintank - /clearmaintank,/clearmt,/maintankoff,/mtoff - Clears the current Main Tank.
clearworldmarker - /clearworldmarker,/cwm - Clears world markers
invite - /i,/inv,/invite - Invites a player to your party or raid.
ffa - Sets the loot method for your raid/party to Free-For-All.
group - Sets the loot method for your raid/party to Group Loot.
master - Sets the loot method for your raid/party to Master Loot.
mainassist - /mainassist,/ma - Set the main assist.
maintank - /maintank,/mt - Set the main tank.
needbeforegreed - Sets the loot method for your raid/party to Need Before Greed.
promote - /pr,/promote - Promotes the given member to Party or Raid leader.
raidinfo - Shows you what instances you are saved to, along with the Instance ID.
readycheck - Performs a ready check in your raid or party.
roundrobin - Sets the loot method for your raid/party to Round Robin.
targetmarker - /targetmarker,/tm - Sets or clears a target marker from your current target.
threshold - Sets the loot threshold to apply loot rules.
uninvite - /uninvite,/u,/un,/kick,/votekick - Removes a player from your current party or raid.
worldmarker - /worldmarker,/wm - Allows placement of world markers.
]]
-- Party and Raid Commands
L["LINE_TYPE_TABLE"][8][1] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][2] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][3] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][4] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][5] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][6] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][7] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][8] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][9] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][10] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][11] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][12] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][13] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][14] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][15] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][16] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][17] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][8][18] = { COMMANDS = { "" }, DESCRIPTION = "" }

--[[
petassist - Sets pet to assist mode. (added in version 4.2)
petattack - Sends pet to attack currently selected target.
petautocastoff - Turn off autocast for a pet spell.
petautocaston - Turn on autocast for a pet spell.
petautocasttoggle - Toggle autocast for a pet spell.
petdefensive - Set pet to defensive.
petfollow - Set pet to follow you.
petmoveto - Set pet to move to and stay at a hover-targeted location.
petpassive - Set pet to passive mode.
petstay - Set pet to stay where it is at.
]]
-- Pet Commands
L["LINE_TYPE_TABLE"][9][1] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][2] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][3] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][4] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][5] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][6] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][7] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][8] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][9] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][9][10] = { COMMANDS = { "" }, DESCRIPTION = "" }

--[[
console - Allows user to view or change global client-side options, or perform certain system commands.
click - Simulate a mouse click on a button.
disableaddons - Disables all addons and reloads the UI.
dump - Displays the value of a given variable.
enableaddons - Enables all addons and reloads the UI.
eventtrace - /eventtrace,/etrace - Allows the user to trace events in-game.
framestack - /framestack,/fstack - Allows the user to see all frames under the cursor.
help - /h,/help,/? - Displays a help message with some basic commands.
logout - /camp,/logout - Logs your character out of the game, back to the character selection screen.
macrohelp - Displays a help message with basic information about creating and using macros.
played - Displays information about your character's time logged in.
quit - /quit,/exit - Exits the game.
random - /random,/rand,/rnd,/roll - Generates a random number from 1 to 100. "/random X" rolls a number from 1 to X, "/random X Y" rolls a number from X though Y.
reload - Reloads the User Interface.
script - /script,/run - Runs a block of LUA code.
stopmacro - Stop processing the current macro.
time - Displays the current time
timetest - Used for benchmarking, also shows FPS.
who - Shows you a list of people matching filtering options.
]]
-- System Commands
L["LINE_TYPE_TABLE"][10][1] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][2] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][3] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][4] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][5] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][6] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][7] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][8] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][9] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][10] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][11] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][12] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][13] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][14] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][15] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][16] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][17] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][18] = { COMMANDS = { "" }, DESCRIPTION = "" }
L["LINE_TYPE_TABLE"][10][19] = { COMMANDS = { "" }, DESCRIPTION = "" }

-- Targeting Commands
L["LINE_TYPE_TABLE"][11][1] = { COMMANDS = { "assist", "a" }, DESCRIPTION = "Targets a player's target." }
L["LINE_TYPE_TABLE"][11][2] = { COMMANDS = { "clearfocus" }, DESCRIPTION = "Clears the current focus target." }
L["LINE_TYPE_TABLE"][11][3] = { COMMANDS = { "cleartarget" }, DESCRIPTION = "Clears the current target." }
L["LINE_TYPE_TABLE"][11][4] = { COMMANDS = { "focus" }, DESCRIPTION = "Set a focus target" }
L["LINE_TYPE_TABLE"][11][5] = { COMMANDS = { "target", "tar" }, DESCRIPTION = "Target the given unit by name." }
L["LINE_TYPE_TABLE"][11][6] = { COMMANDS = { "targetenemy" }, DESCRIPTION = "Target the given hostile unit by name." }
L["LINE_TYPE_TABLE"][11][7] = { COMMANDS = { "targetenemyplayer" }, DESCRIPTION = "Target the given hostile player by name." }
L["LINE_TYPE_TABLE"][11][8] = { COMMANDS = { "targetexact" }, DESCRIPTION = "Target the unit by exact name match." }
L["LINE_TYPE_TABLE"][11][9] = { COMMANDS = { "targetfriend" }, DESCRIPTION = "Target the friendly unit by name." }
L["LINE_TYPE_TABLE"][11][10] = { COMMANDS = { "targetfriendplayer" }, DESCRIPTION = "Target the friendly player by name." }
L["LINE_TYPE_TABLE"][11][11] = { COMMANDS = { "targetlastenemy" }, DESCRIPTION = "Target the last attackable unit you had selected." }
L["LINE_TYPE_TABLE"][11][12] = { COMMANDS = { "targetlastfriend" }, DESCRIPTION = "Target the last friendly unit you had selected." }
L["LINE_TYPE_TABLE"][11][13] = { COMMANDS = { "targetlasttarget" }, DESCRIPTION = "Target the target of the last unit you had selected." }
L["LINE_TYPE_TABLE"][11][14] = { COMMANDS = { "targetparty" }, DESCRIPTION = "Target a party member by name." }
L["LINE_TYPE_TABLE"][11][15] = { COMMANDS = { "targetraid" }, DESCRIPTION = "Target a raid member by name." }

-- Metacommands
L["LINE_TYPE_TABLE"][12][1] = { COMMANDS = { "show" }, DESCRIPTION = "Affects the button's icon on the Action Bar." }
L["LINE_TYPE_TABLE"][12][2] = { COMMANDS = { "showtooltip" }, DESCRIPTION = "Affects the button's icon and tooltip on the Action Bar." }

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
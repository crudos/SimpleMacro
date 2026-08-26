local _, ns = ...
local L = ns.L
local G = _G
-- Translator ZamestoTV
--[[
    Global Strings: SIMPLE_MACRO_STRING_*
  ]]

-- Menu
L["GLOBAL_STRING"] = {}
L["GLOBAL_STRING"]["MENU_TITLE"] = "Simple Macro"
L["GLOBAL_STRING"]["ACCOUNT_MACROS"] = "Общие макросы"
L["GLOBAL_STRING"]["CHARACTER_MACROS"] = "Макросы персонажа"
L["GLOBAL_STRING"]["CREATE"] = "Создать"
L["GLOBAL_STRING"]["GROUP"] = "Группа"
L["GLOBAL_STRING"]["ENTER_MACRO_LABEL"] = "Введите команды макроса:"
L["GLOBAL_STRING"]["SAVE"] = "Сохранить"
L["GLOBAL_STRING"]["OPEN_EDITOR"] = "Открыть редактор" -- TODO temporary
L["GLOBAL_STRING"]["CANCEL"] = "Отмена"
L["GLOBAL_STRING"]["OKAY"] = "ОК"
L["GLOBAL_STRING"]["EXIT"] = "Выход"

-- Create
L["GLOBAL_STRING"]["NEW"] = "Новый"
L["GLOBAL_STRING"]["DELETE"] = "Удалить"
L["GLOBAL_STRING"]["CHANGE"] = "Изменить имя/иконку"
L["GLOBAL_STRING"]["NUMBER"] = "номер"
L["GLOBAL_STRING"]["COMMAND"] = "команда"
L["GLOBAL_STRING"]["ADD_ARGUMENT"] = "Добавить аргумент"
L["GLOBAL_STRING"]["SET_CONDITIONALS"] = "Задать условия"
L["GLOBAL_STRING"]["ERROR"] = "ОШИБКА"
L["GLOBAL_STRING"]["MACRO_BODY_INSTRUCTIONS"] = "Введите содержимое макроса..."

-- Macro Editor
L["GLOBAL_STRING"]["MACRO_EDITOR_TITLE"] = "Редактор макросов"
L["GLOBAL_STRING"]["ADD_ARGUMENT"] = "Добавить аргумент"
L["GLOBAL_STRING"]["ADD_CONDITIONAL_GROUP"] = "Добавить группу условий"
L["GLOBAL_STRING"]["CONDITIONAL_GROUP"] = "Группа условий %d"
L["GLOBAL_STRING"]["CONDITIONAL_EDITOR_TITLE"] = "Условия"
L["GLOBAL_STRING"]["ADD_CONDITIONAL"] = "Добавить условие"
L["GLOBAL_STRING"]["PREVIOUS_ARROW"] = "<"

-- Conditional Editor
L["GLOBAL_STRING"]["CONDITIONAL_EDITOR_TITLE"] = "Редактор условий"

-- Group
L["GLOBAL_STRING"]["ADD_TO_GROUP"] = "Добавить в группу"
L["GLOBAL_STRING"]["CHANGE_TARGET"] = "Изменить цель"
L["GLOBAL_STRING"]["CREATE_GROUP"] = "Создать группу"
L["GLOBAL_STRING"]["DELETE_FROM_GROUP"] = "Удалить из группы"


local function loadGlobalStrings()
  for i, j in pairs(L["GLOBAL_STRING"]) do
    G["SIMPLE_MACRO_STRING_"..i] = j
  end
end

loadGlobalStrings()

--[[
    Other strings
  ]]

-- Create frame
L["CREATE_FRAME"] = {}
L["CREATE_FRAME"]["SIMPLE_MODE"] = "Простой режим"

-- Settings
L["SETTINGS"] = {}
L["SETTINGS"]["TITLE"] = "SimpleMacro"
L["SETTINGS"]["GROUP_TARGET_LABEL"] = "Цели групп"
L["SETTINGS"]["GROUP_TARGET_TOOLTIP"] = "Настройки, связанные с обновлением целей макросов групп."
L["SETTINGS"]["CONTEXT_MENU_NAME"] = "Добавить в контекстное меню"
L["SETTINGS"]["CONTEXT_MENU_TOOLTIP"] = "Добавляет кнопки в контекстное меню (ПКМ) для обновления цели группы."
L["SETTINGS"]["CONTEXT_MENU_BUTTON_TEXT"] = "Задать цель группы %d"
L["SETTINGS"]["AUTO_ARENA_NAME"] = "При входе в 3v3"
L["SETTINGS"]["AUTO_ARENA_TOOLTIP"] = "Автоматически обновлять цели макросов групп при входе в арену 3v3 или одиночную потасовку. (настройка на персонажа, требует перезагрузки интерфейса при включении/отключении)"
L["SETTINGS"]["AUTO_ARENA_ORDER_NAME"] = "Порядок"
L["SETTINGS"]["AUTO_ARENA_ORDER_TOOLTIP"] = "Определяет порядок игроков для обновления групп ниже."
L["SETTINGS"]["AUTO_ARENA_ORDER_POSITION"] = "Положение"
L["SETTINGS"]["AUTO_ARENA_ORDER_POSITION_TOOLTIP"] = "Сверху вниз."
L["SETTINGS"]["AUTO_ARENA_ORDER_ROLE_NAME"] = "Роль, имя"
L["SETTINGS"]["AUTO_ARENA_ORDER_ROLE_NAME_TOOLTIP"] = "По роли (Танк > ДПС > Хилер), затем по имени (А-Я)"
L["SETTINGS"]["AUTO_ARENA_ORDER_NAME_ROLE"] = "Имя, роль"
L["SETTINGS"]["AUTO_ARENA_ORDER_NAME_ROLE_TOOLTIP"] = "По имени, затем по роли"
L["SETTINGS"]["AUTO_ARENA_GROUP1_NAME"] = "Первая группа"
L["SETTINGS"]["AUTO_ARENA_GROUP1_TOOLTIP"] = "Цель этой группы обновится на первого игрока."
L["SETTINGS"]["AUTO_ARENA_GROUP2_NAME"] = "Вторая группа"
L["SETTINGS"]["AUTO_ARENA_GROUP2_TOOLTIP"] = "Цель этой группы обновится на второго игрока."
L["SETTINGS"]["AUTO_ARENA_GROUP_OPTION"] = "Группа %d"
L["SETTINGS"]["AUTO_ARENA_NONE_OPTION"] = "Нет"

-- Change menu
L["CHANGE"] = {}
L["CHANGE"]["Name"] = "Введите имя (макс. 16 символов):"
L["CHANGE"]["Icon"] = "Выберите иконку:"

-- Popup menu
L["LINES_TITLE"] = "Строки"
L["ARGS_TITLE"] = "Аргументы"
L["LINES_COMMAND_COLUMN"] = "Команда"
L["ARGS_ARGUMENT_COLUMN"] = "Аргумент"

L["LINE_TYPE_DROPDOWN_LABEL"] = "Тип строки"
L["LINE_TYPE_CATEGORY_LABEL"] = "Категория"
L["LINE_TYPE_COMMAND_LABEL"] = "Команда"
L["LINE_TYPE_TOOLTIP"] = "Эта строка начнётся с "
L["LINE_TYPE_TOOLTIP_NONE"] = "Нет команды."

L["MACRO_EDITOR"] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][1] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][5] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11] = {}
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][12] = {}

-- Command Categories
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][1]["CATEGORY"] = "PvP"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2]["CATEGORY"] = "Интерфейс Blizzard"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3]["CATEGORY"] = "Чат"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4]["CATEGORY"] = "Персонаж"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][5]["CATEGORY"] = "Эмоции"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6]["CATEGORY"] = "Бой"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7]["CATEGORY"] = "Гильдия"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8]["CATEGORY"] = "Группа/рейд"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9]["CATEGORY"] = "Питомец"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10]["CATEGORY"] = "Система"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11]["CATEGORY"] = "Цели"
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][12]["CATEGORY"] = "Метакоманды"

-- PVP Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][1][1] = { COMMANDS = { "duel" }, DESCRIPTION = "Вызвать другого игрока на дуэль" }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][1][2] = { COMMANDS = { "forfeit", "yield", "concede" }, DESCRIPTION = "Сдаться в дуэли." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][1][3] = { COMMANDS = { "pvp" }, DESCRIPTION = "Включает/отключает режим PvP." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][1][4] = { COMMANDS = { "wargame", "wg" }, DESCRIPTION = "Начать военную игру." }

-- Blizzard Interface Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][1] = { COMMANDS = { "achievements", "ach", "achieve", "achievement" }, DESCRIPTION = "Открыть интерфейс достижений." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][2] = { COMMANDS = { "calendar" }, DESCRIPTION = "Открыть календарь." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][3] = { COMMANDS = { "guildfinder", "gf" }, DESCRIPTION = "Открыть инструмент поиска гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][4] = { COMMANDS = { "lfg", "lfd", "df", "dungeonfinder" }, DESCRIPTION = "Открыть поиск подземелий." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][5] = { COMMANDS = { "lfr", "raidbrowser", "rb", "or", "otherraids" }, DESCRIPTION = "Открыть поиск рейдов." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][6] = { COMMANDS = { "macro", "m" }, DESCRIPTION = "Открыть интерфейс макросов." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][2][7] = { COMMANDS = { "stopwatch", "timer", "sw" }, DESCRIPTION = "Открыть секундомер." }

-- Chat Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][1]   = { COMMANDS = { "afk", "away" }, DESCRIPTION = "Отметить как «Отошёл»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][2]   = { COMMANDS = { "announce", "ann" }, DESCRIPTION = "Вкл/выкл объявления в канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][3]   = { COMMANDS = { "ban" }, DESCRIPTION = "Забанить пользователя в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][4]   = { COMMANDS = { "battleground", "bg" }, DESCRIPTION = "Отправить сообщение в чат поля боя." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][5]   = { COMMANDS = { "csay", "c" }, DESCRIPTION = "Отправить текст в указанный канал." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][6]   = { COMMANDS = { "cinvite", "chatinvite" }, DESCRIPTION = "Пригласить пользователя в пользовательский канал." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][7]   = { COMMANDS = { "chatlist", "chatwho", "chatinfo" }, DESCRIPTION = "Показать список участников канала или каналы, в которых вы состоите." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][8]   = { COMMANDS = { "chatlog" }, DESCRIPTION = "Вкл/выкл лог чата." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][9]   = { COMMANDS = { "combatlog" }, DESCRIPTION = "Вкл/выкл лог боя." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][10]  = { COMMANDS = { "chat", "chathelp" }, DESCRIPTION = "Показать список часто используемых команд чата." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][11]  = { COMMANDS = { "ckick" }, DESCRIPTION = "Выгнать пользователя из пользовательского канала." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][12]  = { COMMANDS = { "emote", "em", "e", "me" }, DESCRIPTION = "Выполнить эмоцию с указанным текстом." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][13]  = { COMMANDS = { "dnd", "busy" }, DESCRIPTION = "Отметить как «Не беспокоить»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][14]  = { COMMANDS = { "guild", "g", "gc" }, DESCRIPTION = "Отправить сообщение в гильдию." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][15]  = { COMMANDS = { "join", "channel", "chan" }, DESCRIPTION = "Войти или создать пользовательский канал." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][16]  = { COMMANDS = { "leave", "chatleave", "chatexit" }, DESCRIPTION = "Покинуть пользовательский канал." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][17]  = { COMMANDS = { "moderator", "mod" }, DESCRIPTION = "Назначить модератора в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][18]  = { COMMANDS = { "mute", "squelch", "unvoice" }, DESCRIPTION = "Запретить пользователю говорить в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][19]  = { COMMANDS = { "officer", "o", "osay" }, DESCRIPTION = "Отправить сообщение в офицерский чат гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][20]  = { COMMANDS = { "owner" }, DESCRIPTION = "Показать или сменить владельца пользовательского канала." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][21]  = { COMMANDS = { "password", "pass" }, DESCRIPTION = "Установить или убрать пароль в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][22]  = { COMMANDS = { "party", "p" }, DESCRIPTION = "Отправить сообщение в группу." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][23]  = { COMMANDS = { "raid", "rsay" }, DESCRIPTION = "Отправить сообщение в рейд." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][24]  = { COMMANDS = { "raidwarning", "rw" }, DESCRIPTION = "Отправить предупреждение рейду." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][25]  = { COMMANDS = { "reply", "r" }, DESCRIPTION = "Ответить на последнее личное сообщение." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][26]  = { COMMANDS = { "resetchat" }, DESCRIPTION = "Сбросить настройки чата на стандартные." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][27]  = { COMMANDS = { "say", "s" }, DESCRIPTION = "Отправить сообщение в /сказать (локально)." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][28]  = { COMMANDS = { "unban" }, DESCRIPTION = "Разбанить пользователя в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][29]  = { COMMANDS = { "unmoderator", "unmod" }, DESCRIPTION = "Снять статус модератора в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][30]  = { COMMANDS = { "unmute", "unsquelch", "voice" }, DESCRIPTION = "Разрешить пользователю говорить в пользовательском канале." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][31]  = { COMMANDS = { "whisper", "w", "tell", "t", "send" }, DESCRIPTION = "Отправить личное сообщение игроку." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][3][32]  = { COMMANDS = { "yell", "y", "sh", "shout" }, DESCRIPTION = "Отправить сообщение в /крик (по всей зоне)." }

-- Character Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][1]   = { COMMANDS = { "dismount" }, DESCRIPTION = "Слезть с ездового животного." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][2]   = { COMMANDS = { "equip", "eq" }, DESCRIPTION = "Надеть предмет в стандартный слот." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][3]   = { COMMANDS = { "equipset" }, DESCRIPTION = "Сменить экипировку на сохранённый комплект." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][4]   = { COMMANDS = { "equipslot" }, DESCRIPTION = "Надеть предмет в указанный слот." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][5]   = { COMMANDS = { "friend", "friends" }, DESCRIPTION = "Добавить игрока в список друзей." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][6]   = { COMMANDS = { "follow", "fol", "f" }, DESCRIPTION = "Следовать за выбранной целью." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][7]   = { COMMANDS = { "ignore" }, DESCRIPTION = "Добавить игрока в чёрный список." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][8]   = { COMMANDS = { "inspect", "ins" }, DESCRIPTION = "Открыть окно осмотра выбранной цели." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][9]   = { COMMANDS = { "leavevehicle" }, DESCRIPTION = "Выйти из транспорта." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][10]  = { COMMANDS = { "randompet" }, DESCRIPTION = "Призвать случайного спутника (не боевого питомца)." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][11]  = { COMMANDS = { "removefriend", "remfriend" }, DESCRIPTION = "Убрать игрока из списка друзей." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][12]  = { COMMANDS = { "settitle" }, DESCRIPTION = "Установить активное звание персонажа." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][13]  = { COMMANDS = { "trade" }, DESCRIPTION = "Открыть окно торговли с текущей целью." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][14]  = { COMMANDS = { "unignore" }, DESCRIPTION = "Убрать игрока из чёрного списка." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][4][15]  = { COMMANDS = { "usetalents" }, DESCRIPTION = "Переключиться на сохранённую специализацию." }

-- Emotes (not implemented fully yet)
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][5][1] = { COMMANDS = { "absent" }, DESCRIPTION = "" }

-- Combat Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][1]  = { COMMANDS = { "cancelaura" }, DESCRIPTION = "Снять (отключить) ауру." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][2]  = { COMMANDS = { "cancelqueuedspell", "cqs" }, DESCRIPTION = "Отменить заклинание из очереди." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][3]  = { COMMANDS = { "cancelform" }, DESCRIPTION = "Выйти из текущего облика." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][4]  = { COMMANDS = { "cast", "spell", "use" }, DESCRIPTION = "Использовать предмет или произнести заклинание." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][5]  = { COMMANDS = { "castglyph" }, DESCRIPTION = "Активировать символ." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][6]  = { COMMANDS = { "castrandom", "userandom" }, DESCRIPTION = "Произнести случайное заклинание из списка." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][7]  = { COMMANDS = { "castsequence" }, DESCRIPTION = "Произносить заклинания по очереди." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][8]  = { COMMANDS = { "changeactionbar" }, DESCRIPTION = "Сменить страницу панели команд." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][9]  = { COMMANDS = { "startattack" }, DESCRIPTION = "Включить автоатаку." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][10] = { COMMANDS = { "stopattack" }, DESCRIPTION = "Выключить автоатаку." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][11] = { COMMANDS = { "stopcasting" }, DESCRIPTION = "Прервать произнесение или поддержание заклинания." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][6][12] = { COMMANDS = { "swapactionbar" }, DESCRIPTION = "Переключаться между двумя указанными панелями команд." }

-- Guild Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][1]  = { COMMANDS = { "guilddemote", "gdemote" }, DESCRIPTION = "Понизить члена гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][2]  = { COMMANDS = { "guilddisband", "gdisband" }, DESCRIPTION = "Распустить гильдию." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][3]  = { COMMANDS = { "guildinfo", "ginfo" }, DESCRIPTION = "Показать информацию о гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][4]  = { COMMANDS = { "guildinvite", "ginvite" }, DESCRIPTION = "Пригласить игрока в гильдию." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][5]  = { COMMANDS = { "guildleader", "gleader" }, DESCRIPTION = "Назначить нового главу гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][6]  = { COMMANDS = { "guildquit", "gquit" }, DESCRIPTION = "Покинуть гильдию." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][7]  = { COMMANDS = { "guildmotd", "gmotd" }, DESCRIPTION = "Установить сообщение дня гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][8]  = { COMMANDS = { "guildpromote", "gpromote" }, DESCRIPTION = "Повысить члена гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][9]  = { COMMANDS = { "guildroster", "groster" }, DESCRIPTION = "Открыть окно гильдии." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][7][10] = { COMMANDS = { "guildremove", "gremove", "gkick" }, DESCRIPTION = "Исключить члена гильдии." }

-- Party and Raid Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][1]   = { COMMANDS = { "clearmainassist", "clearma", "mainassistoff", "maoff" }, DESCRIPTION = "Снять метку главного помощника." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][2]   = { COMMANDS = { "clearmaintank", "clearmt", "maintankoff", "mtoff" }, DESCRIPTION = "Снять метку главного танка." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][3]   = { COMMANDS = { "clearworldmarker", "cwm" }, DESCRIPTION = "Убрать все мировые метки." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][4]   = { COMMANDS = { "invite", "inv", "i" }, DESCRIPTION = "Пригласить игрока в группу или рейд." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][5]   = { COMMANDS = { "ffa" }, DESCRIPTION = "Установить метод лута «Каждый за себя»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][6]   = { COMMANDS = { "group" }, DESCRIPTION = "Установить метод лута «Групповой»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][7]   = { COMMANDS = { "master" }, DESCRIPTION = "Установить метод лута «Мастер-лут»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][8]   = { COMMANDS = { "mainassist", "ma" }, DESCRIPTION = "Назначить главного помощника." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][9]   = { COMMANDS = { "maintank", "mt" }, DESCRIPTION = "Назначить главного танка." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][10]  = { COMMANDS = { "needbeforegreed" }, DESCRIPTION = "Установить метод лута «Нужно прежде жадности»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][11]  = { COMMANDS = { "promote", "pr" }, DESCRIPTION = "Передать лидерство в группе или рейде." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][12]  = { COMMANDS = { "raidinfo" }, DESCRIPTION = "Показать сохранённые подземелья и ID блокировок." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][13]  = { COMMANDS = { "readycheck" }, DESCRIPTION = "Провести проверку готовности." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][14]  = { COMMANDS = { "roundrobin" }, DESCRIPTION = "Установить метод лута «По очереди»." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][15]  = { COMMANDS = { "targetmarker", "tm" }, DESCRIPTION = "Поставить или убрать метку на цель." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][16]  = { COMMANDS = { "threshold" }, DESCRIPTION = "Установить порог качества для применения правил лута." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][17]  = { COMMANDS = { "uninvite", "u", "un", "kick", "votekick" }, DESCRIPTION = "Исключить игрока из группы или рейда." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][8][18]  = { COMMANDS = { "worldmarker", "wm" }, DESCRIPTION = "Разрешить ставить мировые метки." }

-- Pet Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][1]  = { COMMANDS = { "petassist" }, DESCRIPTION = "Установить питомца в режим помощи. (добавлено в версии 4.2)" }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][2]  = { COMMANDS = { "petattack" }, DESCRIPTION = "Отправить питомца атаковать выбранную цель." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][3]  = { COMMANDS = { "petautocastoff" }, DESCRIPTION = "Выключить автоприменение заклинания питомца." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][4]  = { COMMANDS = { "petautocaston" }, DESCRIPTION = "Включить автоприменение заклинания питомца." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][5]  = { COMMANDS = { "petautocasttoggle" }, DESCRIPTION = "Переключить автоприменение заклинания питомца." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][6]  = { COMMANDS = { "petdefensive" }, DESCRIPTION = "Установить питомца в защитный режим." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][7]  = { COMMANDS = { "petfollow" }, DESCRIPTION = "Питомец следует за вами." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][8]  = { COMMANDS = { "petmoveto" }, DESCRIPTION = "Переместить питомца в позицию под курсором и остаться там." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][9]  = { COMMANDS = { "petpassive" }, DESCRIPTION = "Установить питомца в пассивный режим." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][9][10] = { COMMANDS = { "petstay" }, DESCRIPTION = "Питомец остаётся на месте." }

-- System Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][1] = { COMMANDS = { "console" }, DESCRIPTION = "Выполнить консольную команду." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][2] = { COMMANDS = { "disableaddons" }, DESCRIPTION = "Отключить все аддоны и перезагрузить интерфейс." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][3] = { COMMANDS = { "dismount" }, DESCRIPTION = "Слезть с маунта." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][4] = { COMMANDS = { "dump" }, DESCRIPTION = "Показать значение переменной." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][5] = { COMMANDS = { "enableaddons" }, DESCRIPTION = "Включить все аддоны и перезагрузить интерфейс." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][6] = { COMMANDS = { "eventtrace", "etrace" }, DESCRIPTION = "Отслеживать события в игре." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][7] = { COMMANDS = { "framestack", "fstack" }, DESCRIPTION = "Показать все фреймы под курсором." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][8] = { COMMANDS = { "help", "h", "?" }, DESCRIPTION = "Показать справку с базовыми командами." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][9] = { COMMANDS = { "logout", "camp" }, DESCRIPTION = "Выйти из игры в меню выбора персонажа." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][10] = { COMMANDS = { "macrohelp" }, DESCRIPTION = "Показать справку по созданию и использованию макросов." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][11] = { COMMANDS = { "played" }, DESCRIPTION = "Показать время в игре." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][12] = { COMMANDS = { "quit", "exit" }, DESCRIPTION = "Выйти из игры." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][13] = { COMMANDS = { "random", "rand", "rnd", "roll" }, DESCRIPTION = "Сгенерировать случайное число от 1 до 100. «/random X» — от 1 до X, «/random X Y» — от X до Y." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][14] = { COMMANDS = { "reload" }, DESCRIPTION = "Перезагрузить интерфейс." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][15] = { COMMANDS = { "script", "run" }, DESCRIPTION = "Выполнить код LUA." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][16] = { COMMANDS = { "stopmacro" }, DESCRIPTION = "Остановить выполнение текущего макроса." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][17] = { COMMANDS = { "time" }, DESCRIPTION = "Показать текущее время." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][18] = { COMMANDS = { "timetest" }, DESCRIPTION = "Для бенчмаркинга, также показывает FPS." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][10][19] = { COMMANDS = { "who" }, DESCRIPTION = "Показать список людей по фильтру." }

-- Targeting Commands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][1] = { COMMANDS = { "assist", "a" }, DESCRIPTION = "Выбрать цель цели игрока." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][2] = { COMMANDS = { "clearfocus" }, DESCRIPTION = "Очистить фокус." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][3] = { COMMANDS = { "cleartarget" }, DESCRIPTION = "Очистить цель." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][4] = { COMMANDS = { "focus" }, DESCRIPTION = "Задать фокус." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][5] = { COMMANDS = { "target", "tar" }, DESCRIPTION = "Выбрать юнита по имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][6] = { COMMANDS = { "targetenemy" }, DESCRIPTION = "Выбрать враждебного юнита по имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][7] = { COMMANDS = { "targetenemyplayer" }, DESCRIPTION = "Выбрать враждебного игрока по имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][8] = { COMMANDS = { "targetexact" }, DESCRIPTION = "Выбрать юнита по точному имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][9] = { COMMANDS = { "targetfriend" }, DESCRIPTION = "Выбрать дружественного юнита по имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][10] = { COMMANDS = { "targetfriendplayer" }, DESCRIPTION = "Выбрать дружественного игрока по имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][11] = { COMMANDS = { "targetlastenemy" }, DESCRIPTION = "Выбрать последнего атакуемого юнита." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][12] = { COMMANDS = { "targetlastfriend" }, DESCRIPTION = "Выбрать последнего дружественного юнита." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][13] = { COMMANDS = { "targetlasttarget" }, DESCRIPTION = "Выбрать цель последнего юнита." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][14] = { COMMANDS = { "targetparty" }, DESCRIPTION = "Выбрать члена группы по имени." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][11][15] = { COMMANDS = { "targetraid" }, DESCRIPTION = "Выбрать члена рейда по имени." }

-- Metacommands
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][12][1] = { COMMANDS = { "show" }, DESCRIPTION = "Изменяет иконку кнопки на панели команд." }
L["MACRO_EDITOR"]["LINE_TYPE_TABLE"][12][2] = { COMMANDS = { "showtooltip" }, DESCRIPTION = "Изменяет иконку и подсказку кнопки на панели команд." }

-- Conditional descriptions
L["CONDITIONAL_EDITOR"] = {}
L["CONDITIONAL_EDITOR"]["DESCRIPTION"] = {}
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][1] = "Использовать как цель. Может быть имя или идентификатор вроде focus/mouseover/party1/arena1."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][2] = "Выбрана (конкретная) страница панели команд."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][3] = "Основная панель команд заменена (конкретной) бонусной панелью."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][4] = "Макрос активирован указанной кнопкой мыши."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][5] = "Игрок в транспорте и может выйти."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][6] = "Игрок читает указанное заклинание."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][7] = "Курсор держит предмет/способность/макрос и т.д."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][8] = "Игрок в бою."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][9] = "Цель существует и мертва."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][10] = "Надет предмет указанного типа (слот инвентаря, тип предмета или подтип)."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][11] = "Цель существует."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][12] = "Игрок имеет дополнительную панель/кнопку действий."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][13] = "Игрок может использовать летающее ездовое животное в этой зоне."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][14] = "На земле или в полёте И в воздухе."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][15] = "В облике или стойке вроде [Форма медведя], [Форма Тьмы], [Метаморфоза], [Боевая стойка] и т.д."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][16] = "Игрок в группе указанного типа (если аргумент опущен — по умолчанию группа)."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][17] = "Цель существует и на неё можно применить вредные заклинания (например, [Огненный шар])."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][18] = "Цель существует и на неё можно применить полезные заклинания (например, [Исцеление])."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][19] = "Игрок внутри помещения."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][20] = "Проверить, выучен ли талант. Работает с именами и ID заклинаний. Работает с #showtooltip."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][21] = "Удерживается указанная клавиша."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][22] = "Игрок на маунте."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][23] = "Игрок снаружи."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][24] = "Основная панель команд заменена панелью переопределения."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][25] = "Цель существует и в вашей группе."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][26] = "Вызван указанный питомец."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][27] = "Участвует в битве питомцев."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][28] = "Основная панель команд заменена панелью одержимости."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][29] = "Цель существует и в вашем рейде/группе."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][30] = "Игрок отдыхает."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][31] = "Основная панель команд заменена временной панелью облика."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][32] = "Активная группа специализации (спек, таланты и символы)."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][33] = "Игрок в скрытности."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][34] = "Игрок плывёт."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][35] = "Активирован указанный талант."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][36] = "У цели интерфейс транспорта."
L["CONDITIONAL_EDITOR"]["DESCRIPTION"][37] = "У игрока интерфейс транспорта."

L["USE_ALTERNATES"] = "Использовать альтернативный текст"
L["USE_ALTERNATES_DESC"] = "Заменяет все подходящие условия на более короткие альтернативы."

-- Group tab
L["GROUP_TAB"] = {}
L["GROUP_TAB"]["TAB_TEXT"] = "Группа"

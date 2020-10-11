--main--
local field_test2 = { }; --объявление таблицы поля
combo = 0;
field_test2 = require("field_class"); --обращение к библиотеке класса поля
field_test2 = field_test2:init(10, 10); --инициация поля
repeat
  combo = field_test2:tick(); --устранение сгенерированных комбо
until combo < 3;
field_test2 = field_test2:mix(); --контроль возможности хода
field_test2:dump(); -- вывод поля
local func;
repeat --основной цикл игры
  local command = io.read("*line");--чтение команды
  func, arg1, arg2, arg3 = string.match(command, "(%a+)%s*(%d+)%s*(%d+)%s*(%a+)"); --разбиение строки команды
  if func == nil then
    func = string.match(command, "(%a+)");--проверка на односоставную команду
  end;
  local ind = 0;
  if arg3 == 'q' then
    func = 'q'; --проверка третьего аргумента на команду выхода
  end;
  if func == 'm' then --если заданна команда смещения гема
    arg1 = tonumber(arg1) + 1;--преобразование из строки в число
    arg2 = tonumber(arg2) + 1;--преобразование из строки в число
    field_test2:move(arg1, arg2, arg3); --вызов метода обмена местами гемов
    field_test2:dump(); --вывод поля
    combo = field_test2:tick(); --проверка на образование комбо
    if combo < 3 then
      field_test2:move(arg1, arg2, arg3); --если передвежением комбо не образованно, камни меняются местами обратно
    end;
    field_test2:dump(); -- вывод поля
    repeat
      ind = ind + 1;
      combo = field_test2:tick(); -- очистка поля от комбо
    until combo < 3;
    if ind > 1 then
      field_test2:dump(); --если метод очистки менял поле, оно выводиться
  end;
  field_test2 = field_test2:mix();
  field_test2:dump(); -- конечный вывод поля
  end;
until func == 'q';





--[[ поле для теста поиска возможных ходов
field_test2[1][1]["color"] = 'A'; field_test2[1][2]["color"] = 'A'; field_test2[2][1]["color"] = 'A'; field_test2[2][2]["color"] = 'A';
field_test2[3][1]["color"] = 'B'; field_test2[3][2]["color"] = 'B'; field_test2[4][1]["color"] = 'B'; field_test2[4][2]["color"] = 'B';
field_test2[5][1]["color"] = 'C'; field_test2[5][2]["color"] = 'C'; field_test2[6][1]["color"] = 'C'; field_test2[6][2]["color"] = 'C'; 
field_test2[7][1]["color"] = 'D'; field_test2[7][2]["color"] = 'D'; field_test2[8][1]["color"] = 'D'; field_test2[8][2]["color"] = 'D';
field_test2[9][1]["color"] = 'E'; field_test2[9][2]["color"] = 'E'; field_test2[10][1]["color"] = 'E'; field_test2[10][2]["color"] = 'E';
field_test2[1][3]["color"] = 'F'; field_test2[1][4]["color"] = 'F'; field_test2[2][3]["color"] = 'F'; field_test2[2][4]["color"] = 'F';
field_test2[3][3]["color"] = 'E'; field_test2[3][4]["color"] = 'E'; field_test2[4][3]["color"] = 'E'; field_test2[4][4]["color"] = 'E';
field_test2[5][3]["color"] = 'A'; field_test2[5][4]["color"] = 'A'; field_test2[6][3]["color"] = 'A'; field_test2[6][4]["color"] = 'A';
field_test2[7][3]["color"] = 'B'; field_test2[7][4]["color"] = 'B'; field_test2[8][3]["color"] = 'B'; field_test2[8][4]["color"] = 'B';
field_test2[9][3]["color"] = 'C'; field_test2[9][4]["color"] = 'C'; field_test2[10][3]["color"] = 'C'; field_test2[10][4]["color"] = 'C';
field_test2[1][5]["color"] = 'D'; field_test2[1][6]["color"] = 'D'; field_test2[2][5]["color"] = 'D'; field_test2[2][6]["color"] = 'D';
field_test2[3][5]["color"] = 'C'; field_test2[3][6]["color"] = 'C'; field_test2[4][5]["color"] = 'C'; field_test2[4][6]["color"] = 'C';
field_test2[5][5]["color"] = 'F'; field_test2[5][6]["color"] = 'F'; field_test2[6][5]["color"] = 'F'; field_test2[6][6]["color"] = 'F';
field_test2[7][5]["color"] = 'E'; field_test2[7][6]["color"] = 'E'; field_test2[8][5]["color"] = 'E'; field_test2[8][6]["color"] = 'E';
field_test2[9][5]["color"] = 'A'; field_test2[9][6]["color"] = 'A'; field_test2[10][5]["color"] = 'A'; field_test2[10][6]["color"] = 'A';
field_test2[1][7]["color"] = 'B'; field_test2[1][8]["color"] = 'B'; field_test2[2][7]["color"] = 'B'; field_test2[2][8]["color"] = 'B';
field_test2[3][7]["color"] = 'A'; field_test2[3][8]["color"] = 'A'; field_test2[4][7]["color"] = 'A'; field_test2[4][8]["color"] = 'A';
field_test2[5][7]["color"] = 'D'; field_test2[5][8]["color"] = 'D'; field_test2[6][7]["color"] = 'D'; field_test2[6][8]["color"] = 'D';
field_test2[7][7]["color"] = 'C'; field_test2[7][8]["color"] = 'C'; field_test2[8][7]["color"] = 'C'; field_test2[8][8]["color"] = 'C';
field_test2[9][7]["color"] = 'F'; field_test2[9][8]["color"] = 'F'; field_test2[10][7]["color"] = 'F'; field_test2[10][8]["color"] = 'F';
field_test2[1][9]["color"] = 'C'; field_test2[1][10]["color"] = 'C'; field_test2[2][9]["color"] = 'C'; field_test2[2][10]["color"] = 'C';
field_test2[3][9]["color"] = 'F'; field_test2[3][10]["color"] = 'F'; field_test2[4][9]["color"] = 'F'; field_test2[4][10]["color"] = 'F';
field_test2[5][9]["color"] = 'B'; field_test2[5][10]["color"] = 'B'; field_test2[6][9]["color"] = 'B'; field_test2[6][10]["color"] = 'B';
field_test2[7][9]["color"] = 'E'; field_test2[7][10]["color"] = 'E'; field_test2[8][9]["color"] = 'E'; field_test2[8][10]["color"] = 'E';
field_test2[9][9]["color"] = 'A'; field_test2[9][10]["color"] = 'A'; field_test2[10][9]["color"] = 'A'; field_test2[10][10]["color"] = 'A';
--]]


local field = {}; --обьявление класса поля

--
function vector(field, x, y, dir, expl) --[[проверка, входит ли данный гем в комбо по ориентации dir ('h'- горизонтальная или 'v' - вертикальная).
  Если expl равно true, камни в комбо отмечаются для уничтожения--]]
  if field[x][y]["explode"] == false then --проверка на то, отмечены ли камни на уничтожение. Если нет, выполняется тело функции
    --объявление локальных переменных
    local summ = 0; --количество камней одинаково цвета, идущие подряд. Если summ становится больше двух, значит камни находятся в комбо
    local zero_coord = 0; --край последовательности камней одного цвета (камень, координата которого ближе всех в последовательности к нулю)
    local color = field[x][y]["color"]; -- цвет проверяемого камня
    local i = 0;--счетчик
    if dir == 'h' then--проверка направления вектора. Алгоритм для горизонтального поиска
      --цикл поиска края комбинации
      while (((x - i) >= 1) and (field[x - i][y]["color"] == color)) do
        zero_coord = x - i;
        i = i + 1;
      end;
      i = zero_coord
      --цикл, считающий длинну последовательности комбинации
      while ((i <= field["width"]) and (field[i][y]["color"] == color)) do
        summ = summ + 1;
        i = i + 1;
      end;
      --если длинна последовательности камней больше двух и камни должны отмечаться для уничтожения
      if ((summ > 2) and (expl == true)) then
        i = zero_coord;
        -- цикл, в котором камни отмечаются для последующего уничтожения
        while ((i <= field["width"]) and (field[i][y]["color"] == color)) do
          field[i][y]["explode"] = true;
          i = i + 1;
        end;
      end;
      return summ;--функция возвращает длинну найденой последовательности
    elseif dir == 'v' then -- алгоритм для вертикального поиска
      --цикл поиска края комбинации
      while (((y - i) >= 1) and (field[x][y - i]["color"] == color)) do
        zero_coord = y - i;
        i = i + 1;
      end;
      i = zero_coord;
      --цикл, считающий длинну последовательности комбинации
      while (expl == true and (i <= field["height"]) and (field[x][i]["color"] == color)) do 
        summ = summ + 1;
          i = i + 1;
      end;
      --если длинна последовательности камней больше двух и камни должны отмечаться для уничтожения
      if ((summ > 2) and (expl == true)) then
        i = zero_coord;
        while ((i <= field["height"]) and (field[x][i]["color"] == color)) do 
          field[x][i]["explode"] = true;
          i = i + 1;
        end;
      end;
      return summ;--функция возвращает длинну найденой последовательности
    end;
  end;
  return 0;--функция возвращает 0, в случае, если напровление указано неверно или клетка уже отмечена для уничтожения
end;



--
function field:tick()--проверка на наличие на поле комбо. Функция возвращяет размер самой длинной последовательности камней одного цвета
  local res = 0;
  local temp = 0;
  --циклы, переберающие все камни поля
  for i = 1, self.height do --цикл, перебирающий строки матрицы поля
    for j = 1, self.width do -- вложенный цикл, перебирающий все элементы строки i
      temp = vector(self, j, i, 'h', true);--проверка элемента на его нахождении в последовательности по горизонтали и запоминание длинны последовательности
      res = (res > temp) and res or temp;--если длинна последовательности больше предыдущих, то она заменяет старое значение res
      temp = vector(self, j, i, 'v', true);--проверка элемента на его нахождении в последовательности по вертикали и запоминание длинны последовательности
      res = (res > temp) and res or temp;--если длинна последовательности больше предыдущих, то она заменяет старое значение res
      if (self[j][i]["explode"] == true) then --если элемент отмечен для уничтожения, метод перемещает на его место верхние гемы
        self[j][i]["explode"] = false; --отмечается что камень уже уничтожен
        for i0 = i, 2, -1 do -- цикл смещение гемов по вертикале в данном столбце. Единственный пустой камень находиться на самом вверху в 1 по y (в 0 на дисплее)
          self[j][i0]["color"] = self[j][i0 - 1]["color"];--присвоение текущему в цикле гему цвета верхнего элемента
        end;
        self[j][1] = gem_new(0);--создание нового гема в самой верхней точке
      end;
    end;
  end;
  return res;--возвращение самой длинной последовательности
end;


--
function field:move(x, y, dir) --[[смена двух элементов местами.
  Элемент с которым будет происходить обмен определяется переменной dir ('u' - вверх, 'd' - вниз, 'r' - влево, 'l' - вправо)--]]
  if dir == 'u' and y > 1 then--если необходимо поменять гем с верхним и гем не является самым высоким
    color_temp = self[x][y]["color"];--запоминание цвета указанного камня
    self[x][y]["color"] = self[x][y - 1]["color"];--замена цвета указанного камня на цвет камня, находящегося сверху (или находящийся ближе к нулю по y)
    self[x][y - 1]["color"] = color_temp;--замена цвета верхнего камня на бывший цвет указанного камня.
  elseif dir == 'd' and y < self.width then --если необходимо поменять гем с нижним гемом и камень не является самым нижним
    color_temp = self[x][y]["color"];
    self[x][y]["color"] = self[x][y + 1]["color"];
    self[x][y + 1]["color"] = color_temp;
  elseif dir == 'l' and x > 1 then --если необходимо поменять гем с левым гемом и камень не является самым левым
    color_temp = self[x][y]["color"];
    self[x][y]["color"] = self[x - 1][y]["color"];
    self[x - 1][y]["color"] = color_temp;
  elseif dir == 'r' and x < self.height then --если необходимо поменять гем с правым гемом и камень не является самым правым
    color_temp = self[x][y]["color"];
    self[x][y]["color"] = self[x + 1][y]["color"];
    self[x + 1][y]["color"] = color_temp;
  else
    return nil;--если обмен невозможен, возвращается nil
  end;
  return true;--если обмен удолся, возвращается истина
end;


--
function field:dump()--визуализация поля
  local temp_string = {};--таблица, хронящая строки матрицы ввиде текстовой строки цветов гемов
  local index_string = {};--вспомогательная таблица, помогающая оформить вывод матрицы
  index_string[0] = "   ";--отступ для первых 2 строк вывода
  index_string[1] = "   ";--отступ для первых 2 строк вывода
  for i = 0, self.width - 1 do --цикл заполнения вспосогательной таблицы индексами столбцов (или значениями x)
    index_string[0] = index_string[0] .. i .. " "; --запись индекса
    index_string[1] = index_string[1] .. "-" .. " ";--запись верхней рамки
  end;
  print(index_string[0]);--вывод верхних индексов
  print(index_string[1]);--вывод верхней рамки
  for i = 1, self.height do --цикл заполнения таблицы строками матрицы
    temp_string[i] = "";
    for j = 1, self.width do
      temp_string[i] = temp_string[i] .. self[j][i]['color']; --запись в строку цвет гема
      temp_string[i] = temp_string[i] .. ' ';
    end;
    print(i - 1 .. " " .. '|' .. temp_string[i]);-- вывод строки матрицы, указав в начале вертикальный индекс и вертикальную рамку
  end;
end;

--
--[[function field:dump_t()--визуализация поля элементов по их готовности к уничтожению
temp_string = {};
  index_string = {};
  index_string[0] = "   ";
  index_string[1] = "   ";
  for i = 0, self.width - 1 do
    index_string[0] = index_string[0] .. i .. " ";
    index_string[1] = index_string[1] .. "—" .. " ";
  end;
  print(index_string[0]);
  print(index_string[1]);
  for i = 1, self.height do
    temp_string[i] = "";
    for j = 1, self.width do
      if self[j][i]['explode'] then
        temp_string[i] = temp_string[i] .. "t";
      else
        temp_string[i] = temp_string[i] .. "f";
      end;
      temp_string[i] = temp_string[i] .. ' ';
    end;
    print(i - 1 .. " " .. '|' .. temp_string[i]);
  end;
end;--]]
--
function gem_new(effect) --создание нового камня
  local gem = {color = 'A'; effect = 0; explode = false}; --[[структура ячейки.
  каждый гем имеет значение цвета, значение эффекта (для специальных видов камней) и метку для уничтожения--]]
  local temp_color = math.random(6.0);--определение цвета камня путем генерации случайных чисел
  if temp_color == 1 then
    gem.color = 'A';
  elseif temp_color == 2 then
    gem.color = 'B';
  elseif temp_color == 3 then
    gem.color = 'C';
  elseif temp_color == 4 then
    gem.color = 'D';
  elseif temp_color == 5 then
    gem.color = 'E';
  elseif temp_color == 6 then
    gem.color = 'F';
  end;
  gem.effect = effect;
  return gem;
end;
--
function field:init(height, width)--создание и заполнение поля
  local res = {};--индекс нового поля 
  res = {height = height; width = width};--определение размерности поля
  for i = 1, height do--цикл генерации камней в поле
    res[i] = {}
    for j = 1, width do
      res[i][j] = gem_new(0);
    end;
  end;
  setmetatable(res, self);
  self.__index = self;
  return res;
end;
--
function tick_chek(field) --проверка на возможность хода. Если ход возможен - возвращает true, если возможных комбинаций не осталось возвращает false.
  local res = 0;
  --циклы по перебору всех элементов
  for i = 1, field.width do --перебор строк матрицы
    for j = 1, field.height do --перебор элементов в текущей строке
      temp = field:move(j, i, 'u'); --текущий элемент меняется местами с верхним элементом
      if temp ~= nil then --если перестоновка удалась
        temp = vector(field, j, i, 'v', false); --проверка нового элемента на его нахождении в последовательности по горизонтали и запоминание длинны последовательности
        res = (res > temp) and res or temp; --если длинна последовательности больше предыдущих, то она заменяет старое значение res
        temp = vector(field, j, i, 'h', false); --проверка нового элемента на его нахождении в последовательности по вертикали и запоминание длинны последовательности
        res = (res > temp) and res or temp; --если длинна последовательности больше предыдущих, то она заменяет старое значение res
        field:move(j, i, 'u');--элементы меняются местами обратно
        if res > 2 then
          return true; --если возможная последовательность найдена, метод возвращает true
        end;
      end;
      temp = field:move(j, i, 'd'); --текущий элемент меняется местами с нижним элементом. происходят такие же проверки
      if temp ~= nil then
        temp = vector(field, j, i, 'v', false);
        res = (res > temp) and res or temp;
        temp = vector(field, j, i, 'h', false);
        res = (res > temp) and res or temp;
        field:move(j, i, 'd');
        if res > 2 then
          return true;
        end;
      end;
      temp = field:move(j, i, 'r'); --текущий элемент меняется местами с правым элементом
      if temp ~= nil then
        temp = vector(field, j, i, 'v', false);
        res = (res > temp) and res or temp;
        temp = vector(field, j, i, 'h', false);
        res = (res > temp) and res or temp;
        field:move(j, i, 'r');
        if res > 2 then
          return true;
        end;
      end;
      temp = field:move(j, i, 'l'); --текущий элемент меняется местами с левым элементом
      if temp ~= nil then
        temp = vector(field, j, i, 'v', false);
        res = (res > temp) and res or temp;
        temp = vector(field, j, i, 'h', false);
        res = (res > temp) and res or temp;
        field:move(j, i, 'l');
        if res > 2 then
          return true;
        end;
      end;
    end;
  end;
  return false; --если возможный ход не найден, возвращается false
end;
--
function field:mix() --генерация нового поля, если нет возможных ходов
  local check = tick_chek(self); --проверка на возможные ходы
    if check == false then --если возможные ходы не найденны, выполняется тело функции
      local field_new = {}; --обявляется новый индекс поля
      setmetatable(field_new, self);
      self.__index = self;
      field_new = self:init(self.height, self.width); --вызов метода создания поля
      repeat
        temp01 = field_new:tick(); --устранение комбо, сгенерированных методом создания
      until temp01 < 3;
      field_new = field_new:mix(); --вызов рекурсии на тот случай, если в новом поле нет возможных ходов
      return field_new;
    end;
    return self;
end;
--

return field;
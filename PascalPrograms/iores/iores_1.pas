program NoviceFileDemo;

{ ============================================================
  Программа показывает как безопасно работать с файлами.

  Главная идея:
    {$I-}  -- выключить автоматическую остановку при ошибке
    {$I+}  -- включить обратно
    IOResult -- проверить: была ли ошибка? (0 = всё ок)

  Компилировать: fpc NoviceFileDemo.pas
  ============================================================ }

{ ----------------------------------------------------------
  1. ЗАПИСЬ В ФАЙЛ
  ---------------------------------------------------------- }

procedure WriteToFile;
var
  F    : TextFile;  { variable for the file }
  ErrCode : Integer;
begin
  Writeln('--- Запись в файл ---');

  { Связываем переменную F с именем файла на диске }
  Assign(F, 'privet.txt');

  { Открываем файл для записи (создаём новый или перезаписываем) }
  {$I-}
  Rewrite(F);
  ErrCode := IOResult;   { сразу читаем: 0 = ok, иначе = код ошибки }
  {$I+}

  if ErrCode <> 0 then
  begin
    Writeln('Не удалось создать файл! Код ошибки: ', ErrCode);
    Exit;  { выходим из процедуры }
  end;

  { Пишем несколько строк }
  {$I-}
  Writeln(F, 'Привет из Pascal!');
  Writeln(F, 'Это вторая строка.');
  Writeln(F, 'А это третья.');
  Writeln(F, '123');
  Writeln(F, '456');
  ErrCode := IOResult;
  {$I+}

  if ErrCode <> 0 then
    Writeln('Ошибка при записи! Код: ', ErrCode)
  else
    Writeln('Строки записаны успешно.');

  { Закрываем файл -- это обязательно! }
  {$I-}
  Close(F);
  ErrCode := IOResult;
  {$I+}

  if ErrCode <> 0 then
    Writeln('Ошибка при закрытии! Код: ', ErrCode)
  else
    Writeln('Файл "privet.txt" закрыт.');
end;

{ ----------------------------------------------------------
  2. ЧТЕНИЕ ИЗ ФАЙЛА
  ---------------------------------------------------------- }

procedure ReadFromFile;
var
  F       : TextFile;
  Line  : string;   { одна строка из файла }
  LineNum   : Integer;  { номер текущей строки }
  ErrCode : Integer;
begin
  Writeln;
  Writeln('--- Чтение из файла ---');

  Assign(F, 'privet.txt');

  { Reset -- открывает файл для чтения }
  {$I-}
  Reset(F);
  ErrCode := IOResult;
  {$I+}

  if ErrCode <> 0 then
  begin
    { Код 2 = файл не найден -- самая частая ошибка }
    if ErrCode = 2 then
      Writeln('Файл не найден!')
    else
      Writeln('Не удалось открыть файл! Код: ', ErrCode);
    Exit;
  end;

  Writeln('Содержимое файла:');

  LineNum := 0;

  { Читаем пока не конец файла (EOF = End Of File) }
  while not EOF(F) do
  begin
    {$I-}
    Readln(F, Line);   { читаем одну строку }
    ErrCode := IOResult;
    {$I+}

    if ErrCode <> 0 then
    begin
      Writeln('Ошибка при чтении строки! Код: ', ErrCode);
      Break;  { прерываем цикл }
    end;

    Inc(LineNum);
    Writeln('  Строка ', LineNum, ': ', Line);
  end;

  {$I-}
  Close(F);
  ErrCode := IOResult;
  {$I+}

  if ErrCode = 0 then
    Writeln('Прочитано строк: ', LineNum);
end;

{ ----------------------------------------------------------
  3. ПРОВЕРКА: СУЩЕСТВУЕТ ЛИ ФАЙЛ
     (Трюк: пробуем открыть и смотрим IOResult)
  ---------------------------------------------------------- }

function FileExists(FileName : string) : Boolean;
var
  F       : TextFile;
  ErrCode : Integer;
begin
  Assign(F, FileName);

  {$I-}
  Reset(F);            { try to open }
  ErrCode := IOResult;
  {$I+}

  if ErrCode = 0 then
  begin
    { Получилось открыть -- значит файл есть }
    {$I-}
    Close(F);      { close immediately }
    {$I+}
    IOResult;          { clear possible close error }
    FileExists := True;
  end
  else
    FileExists := False;
end;

{ ----------------------------------------------------------
  4. ДОЗАПИСЬ В КОНЕЦ ФАЙЛА
  ---------------------------------------------------------- }

procedure AppendToFile;
var
  F       : TextFile;
  ErrCode : Integer;
begin
  Writeln;
  Writeln('--- Дозапись в конец файла ---');

  Assign(F, 'privet.txt');

  { Append -- открывает файл и ставит курсор В КОНЕЦ }
  {$I-}
  Append(F);
  ErrCode := IOResult;
  {$I+}

  if ErrCode <> 0 then
  begin
    Writeln('Не удалось открыть для дозаписи! Код: ', ErrCode);
    Exit;
  end;

  {$I-}
  Writeln(F, 'Эта строка добавлена позже.');
  Writeln(F, 'И эта тоже.');
  ErrCode := IOResult;
  {$I+}

  if ErrCode <> 0 then
    Writeln('Ошибка при дозаписи! Код: ', ErrCode)
  else
    Writeln('Две строки успешно добавлены в конец.');

  {$I-}
  Close(F);
  {$I+}
  IOResult;  { сбрасываем ошибку если была }
end;

{ ----------------------------------------------------------
  5. ПОПЫТКА ОТКРЫТЬ НЕСУЩЕСТВУЮЩИЙ ФАЙЛ
     (Показываем что {$I-} НЕ вылетает с ошибкой)
  ---------------------------------------------------------- }

procedure ShowErrorExample;
var
  F       : TextFile;
  ErrCode : Integer;
  Line  : string;
begin
  Writeln;
  Writeln('--- Пример: открываем несуществующий файл ---');

  Assign(F, 'нет_такого_файла.txt');

  {$I-}
  Reset(F);
  ErrCode := IOResult;  { будет 2 -- "файл не найден" }
  {$I+}

  { Без директивы $I- программа бы вылетела с исключением.
    С $I- мы сами обрабатываем ситуацию: }
  if ErrCode = 2 then
    Writeln('Файл не найден -- но программа НЕ вылетела!')
  else if ErrCode <> 0 then
    Writeln('Какая-то другая ошибка, код: ', ErrCode)
  else
  begin
    { if somehow opened -- read }
    Readln(F, Line);
    Close(F);
  end;
end;

{ ----------------------------------------------------------
  ГЛАВНАЯ ПРОГРАММА
  ---------------------------------------------------------- }

begin
  Writeln('========================================');
  Writeln(' Демонстрация {$I-} и IOResult');
  Writeln('========================================');
  Writeln;

  { Шаг 1: создаём файл и пишем в него }
  WriteToFile;

  { Шаг 2: читаем что написали }
  ReadFromFile;

  { Шаг 3: дозаписываем строки }
  AppendToFile;

  { Шаг 4: читаем снова -- убеждаемся что строки добавились }
  ReadFromFile;

  { Шаг 5: проверяем существование файлов }
  Writeln;
  Writeln('--- Проверка существования файлов ---');

  if FileExists('privet.txt') then
    Writeln('privet.txt -- СУЩЕСТВУЕТ')
  else
    Writeln('privet.txt -- НЕТ');

  if FileExists('нет_такого.txt') then
    Writeln('нет_такого.txt -- СУЩЕСТВУЕТ')
  else
    Writeln('нет_такого.txt -- НЕТ');

  { Шаг 6: показываем что ошибка не роняет программу }
  ShowErrorExample;

  Writeln;
  Writeln('========================================');
  Writeln(' Всё готово! Нажмите Enter...');
  Writeln('========================================');
  Readln;
end.

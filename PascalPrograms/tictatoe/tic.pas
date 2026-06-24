program TicTacToe;

{ ================================= }
{   Крестики-нолики для двух игроков }
{ ================================= }

var
  c1, c2, c3 : char;  { первая строка }
  c4, c5, c6 : char;  { вторая строка }
  c7, c8, c9 : char;  { третья строка }

  player  : char;
  winner  : char;
  moves   : integer;
  again   : char;
  wins_x  : integer;
  wins_o  : integer;
  draws   : integer;
  pos     : integer;
  valid   : boolean;

{ --- Очистить поле --- }
procedure ClearBoard;
begin
  c1 := ' '; c2 := ' '; c3 := ' ';
  c4 := ' '; c5 := ' '; c6 := ' ';
  c7 := ' '; c8 := ' '; c9 := ' ';
end;

{ --- Нарисовать поле --- }
procedure DrawBoard;
begin
  WriteLn;
  WriteLn('  Поле:             Позиции:');
  WriteLn('   ', c1, ' | ', c2, ' | ', c3, '           1 | 2 | 3');
  WriteLn('  ---+---+---       ---+---+---');
  WriteLn('   ', c4, ' | ', c5, ' | ', c6, '           4 | 5 | 6');
  WriteLn('  ---+---+---       ---+---+---');
  WriteLn('   ', c7, ' | ', c8, ' | ', c9, '           7 | 8 | 9');
  WriteLn;
end;

{ --- Получить символ клетки по номеру --- }
function GetCell(n: integer): char;
begin
  if n = 1 then GetCell := c1
  else if n = 2 then GetCell := c2
  else if n = 3 then GetCell := c3
  else if n = 4 then GetCell := c4
  else if n = 5 then GetCell := c5
  else if n = 6 then GetCell := c6
  else if n = 7 then GetCell := c7
  else if n = 8 then GetCell := c8
  else               GetCell := c9;
end;

{ --- Поставить символ в клетку по номеру --- }
procedure SetCell(n: integer; p: char);
begin
  if n = 1 then c1 := p
  else if n = 2 then c2 := p
  else if n = 3 then c3 := p
  else if n = 4 then c4 := p
  else if n = 5 then c5 := p
  else if n = 6 then c6 := p
  else if n = 7 then c7 := p
  else if n = 8 then c8 := p
  else               c9 := p;
end;

{ --- Проверить клетку на свободность --- }
function IsFree(n: integer): boolean;
begin
  IsFree := GetCell(n) = ' ';
end;

{ --- Проверить три клетки на совпадение --- }
function Line(a, b, c: integer; p: char): boolean;
begin
  Line := (GetCell(a) = p) and (GetCell(b) = p) and (GetCell(c) = p);
end;

{ --- Проверить победителя --- }
function CheckWin(p: char): boolean;
begin
  CheckWin :=
    Line(1, 2, 3, p) or  { строка 1 }
    Line(4, 5, 6, p) or  { строка 2 }
    Line(7, 8, 9, p) or  { строка 3 }
    Line(1, 4, 7, p) or  { столбец 1 }
    Line(2, 5, 8, p) or  { столбец 2 }
    Line(3, 6, 9, p) or  { столбец 3 }
    Line(1, 5, 9, p) or  { диагональ }
    Line(3, 5, 7, p);    { диагональ }
end;

{ --- Сменить игрока --- }
procedure SwitchPlayer;
begin
  if player = 'X' then
    player := 'O'
  else
    player := 'X';
end;

{ --- Напечатать статистику --- }
procedure PrintStats;
begin
  WriteLn('  +---------------------+');
  WriteLn('  |     СТАТИСТИКА      |');
  WriteLn('  +---------------------+');
  WriteLn('  |  X выиграл: ', wins_x, '      |');
  WriteLn('  |  O выиграл: ', wins_o, '      |');
  WriteLn('  |  Ничьих:    ', draws, '      |');
  WriteLn('  +---------------------+');
end;

{ --- Ввод хода с проверкой --- }
procedure GetMove;
begin
  repeat
    Write('  Игрок ', player, ', введи позицию (1-9): ');
    Read(pos);

    valid := false;

    if (pos < 1) or (pos > 9) then
      WriteLn('  Ошибка! Только цифры от 1 до 9.')
    else if not IsFree(pos) then
      WriteLn('  Клетка занята! Выбери другую.')
    else
      valid := true;

  until valid;

  SetCell(pos, player);
  moves := moves + 1;
end;

{ ================================= }
{         ГЛАВНАЯ ПРОГРАММА         }
{ ================================= }
begin
  wins_x := 0;
  wins_o := 0;
  draws  := 0;

  WriteLn('+==============================+');
  WriteLn('|      КРЕСТИКИ-НОЛИКИ         |');
  WriteLn('|      X vs O  два игрока      |');
  WriteLn('+==============================+');

  repeat
    ClearBoard;
    player := 'X';
    winner := ' ';
    moves  := 0;

    WriteLn;
    WriteLn('  Новая игра! Начинает X.');
    DrawBoard;

    repeat
      GetMove;
      DrawBoard;

      if CheckWin(player) then
      begin
        winner := player;
        WriteLn('  *** Игрок ', player, ' победил! ***');
        if player = 'X' then
          wins_x := wins_x + 1
        else
          wins_o := wins_o + 1;
      end
      else if moves = 9 then
      begin
        WriteLn('  *** Ничья! ***');
        draws := draws + 1;
      end
      else
        SwitchPlayer;

    until (winner <> ' ') or (moves = 9);

    WriteLn;
    PrintStats;
    WriteLn;
    Write('  Сыграть ещё раз? (Y/N): ');
    ReadLn;
    Read(again);
    again := UpCase(again);
    WriteLn;

  until again = 'N';

  WriteLn;
  WriteLn('  Спасибо за игру!');
  PrintStats;
end.

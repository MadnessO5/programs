program OrdinalTypesDemo;

type
  digit10 = 0..9;
  LatinCaps = 'A'..'Z';
  RainbowColors = (red, orange, yellow, green, blue, indigo, violet);
  Signals = (SigRed, SigYellow, SigGreen);

const
  Duration: array[Signals] of integer = (30, 5, 25);

var
  d: digit10;
  letter: LatinCaps;
  rc: RainbowColors;
  s: Signals;
  choice: integer;
  n: integer;
  c: char;

procedure DemoDigit;
begin
  write('Введите цифру от 0 до 9: ');
  readln(n);
  d := n;
  writeln('Вы ввели: ', d);
  writeln('ord(d) = ', ord(d));
end;

procedure DemoLatinCaps;
begin
  write('Введите заглавную латинскую букву: ');
  readln(c);
  letter := c;
  writeln('Вы ввели: ', letter);
  writeln('ord(letter) = ', ord(letter));
  if letter <> 'Z' then
    writeln('succ(letter) = ', succ(letter));
  if letter <> 'A' then
    writeln('pred(letter) = ', pred(letter));
end;

procedure DemoRainbow;
begin
  writeln('Цвета радуги: 0-red 1-orange 2-yellow 3-green 4-blue 5-indigo 6-violet');
  write('Введите номер цвета (0..6): ');
  readln(n);
  rc := RainbowColors(n);
  writeln('ord(rc) = ', ord(rc));
  if rc <> red then
    writeln('ord(pred(rc)) = ', ord(pred(rc)));
  if rc <> violet then
    writeln('ord(succ(rc)) = ', ord(succ(rc)));
end;

procedure DemoSignals;
begin
  writeln('Сигналы светофора: 0-SigRed 1-SigYellow 2-SigGreen');
  write('Введите номер сигнала (0..2): ');
  readln(n);
  s := Signals(n);
  case s of
    SigRed: writeln('Stop, длительность ', Duration[s], ' сек');
    SigYellow: writeln('Wait, длительность ', Duration[s], ' сек');
    SigGreen: writeln('Go, длительность ', Duration[s], ' сек');
  end;

  writeln('Досчитаем циклом до SigGreen:');
  while s <> SigGreen do
  begin
    s := succ(s);
    writeln('Текущий сигнал: ', ord(s));
  end;
end;

begin
  repeat
    writeln;
    writeln('Выберите демонстрацию:');
    writeln('1 - digit10 (0..9)');
    writeln('2 - LatinCaps (A..Z)');
    writeln('3 - RainbowColors (перечислимый тип)');
    writeln('4 - Signals (перечислимый тип со case и циклом)');
    writeln('0 - выход');
    write('Ваш выбор: ');
    readln(choice);

    case choice of
      1: DemoDigit;
      2: DemoLatinCaps;
      3: DemoRainbow;
      4: DemoSignals;
      0: writeln('Выход из программы.');
    else
      writeln('Неверный выбор, попробуйте снова.');
    end;
  until choice = 0;
end.

program UserTypesParamsDemo;

type
  MyRange = 1..100;

  CheckPoint = record
    n: integer;
    latitude, longitude: real;
    hidden: boolean;
    penalty: integer;
  end;

  CheckPointArray = array [1..75] of CheckPoint;

var
  b: MyRange;
  track: CheckPointArray;
  count, i: integer;

procedure PrintValue(v: MyRange);
begin
  writeln('Значение из диапазона MyRange: ', v);
end;

procedure FillTrack(var t: CheckPointArray; cnt: integer);
var
  i: integer;
begin
  for i := 1 to cnt do
  begin
    writeln('Пункт №', i, ':');
    t[i].n := i;

    write('  Широта: ');
    readln(t[i].latitude);

    write('  Долгота: ');
    readln(t[i].longitude);

    write('  Штраф (мин): ');
    readln(t[i].penalty);

    t[i].hidden := false;
  end;
end;

procedure PrintTrack(const t: CheckPointArray; cnt: integer);
var
  i: integer;
begin
  writeln('Сводка по дистанции:');
  for i := 1 to cnt do
    writeln('track[', i, ']: широта=', t[i].latitude:0:5,
            ' долгота=', t[i].longitude:0:5,
            ' штраф=', t[i].penalty);
end;

begin
  write('Введите значение b (1..100): ');
  readln(b);
  PrintValue(b);

  writeln;
  write('Сколько контрольных пунктов заполнить? (не более 75): ');
  readln(count);

  FillTrack(track, count);
  writeln;
  PrintTrack(track, count);
end.

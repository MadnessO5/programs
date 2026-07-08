program ComplexDataDemo;

const
  MaxCheckPoint = 75;

type
  CheckPoint = record
    n: integer;
    latitude, longitude: real;
    hidden: boolean;
    penalty: integer;
  end;

  CheckPointArray = array [1..MaxCheckPoint] of CheckPoint;
  matrix5x5 = array [1..5, 1..5] of real;

var
  track: CheckPointArray;
  m: matrix5x5;
  count, i, j: integer;
  ans: string;

begin
  write('Сколько контрольных пунктов на дистанции? (не более ', MaxCheckPoint, '): ');
  readln(count);

  for i := 1 to count do
  begin
    writeln('Пункт №', i, ':');
    track[i].n := i;

    write('  Широта: ');
    readln(track[i].latitude);

    write('  Долгота: ');
    readln(track[i].longitude);

    write('  Скрытый? (y/n): ');
    readln(ans);
    track[i].hidden := (ans = 'y') or (ans = 'Y');

    write('  Штраф (мин): ');
    readln(track[i].penalty);
  end;

  writeln;
  writeln('Сводка по дистанции:');
  for i := 1 to count do
    writeln('track[', i, ']: широта=', track[i].latitude:0:5,
            ' долгота=', track[i].longitude:0:5,
            ' скрытый=', track[i].hidden,
            ' штраф=', track[i].penalty);

  writeln;
  writeln('Теперь заполним матрицу 5x5:');
  for i := 1 to 5 do
    for j := 1 to 5 do
    begin
      write('m[', i, ',', j, '] = ');
      readln(m[i, j]);
    end;

  writeln;
  writeln('Матрица:');
  for i := 1 to 5 do
  begin
    for j := 1 to 5 do
      write(m[i, j]:8:2);
    writeln;
  end;
end.

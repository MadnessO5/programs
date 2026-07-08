program CheckPointDemo;

type
  CheckPoint = record
    n: integer;
    latitude, longitude: real;
    hidden: boolean;
    penalty: integer;
  end;

var
  cp: CheckPoint;
  ans: string;

begin
  write('Введите номер контрольного пункта: ');
  readln(cp.n);

  write('Введите широту: ');
  readln(cp.latitude);

  write('Введите долготу: ');
  readln(cp.longitude);

  write('Пункт скрытый? (y/n): ');
  readln(ans);
  cp.hidden := (ans = 'y') or (ans = 'Y');

  write('Введите штраф за невзятие пункта (мин): ');
  readln(cp.penalty);

  writeln;
  writeln('Данные контрольного пункта:');
  writeln('Номер: ', cp.n);
  writeln('Широта: ', cp.latitude:0:5);
  writeln('Долгота: ', cp.longitude:0:5);
  if cp.hidden then
    writeln('Скрытый: да')
  else
    writeln('Скрытый: нет');
  writeln('Штраф: ', cp.penalty, ' мин');

  if cp.hidden then
    writeln('Внимание: это скрытый пункт, отметьте на карте только после взятия соседних');

  if cp.penalty > 30 then
    writeln('Большой штраф, лучше не пропускать этот пункт');
end.

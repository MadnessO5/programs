program StringTypeDemo;

var
  s1: string[15];
  s2: string;
  s: string;
  c: char;

procedure AppendKadabra(var str: string);
begin
  str := str + 'kadabra';
end;

begin
  write('Введите строку до 15 символов (для s1): ');
  readln(s1);
  writeln('s1 = ', s1);
  writeln('length(s1) = ', length(s1));
  writeln('ord(s1[0]) = ', ord(s1[0]), ' (байт длины строки)');
  if length(s1) > 0 then
    writeln('s1[1] = ', s1[1]);

  writeln;
  write('Введите строку любой длины (для s2): ');
  readln(s2);
  writeln('s2 = ', s2);
  writeln('length(s2) = ', length(s2));

  writeln;
  writeln('Присвоим s2 в s1 (может обрезаться до 15 символов):');
  s1 := s2;
  writeln('s1 теперь = ', s1);
  writeln('length(s1) = ', length(s1));

  writeln;
  write('Введите начало строки (например abra): ');
  readln(s2);
  AppendKadabra(s2);
  writeln('После вызова AppendKadabra(var str: string): ', s2);
  writeln('Обратите внимание: s2 передана как var-параметр, хотя её тип string без ограничения длины,');
  writeln('а s1 (тип string[15]) тоже можно было бы передать в ту же var-параметр процедуру.');

  writeln;
  s := '';
  writeln('Пустая строка перед циклом, length(s) = ', length(s));
  for c := 'A' to 'Z' do
    s := s + c;
  writeln('Строка после накопления символов через неявное char -> string:');
  writeln(s);
end.

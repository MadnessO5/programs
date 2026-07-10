program CharArrayDemo;

var
  hello: array [1..30] of char;
  greeting: array [1..30] of char;
  i: integer;
  name: array [1..30] of char;

begin
  hello := 'Hello, world!';
  writeln('Наивный вывод массива char (видны лишние нулевые символы, ');
  writeln('но на экране они не отображаются, только занимают место):');
  writeln(hello);

  writeln;
  writeln('Правильный вывод с остановкой на первом символе #0:');
  for i := 1 to 30 do
  begin
    if hello[i] = #0 then
      break;
    write(hello[i])
  end;
  writeln;

  writeln;
  greeting := 'first'#10#9'second'#10#9#9'third'#10#9#9#9'fourth';
  writeln('Строковый литерал со вставленными кодами символов:');
  for i := 1 to 30 do
  begin
    if greeting[i] = #0 then
      break;
    write(greeting[i])
  end;
  writeln;

  writeln;
  write('Введите ваше имя (до 30 символов): ');
  readln(name);
  write('Здравствуйте, ');
  for i := 1 to 30 do
  begin
    if name[i] = #0 then
      break;
    write(name[i])
  end;
  writeln('!');
end.

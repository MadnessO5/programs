program GotoCase1;

{ Случай 1: выход из нескольких вложенных циклов }
{ Ищем два числа i и j, произведение которых = target }

label found;

var
  i, j, target: integer;

begin
  Write('Введи число для поиска произведения: ');
  Read(target);

  for i := 1 to 10000 do
    for j := 1 to 10000 do
      if i * j = target then
        goto found;

  WriteLn('Не найдено.');
  Halt;

found:
  WriteLn('Найдено: i = ', i, ', j = ', j);
  WriteLn(i, ' * ', j, ' = ', i * j);
end.

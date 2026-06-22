program HaltExitDemo;

{ exit — выходит из процедуры/функции
  halt — завершает всю программу }

procedure CheckAge(age: integer);
begin
  if age < 0 then
  begin
    WriteLn('Ошибка: возраст не может быть отрицательным!');
    exit;  { выходим из процедуры }
  end;

  if age < 18 then
    WriteLn('Ты несовершеннолетний.')
  else
    WriteLn('Ты совершеннолетний.');
end;

var
  age: integer;

begin
  WriteLn('Введи свой возраст:');
  Read(age);

  if age > 123 then
  begin
    WriteLn('Такого возраста не бывает. Программа завершена.');
    Halt;  { завершаем всю программу }
  end;

  CheckAge(age);
  WriteLn('Готово!');
end.

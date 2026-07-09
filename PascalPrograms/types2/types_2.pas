program TypeConversionDemo;

var
  r: real;
  i, j: integer;
  n: integer;
  c: char;
  code: integer;

begin
  write('Введите целое число: ');
  readln(n);
  r := n;
  writeln('Неявное преобразование integer -> real: r = ', r:0:2);

  writeln;
  write('Введите вещественное число: ');
  readln(r);
  i := trunc(r);
  j := round(r);
  writeln('trunc(r) = ', i, ' (отбрасывание дробной части)');
  writeln('round(r) = ', j, ' (округление к ближайшему целому)');

  writeln;
  write('Введите символ: ');
  readln(c);
  writeln('ord(c) = ', ord(c));
  writeln('Явное преобразование byte(c) = ', byte(c));

  writeln;
  write('Введите код символа (0..255): ');
  readln(code);
  writeln('chr(', code, ') = ', chr(code));

  writeln;
  write('Введите цифру символом (например 5): ');
  readln(c);
  writeln('integer(c) = ', integer(c), ' (код символа, а не число 5!)');
  writeln('Чтобы получить именно число 5, символ нужно распознавать через ord(c) - ord(''0'')');
  writeln('ord(c) - ord(''0'') = ', ord(c) - ord('0'));
end.

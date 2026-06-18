program RectangleArea;
var
  length, width, area: real;
begin
  write('Введите длину: ');
  readln(length);
  write('Введите ширину: ');
  readln(width);
  area := length * width;
  writeln('Площадь прямоугольника = ', area:0:2);
  readln;
end.

program PointersDemo;

type
    Point = record
        x, y: integer;
    end;

var
    a: integer;
    p: ^integer;
    r: real;
    pr: ^real;
    arr: array [1..5] of integer;
    pa: ^integer;
    pt: Point;
    pp: ^integer;

begin
    write('Введите целое число (для a): ');
    readln(a);

    p := @a;
    writeln('p указывает на a. p^ = ', p^);
    writeln('a напрямую = ', a);

    write('Изменим значение через p^. Введите новое число: ');
    readln(p^);
    writeln('Теперь a = ', a, ' (изменилось само по себе, ведь p указывает именно на a)');

    writeln;
    write('Введите число типа real (для r): ');
    readln(r);
    pr := @r;
    writeln('pr^ = ', pr^:0:3);

    writeln;
    write('Введите значение для третьего элемента массива arr: ');
    readln(arr[3]);
    pa := @arr[3];
    writeln('Адрес взят у элемента массива: pa^ = ', pa^);

    writeln;
    write('Введите значение для поля x записи pt: ');
    readln(pt.x);
    pp := @pt.x;
    writeln('Адрес взят у поля записи: pp^ = ', pp^);

    writeln;
    p := nil;
    if p = nil then
        writeln('Теперь p ни на что не указывает (p = nil)')
end.
